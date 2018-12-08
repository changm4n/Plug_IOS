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
        print("reloaded")
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
