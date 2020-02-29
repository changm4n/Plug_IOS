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
        return Network.shared.perform(query: CreateRoomMutation(roomName: name, userId: userId, year: year)).do(onNext: { (_) in
        Session.me?.reloadChatRoom() }).map({ data in
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
    
    static func joinChatroom(id: String, userId: String, name: String) -> Maybe<ApplyChatRoomMutation.Data> {
        return Network.shared.perform(query: ApplyChatRoomMutation(id: id, userId: userId, kidName: name)).do(onNext: { (_) in
        Session.me?.reloadChatRoom() })
    }
    
    static func updateChatroom(id: String, name: String, year: String) -> Maybe<String> {
        return Network.shared.perform(query: UpdateChatRoomMutation(id: id, newName: name, newYear: year)).do(onNext: { (_) in
        Session.me?.reloadChatRoom() }).map({ data in
            return data.updateChatRoom.id
        })
    }
    
    static func deleteChatroom(id: String) -> Maybe<String> {
        return Network.shared.perform(query: DeleteChatRoomMutation(id: id)).do(onNext: { (_) in
        Session.me?.reloadChatRoom() }).map({
            data in
            return data.deleteChatRoom.id
        })
    }
    
    static func withdrawKid(id: String, userId: String, kidName: String) -> Maybe<String> {
        return Network.shared.perform(query: WithdrawKidMutation(chatroomID: id, userID: userId, kidName: kidName)).do(onNext: { (_) in
            Session.me?.reloadChatRoom() }).map({
            data in
            return data.withdrawChatRoomUser.id
        })
    }
}


