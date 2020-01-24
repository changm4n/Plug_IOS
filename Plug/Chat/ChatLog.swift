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
    
    @objc dynamic var hashKey: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    required init() {
        
    }
    
    init(message: MessageApolloFragment) {
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
        
        hashKey = getHash([chatroom, sID, rID])
    }
}
