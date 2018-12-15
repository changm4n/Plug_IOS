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
        return IndexPath(row: mViewModel[mViewModel.count - 1].count - 1,
                         section: mViewModel.count - 1)
    }
    
    
    override init() {
        super.init()
        mItems = []
        mViewModel = []
    }
    
    init(withMessages messages: [MessageItem]) {
        super.init()
        
        self.mItems = messages
        setViewModel()
    }
    
    public func setItems(messages: [MessageItem]) {
        self.mItems = messages
        setViewModel()
    }
    
    public func addNew() -> [(IndexPath, Int)] {
        return addMessage(newMessage: MessageItem())
    }
    
    public func addMessage(newMessage: MessageItem) -> [(IndexPath, Int)] {
        //Remove last blank
        mViewModel = self.reverse(array: mViewModel)
        mViewModel[mViewModel.count - 1].removeLast()
        let r = mViewModel[mViewModel.count - 1].count - 1
        let s = mViewModel.count - 1
        if let lastMessage = mViewModel.last?.last?.message {
            
            var item = MessageViewItem(withMessage: newMessage, type: newMessage.isMine  ? .RCELL : .LCELL)
            item.isShowTime = true
            
            if !lastMessage.createAt.isSameDay(rhs: newMessage.createAt) {
                mViewModel.append([MessageViewItem.init(type: .STAMP), item, MessageViewItem(type: .BLANK)])
                return [
                    (IndexPath(row: mViewModel[mViewModel.count - 2].count, section: mViewModel.count - 2), -1),
                    (IndexPath(row: 0, section: mViewModel.count - 1), 2),
                        (IndexPath(row: 0, section: mViewModel.count - 1), 1),
                        (IndexPath(row: 1, section: mViewModel.count - 1), 1),
                        (IndexPath(row: 2, section: mViewModel.count - 1), 1)]
            }
            
            var result: [(IndexPath, Int)] = []
            
            result.append(
                (IndexPath(row:  mViewModel[mViewModel.count - 1].count - 1, section: mViewModel.count - 1), 0))
            if lastMessage.isMine == newMessage.isMine &&
                lastMessage.createAt.isSameMin(rhs: newMessage.createAt) {
                mViewModel[s][r].isShowTime = false
            } else {
                result.append(
                    (IndexPath(row:  mViewModel[mViewModel.count - 1].count, section: mViewModel.count - 1), 0))
                mViewModel[mViewModel.count - 1].append(MessageViewItem(type: .BLANK))
            }
            
            result.append(
                (IndexPath(row:  mViewModel[mViewModel.count - 1].count, section: mViewModel.count - 1), result.count == 2 ? 1 : 0))
            mViewModel[mViewModel.count - 1].append(item)
            
            result.append(
                (IndexPath(row:  mViewModel[mViewModel.count - 1].count, section: mViewModel.count - 1), 1))
            mViewModel[mViewModel.count - 1].append(MessageViewItem(type: .BLANK))
            
            return result
        } else {
            return []
        }
    }
    
    public func getType(of indexPath: IndexPath) -> MessageViewType {
        return mViewModel[indexPath.section][indexPath.row].messageType
    }
    
    private func setViewModel() {
        mViewModel.removeAll()
        var tmp: [MessageViewItem] = [MessageViewItem.init(type: .STAMP)]
        
        for i in 0 ..< mItems.count {
            
            let current = mItems[i]
            var item = MessageViewItem(withMessage: current, type: current.isMine  ? .RCELL : .LCELL)
            
            if i == mItems.count - 1 {
                item.isShowTime = true
                tmp.append(item)
                continue
            }
            
            let next = mItems[i + 1]
            
            if !current.createAt.isSameDay(rhs: next.createAt) {
                item.isShowTime = true
                tmp.append(item)
                
                mViewModel.append(tmp)
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
        mViewModel.append(tmp)
        mViewModel = self.reverse(array: mViewModel)
    }
    
    
    func reverse(array: [[MessageViewItem]]) -> [[MessageViewItem]] {
        var result: [[MessageViewItem]] = []
        for item in array {
            result.insert(item.reversed(), at: 0)
        }
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
            cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi);

            return cell
            
        } else if item.messageType == .LCELL {
            let cell = tableView.dequeueReusableCell(withIdentifier: item.messageType.rawValue, for: indexPath) as! ChatRCell
            cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi);

            cell.configure(viewItem: item)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: item.messageType.rawValue, for: indexPath) as! StampCell
            cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi);
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
