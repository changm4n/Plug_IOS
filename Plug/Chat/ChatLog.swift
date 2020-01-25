//
//  ChatLog+CoreDataClass.swift
//  Plug
//
//  Created by changmin lee on 2020/01/24.
//  Copyright © 2020 changmin. All rights reserved.
//
//

import Foundation
import RxDataSources
import RealmSwift

//class ChatRepository {
//    dynamic var id = ""
//    dynamic var chatroom = ""
//    dynamic var sender = ""
//
//    let logs = List<ChatLog>()
//}

class ChatLog: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var chatroom: String = ""
    
    @objc dynamic var createAt: Date = Date()
    @objc dynamic var readedAt: Date? = nil
    
    @objc dynamic var rID: String = ""
    @objc dynamic var rName: String = ""
    
    @objc dynamic var sID: String = ""
    @objc dynamic var sName: String = ""
    
    @objc dynamic var text: String = ""
    
    @objc dynamic var hashKey: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    required init() {
        
    }
    
    init(_ message: MessageApolloFragment) {
        id = message.id
        chatroom = message.chatRoom.id
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        createAt = formatter.date(from: message.createdAt)!
        readedAt = formatter.date(from: message.readedAt ?? "")
        
        rID = message.receivers?.first?.userId ?? ""
        rName = message.receivers?.first?.name ?? ""
        
        sID = message.sender.userId
        sName = message.sender.name
        
        text = message.text ?? ""
        
        hashKey = ChatroomIdentity.getHash(arr: [chatroom, sID, rID])
    }
    
    init(_ messageItem: MessageItem) {
        id = messageItem.id
        chatroom = messageItem.chatroomId
        createAt = messageItem.createAt
        readedAt = messageItem.readedAt
        
        rID = messageItem.receiverId
        rName = messageItem.receiverName
        
        sID = messageItem.senderId
        sName = messageItem.senderName
        
        text = messageItem.text
        
        hashKey = ChatroomIdentity.getHash(arr: [chatroom, sID, rID])
    }
}
