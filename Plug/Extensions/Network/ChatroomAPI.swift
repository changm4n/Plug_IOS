//
//  ChatroomAPI.swift
//  Plug
//
//  Created by changmin lee on 2020/02/09.
//  Copyright © 2020 changmin. All rights reserved.
//

import Foundation
import RxSwift
import Apollo

class ChatroomAPI: NSObject {
    static func getAdminChatroom(userId: String) -> Maybe<AdminRoomQuery.Data> {
        return Network.shared.fetch(query: AdminRoomQuery(userId: userId))
//            .do(onNext: { (data) in
//            let classData = data.chatRooms.compactMap { $0.fragments.chatRoomApolloFragment }
//            Session.me?.adminClass.accept(classData)
//        })
    }
    
    static func getMemberChatroom(userId: String) -> Maybe<MemberRoomQuery.Data> {
        return Network.shared.fetch(query: MemberRoomQuery(userId: userId))
//            .do(onNext: { (data) in
//            let classData = data.chatRooms.compactMap { $0.fragments.chatRoomApolloFragment }
//            Session.me?.memberClass.accept(classData)s
//        })
    }
    
    static func createChatroom(userId: String, name: String, year: String) -> Maybe<String> {
        return Network.shared.perform(query: CreateRoomMutation(roomName: name, userId: userId, year: year)).map({ data in
            return data.createChatRoom.inviteCode
        })
    }
    
    static func getChatroom(byCode code: String) -> Maybe<ChatRoomApolloFragment> {
        return Network.shared.fetch(query: GetChatroomQuery(code: code)).map({ data in
            guard let chatroom = data.chatRooms.first?.fragments.chatRoomApolloFragment else {
                throw GraphQLError(JSONObject())
            }
            return chatroom
        })
    }
}


