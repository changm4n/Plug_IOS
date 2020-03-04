//
//  Message.swift
//  Plug
//
//  Created by changmin lee on 08/12/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import RxRealm
import RealmSwift
import RxDataSources

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
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a hh:mm"
        return formatter.string(from: createAt)
    }
    
    var timeStampLong: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yy.MM.dd. (E)"
        return formatter.string(from: createAt)
    }
    let kDefault = "default"
    
    init() {
        self.id = kDefault
        self.chatroomId = kDefault
        self.text = "text"
        self.receiverId = Session.me!.userId!
        self.receiverName = kDefault
        self.senderId = kDefault
        self.senderName = kDefault
        self.isMine = true
        self.createAt = Date()
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
    
    public init(with chatlog: ChatLog, isMine: Bool) {
        id = chatlog.id
        chatroomId = chatlog.id
        text = chatlog.text
        receiverId = chatlog.rID
        receiverName = chatlog.rName
        senderId = chatlog.sID
        senderName = chatlog.sName
        createAt = chatlog.createAt
        readedAt = chatlog.readedAt
        
        self.isMine = isMine
    }
    
    public init(text: String, chatroom: String, receiver: String) {
        self.id = kDefault
        self.chatroomId = chatroom
        self.text = text
        self.receiverId = receiver
        self.receiverName = kDefault
        self.senderId = kDefault
        self.senderName = kDefault
        self.isMine = true
        self.createAt = Date()
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

struct ChatroomViewModel {
    var identity: ChatroomIdentity
    var disposeBag = DisposeBag()
    
    var output: PublishSubject<[SectionModel<String, MessageViewItem>]> = PublishSubject()
    
    var model: ChatroomModel
    
    init(identity: ChatroomIdentity) {
        self.identity = identity
        self.model = ChatroomModel(identity: identity)
    }
    
    func load() {
        self.model.output.distinctUntilChanged({ (lhs, rhs) -> Bool in
            lhs.count == rhs.count
        })
            .filter({!$0.isEmpty})
            .map({
            self.setViewModel(items: $0)
        })
            .bind(to: output).disposed(by: disposeBag)
        model.load()
    }
    
    private func setViewModel(items: [MessageItem]) -> [SectionModel<String, MessageViewItem>] {
        var result: [[MessageViewItem]] = []
        if items.count == 0 {
            return []
        }
        
        var tmp: [MessageViewItem] = [MessageViewItem.init(withMessage: items.first, type: .STAMP)]
        
        for i in 0 ..< items.count {
            
            let current = items[i]
            var item = MessageViewItem(withMessage: current, type: current.isMine ? .RCELL : .LCELL)
            
            if i == items.count - 1 {
                item.isShowTime = true
                tmp.append(item)
                continue
            }
            
            let next = items[i + 1]
            
            if !current.createAt.isSameDay(rhs: next.createAt) {
                item.isShowTime = true
                tmp.append(item)
                
                result.append(tmp)
                tmp = [MessageViewItem.init(withMessage: next, type: .STAMP)]
                
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
        result.append(tmp)
        
        let sections = result.map({
            SectionModel<String, MessageViewItem>(model: $0.first?.message?.timeStampLong ?? "", items: $0)
        })
        return sections
    }
    
    public func addMessage(message: MessageItem) {
        model.addMessage(newMessage: message)
    }
    
    public func sendMessage(message: MessageItem) {
        model.sendMessage(message: message)
    }
}

class ChatroomModel {
    var identity: ChatroomIdentity
    private var items: [MessageItem] = [] {
        didSet {
            output.onNext(self.items)
        }
    }
    var output: BehaviorSubject<[MessageItem]> = BehaviorSubject(value: [])
    var disposeBag = DisposeBag()
    
    init(identity: ChatroomIdentity) {
        self.identity = identity
    }
    
    func saveMessage(messages: [ChatLog]) {
        Observable.from(messages).bind(to: Realm.rx.add(update: .modified, onError: { elements, error in
            if let elements = elements {
                print("Error \(error.localizedDescription) while saving objects \(String(describing: elements))")
            } else {
                print("Error \(error.localizedDescription) while opening realm.")
            }
        })).disposed(by: disposeBag)
    }
    
//    func load() {
//        let realm = try! Realm()
//        let logs = realm.objects(ChatLog.self).filter("hashKey == %@", identity.hashKey)
//        if logs.count >= kMessageWindowSize {
//            self.items = logs.map({ MessageItem(with: $0, isMine: identity.receiver.id == $0.sID)})
//        } else {
//
//            let lastMessage = items.first?.id
//            MessageAPI.getMessage(chatroomId: identity.chatroom.id, userId: identity.sender.id, receiverId: identity.receiver.id, before: lastMessage).subscribe(onSuccess: { (messages) in
//                self.saveMessage(messages: messages.map({ ChatLog($0) }))
//                let logs = realm.objects(ChatLog.self).filter("hashKey == %@", self.identity.hashKey)
//                self.items = logs.map({ MessageItem(with: $0, isMine: self.identity.receiver.id == $0.sID)})
//            }, onError: { (error) in
//
//            }).disposed(by: disposeBag)
//        }
//    }
    func load() {
       MessageAPI.getMessage(chatroomId: identity.chatroom.id, userId: identity.sender.id, receiverId: identity.receiver.id, before: nil).subscribe(onSuccess: { (messages) in
            self.items = messages.map({ ChatLog($0) }).map({ MessageItem(with: $0, isMine: self.identity.receiver.id == $0.sID)})
        }, onError: { (error) in
            
        }).disposed(by: disposeBag)
    }
    
    public func setItems(messages: [MessageItem]) {
        self.items = messages
    }
    
    public func addItemsFront(messages: [MessageItem]) {
        self.items.insert(contentsOf: messages, at: 0)
    }
    
    public func addMessage(newMessage: MessageItem) {
        self.items.append(newMessage)
    }
    
    public func sendMessage(message: MessageItem) {
        MessageAPI.sendMessage(message: message).subscribe(onSuccess: { [weak self] (message) in
//            self?.saveMessage(messages: [ChatLog(message)])
            self?.addMessage(newMessage: MessageItem(with: message, isMine: true))
            }, onError: { (error) in
                switch error {
                case let ApolloError.gqlErrors(errors):
                    print(errors.first?.message)
                default:
                    print(error.localizedDescription)
                }
        }).disposed(by: disposeBag)
    }
}

final class RxTableViewSectionedReloadDataSourceWithReloadSignal<S: SectionModelType>: RxTableViewSectionedReloadDataSource<S> {
    private let relay = PublishRelay<Void>()
    var dataReloaded : Signal<Void> {
        return relay.asSignal()
    }
    
    override func tableView(_ tableView: UITableView, observedEvent: Event<[S]>) {
        super.tableView(tableView, observedEvent: observedEvent)
        relay.accept(())
    }
}
