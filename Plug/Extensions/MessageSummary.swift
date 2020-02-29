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
    var chatroom: ChatRoomApolloFragment
    var unreadCount: Int
    var sender: UserApolloFragment
    var receiver: UserApolloFragment
    var lastMessage: MessageItem
    var createAt: Date
    
    var displayName: String {
        guard let me = Session.me,
            let admin = chatroom.admin else { return ""}
        
        if sender.userStatus == UserStatus.deleted {
            return "탈퇴한 사용자"
        }
        
        if admin.userId == me.userId {
            if let kid = chatroom.getKid(parent: sender) {
                return "\(kid.name) 부모님"
            } else {
                return "\(sender.name) 부모님"
            }
            
        } else {
            return "\(sender.name) 선생님"
        }
    }
    
    public init(with classData: ChatRoomApolloFragment) {
        id = "id"
        chatroom = classData
        unreadCount = 0
        lastMessage = MessageItem()
        lastMessage.text = "\(classData.admin?.name ?? "") 선생님과 대화를 시작해보세요."
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        sender = classData.admin!
        receiver = classData.users!.filter({$0.fragments.userApolloFragment.userId == Session.me!.userId}).first!.fragments.userApolloFragment
        
        createAt = Date()
    }
    
    public init(with user: UserApolloFragment, classData: ChatRoomApolloFragment, myType: SessionRole) {
        id = "id"
        chatroom = classData
        //ChatRoomSummaryApolloFragment(id: classData.id, name: classData.name, chatRoomAt: classData.chatRoomAt, createdAt: classData.createdAt)
        unreadCount = 0
        lastMessage = MessageItem()
        
//        if myType == .TEACHER {
//            if let kidName = Session.me?.getKid(chatroomID: classData.id , parentID: user.userId)?.name {
//                lastMessage.text = "\(kidName) 부모님이 \(classData.name) 클래스에 가입했습니다."
//            }
//        } else {
//            lastMessage.text = "\(user.name) 선생님과 대화를 시작해보세요."
//        }
        
        
        sender = user
        receiver = classData.users!.filter({$0.fragments.userApolloFragment.userId == Session.me!.userId}).first!.fragments.userApolloFragment
        
        createAt = Date()
    }
    
    public init(with summary: MessageSummaryApolloFragment) {
        id = summary.id
        chatroom = summary.chatRoom.fragments.chatRoomApolloFragment
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
        return ((lhs.sender.userId == rhs.receiver.userId) && (lhs.receiver.userId == rhs.sender.userId) && (lhs.chatroom.id == rhs.chatroom.id))
            ||
            ((lhs.sender.userId == rhs.sender.userId) && (lhs.receiver.userId == rhs.receiver.userId) && (lhs.chatroom.id == rhs.chatroom.id))
    }
    
    static func sortSummary(arr: [MessageSummary]) -> [MessageSummary] {
        guard let userID = Session.me?.userId ,
        let me = Session.me else { return [] }
        
        var tmpsummary: [MessageSummary] = []
        for s in arr {
            if let a = arr.filter({$0 == s}).sorted(by: { (lhs, rhs) -> Bool in
                return lhs.lastMessage.createAt > rhs.lastMessage.createAt
            }).first {
                if !tmpsummary.contains(where: {$0 == a}) {
                    tmpsummary.append(a)
                }
            }
        }
        
        var summary: [MessageSummary] = []
        for s in tmpsummary {
            var ss = s
            if ss.sender.userId == userID {
                if let a = arr.filter({ $0 == ss && $0.receiver.userId == userID }).first {
                    ss.unreadCount = a.unreadCount
                    ss.receiver = a.receiver
                    ss.sender = a.sender
                } else {
                    let tmp = s.sender
                    ss.sender = s.receiver
                    ss.receiver = tmp
                    ss.unreadCount = 0;
                }
            }
            summary.append(ss)
        }
        
        summary.sort(by: { (lhs, rhs) -> Bool in
            lhs.lastMessage.createAt > rhs.lastMessage.createAt
            })
        
        summary.sort(by: { (lhs, rhs) -> Bool in
            return lhs.unreadCount != 0 && rhs.unreadCount == 0
        })
        
//        if Session.me?.role ?? .NONE == .TEACHER {//탈퇴한 부모의 서머리 삭제
//            summary = summary.filter { (summary) -> Bool in
//                return me.getKid(chatroomID: summary.chatroom.id, parentID: summary.sender.userId) != nil
//            }
//        } else {//탈퇴한 클래스 선생님 삭제
//            summary = summary.filter({ (summary) -> Bool in
//                me.classData.filter({ (chatroom) -> Bool in
//                    return chatroom.id == summary.chatroom.id
//                }).count > 0
//            })
//        }
        return summary
    }
}
