//
//  ChatroomData.swift
//  Plug
//
//  Created by changmin lee on 2020/01/25.
//  Copyright © 2020 changmin. All rights reserved.
//

import Foundation

struct Identity {
    var id: String
    var name: String
}

struct ChatroomIdentity {
    var sender: Identity
    var receiver: Identity
    var chatroom: Identity
    
    var hashKey: Int
    
    init(sender: Identity, receiver: Identity, chatroom: Identity) {
        self.sender = sender
        self.receiver = receiver
        self.chatroom = chatroom
        
        self.hashKey = ChatroomIdentity.getHash(arr: [sender.id, receiver.id, chatroom.id])
    }
    
    static func getHash(arr: [String]) -> Int {
        let values = arr.map({$0.prefix(6)}).sorted()
        return values.joined().hashValue
    }
}


