//
//  ChatroomAPI.swift
//  Plug
//
//  Created by changmin lee on 2020/02/09.
//  Copyright © 2020 changmin. All rights reserved.
//

import Foundation
import RxSwift


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
}
