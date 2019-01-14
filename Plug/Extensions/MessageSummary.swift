//
//  MessageSummary.swift
//  Plug
//
//  Created by changmin lee on 14/01/2019.
//  Copyright © 2019 changmin. All rights reserved.
//
/*
 id
 chatRoom { ...ChatRoomSummaryApolloFragment }
 sender { ...UserApolloFragment },
 receiver { ...UserApolloFragment },
 unReadMessageCount,
 lastMessage { ...MessageApolloFragment }
 createdAt
 */
import Foundation

struct MessageSummary {
    var id: String
    var chatroom: ChatRoomSummaryApolloFragment
    var unreadCount: Int
    var sender: UserApolloFragment
    var receiver: UserApolloFragment
    var lastMessage: MessageItem
    var createAt: Date
    
    var kidName: String {
        if let me = Session.me,
            me.role == .TEACHER,
            let kid = me.getKid(chatroomID: chatroom.id, parentID: sender.userId) {
            return "\(kid.name) 부모님"
        } else {
            return sender.name
        }
    }
    
    public init(with summary: MessageSummaryApolloFragment) {
        id = summary.id
        chatroom = summary.chatRoom.fragments.chatRoomSummaryApolloFragment
        unreadCount = summary.unReadMessageCount
        if let last = summary.lastMessage?.fragments.messageApolloFragment {
            lastMessage = MessageItem(with: last, isMine: true)
        } else {
            lastMessage = MessageItem()
        }
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        sender = summary.sender.fragments.userApolloFragment
        receiver = summary.receiver.fragments.userApolloFragment
        
        createAt = formatter.date(from: summary.createdAt)!
    }
    
    static func ==(lhs: MessageSummary, rhs: MessageSummary) -> Bool {
        return ((lhs.sender.userId == rhs.receiver.userId) && (lhs.receiver.userId == rhs.sender.userId)) || ((lhs.sender.userId == rhs.sender.userId) && (lhs.receiver.userId == rhs.receiver.userId))
    }
}
