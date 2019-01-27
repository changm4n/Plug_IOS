//
//  Message.swift
//  Plug
//
//  Created by changmin lee on 08/12/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import Foundation
import UIKit

struct MessageItem {
    var id: String
    var chatroomId: String
    var text: String
    var receiverId: String
    var receiverName: String
    var senderId: String
    var senderName: String
    
    var createAt: Date
    var readedAt: Date?
    
    var isMine: Bool
    var timeStamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        return formatter.string(from: createAt)
    }
    
    var timeStampLong: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yy.MM.dd. (E)"
        return formatter.string(from: createAt)
    }
    let kDefault = "default"
    
    init() {
        self.id = kDefault
        self.chatroomId = kDefault
        self.text = "text"
        self.receiverId = Session.me!.userId!
        self.receiverName = kDefault
        self.senderId = "lcmini6528@gmail.com"
        self.senderName = kDefault
        self.isMine = false
        self.createAt = Date()
    }
    
    public init(with message: MessageApolloFragment, isMine: Bool) {
        id = message.id
        chatroomId = message.chatRoom.id
        text = message.text ?? ""
        receiverId = message.receivers?.first?.userId ?? ""
        receiverName = message.receivers?.first?.name ?? ""
        senderId = message.sender.userId
        senderName = message.sender.name
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        createAt = formatter.date(from: message.createdAt)!
        readedAt = formatter.date(from: message.readedAt ?? "")
        
        self.isMine = isMine
    }
}

enum MessageViewType: String {
    case BLANK = "blank"
    case STAMP = "stamp"
    case RCELL = "lcell"
    case LCELL = "rcell"
}

struct MessageViewItem {
    var messageType: MessageViewType
    var message: MessageItem?
    var isShowTime: Bool = false
    
    init(withMessage message: MessageItem? = nil, type: MessageViewType) {
        messageType = type
        if let message = message {
            self.message = message
        }
    }
}

class MessageModel: NSObject {
    private var mItems: [MessageItem] = []
    var mViewModel: [[MessageViewItem]] = []
    
    var lastIndexPath: IndexPath {
        if mViewModel.count == 0 {
            return IndexPath(row: 0, section: 0)
        } else {
            return IndexPath(row: mViewModel[mViewModel.count - 1].count - 1,
                             section: mViewModel.count - 1)
        }
        
    }
    
    override init() {
        super.init()
        mItems = []
        mViewModel = []
    }
    
    init(withMessages messages: [MessageItem]) {
        super.init()
        
        self.mItems = messages
        self.mViewModel = setViewModel(items: messages)
    }
    
    public func getIndexPath(of id:String) -> IndexPath {
        
        for (s, i) in mViewModel.enumerated() {
            for (r, j) in mViewModel[s].enumerated() {
                if j.message?.id == id {
                    return IndexPath(row: r, section: s)
                }
            }
        }
        
        return IndexPath(row: 0, section: 0)
    }
    
    public func setItems(messages: [MessageItem]) {
        self.mItems = messages
        self.mViewModel = setViewModel(items: messages)
    }
    
    public func addItemsFront(messages: [MessageItem]) -> IndexPath{
        self.mItems = messages + self.mItems
        let newVM = setViewModel(items: messages)
        mViewModel = newVM + mViewModel
        
        if newVM.count > 0 && newVM[newVM.count - 1].count > 0 {
            return IndexPath(row: newVM[newVM.count - 1].count - 1,
                             section: newVM.count - 1)
        }
        return IndexPath(row: 0, section: 0)
    }
    
    public func addMessage(newMessage: MessageItem) {
        var r = 0
        var s = 0
        if mViewModel.count > 0 {
            mViewModel[mViewModel.count - 1].removeLast()
            r = mViewModel[mViewModel.count - 1].count - 1
            s = mViewModel.count - 1
        }
        
        if let lastMessage = mViewModel.last?.last?.message {
            
            var item = MessageViewItem(withMessage: newMessage, type: newMessage.isMine  ? .RCELL : .LCELL)
            item.isShowTime = true
            
            if !lastMessage.createAt.isSameDay(rhs: newMessage.createAt) {
                mViewModel.append([MessageViewItem.init(type: .STAMP), item, MessageViewItem(type: .BLANK)])
                return
            }
            
            if lastMessage.isMine == newMessage.isMine &&
                lastMessage.createAt.isSameMin(rhs: newMessage.createAt) {
                mViewModel[s][r].isShowTime = false
            } else {
                mViewModel[mViewModel.count - 1].append(MessageViewItem(type: .BLANK))
            }
        
            mViewModel[mViewModel.count - 1].append(item)
            mViewModel[mViewModel.count - 1].append(MessageViewItem(type: .BLANK))
        } else {
            var item = MessageViewItem(withMessage: newMessage, type: newMessage.isMine  ? .RCELL : .LCELL)
            item.isShowTime = true
            mViewModel.append([MessageViewItem.init(type: .STAMP), item, MessageViewItem(type: .BLANK)])
            return
            
        }
    }
    
    public func getType(of indexPath: IndexPath) -> MessageViewType {
        return mViewModel[indexPath.section][indexPath.row].messageType
    }
    
    private func setViewModel(items: [MessageItem]) -> [[MessageViewItem]] {
        var result: [[MessageViewItem]] = []
        if items.count == 0 {
            return []
        }
        
        var tmp: [MessageViewItem] = [MessageViewItem.init(type: .STAMP)]
        
        for i in 0 ..< items.count {
            
            let current = items[i]
            var item = MessageViewItem(withMessage: current, type: current.isMine  ? .RCELL : .LCELL)
            
            if i == items.count - 1 {
                item.isShowTime = true
                tmp.append(item)
                continue
            }
            
            let next = items[i + 1]
            
            if !current.createAt.isSameDay(rhs: next.createAt) {
                item.isShowTime = true
                tmp.append(item)
                
                result.append(tmp)
                tmp = [MessageViewItem.init(type: .STAMP)]
                
                continue
            }
            
            if current.isMine != next.isMine ||
                !current.createAt.isSameMin(rhs: next.createAt) {
                item.isShowTime = true
            }
            
            tmp.append(item)
            
            if current.isMine != next.isMine ||
                !current.createAt.isSameMin(rhs: next.createAt){
                tmp.append(MessageViewItem(type: .BLANK))
            }
            
        }
        
        tmp.append(MessageViewItem(type: .BLANK))
        result.append(tmp)
        return result
    }
}

extension MessageModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = mViewModel[indexPath.section][indexPath.row]
        if item.messageType == .BLANK {
            let cell = tableView.dequeueReusableCell(withIdentifier: item.messageType.rawValue, for: indexPath)
            return cell
            
        } else if item.messageType == .RCELL {
            let cell = tableView.dequeueReusableCell(withIdentifier: item.messageType.rawValue, for: indexPath) as! ChatRCell
            cell.configure(viewItem: item)
            return cell
            
        } else if item.messageType == .LCELL {
            let cell = tableView.dequeueReusableCell(withIdentifier: item.messageType.rawValue, for: indexPath) as! ChatRCell
            cell.configure(viewItem: item)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: item.messageType.rawValue, for: indexPath) as! StampCell
            if let date = mViewModel[indexPath.section][1].message?.createAt {
                cell.setTimeStamp(date: date)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mViewModel[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mViewModel.count
    }
}
