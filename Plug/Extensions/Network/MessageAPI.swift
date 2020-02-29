//
//  MessageAPI.swift
//  Plug
//
//  Created by changmin lee on 2020/02/09.
//  Copyright © 2020 changmin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MessageAPI: NSObject {
    static func getSummary(userId: String) -> Maybe<[MessageSummary]> {
        return Network.shared.fetch(query: MessageSummariesQuery(userId: userId)).map({
            return $0.messageSummaries.compactMap{$0}.map({
                return MessageSummary(with: $0.fragments.messageSummaryApolloFragment)
            })
        })
    }
    
    static func getMessage(chatroomId: String, userId: String, receiverId: String, last: Int = kMessageWindowSize, before: String?) -> Maybe<[MessageApolloFragment]> {
        return Network.shared.fetch(query: MessagesQuery(chatRoomId: chatroomId, myId: userId, userId: receiverId, pageCount: last, startCursor: before)).map({ $0.messages.compactMap({ $0.fragments.messageApolloFragment })})
    }
    
    static func sendMessage(message: MessageItem) -> Maybe<MessageApolloFragment> {
        return Network.shared.perform(query: SendMessageMutation(text: message.text, chatRoomId: message.chatroomId, receiverId: message.receiverId, fileIds: [])).map({ $0.sendMessage.fragments.messageApolloFragment }).subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    static func sendMultiMessage(text: String, kids: [KidItem]) -> Observable<[SendMultiMessageMutation.Data]>
    {
        var item: [String : [KidItem]] = [:]
        for kid in kids {
            let id = kid.chatroom.id
            if item[id] == nil { item[id] = []}
            item[id]?.append(kid)
        }
        
        var observables: [Observable<SendMultiMessageMutation.Data>] = []
        for serial in item {
            let parents = serial.value.compactMap({ $0.kid.parentUserID })
            observables.append(Network.shared.perform(query: SendMultiMessageMutation(text: text, chatRoomId: serial.key, receiverId: parents, fileIds: [])).asObservable())
        }
        
        return Observable.zip(observables)
    }
}
