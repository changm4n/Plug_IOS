//
//  ChatLog+CoreDataClass.swift
//  Plug
//
//  Created by changmin lee on 2020/01/24.
//  Copyright © 2020 changmin. All rights reserved.
//
//

import Foundation
import CoreData
import RxCoreData


struct ChatLog {
    public var id: String
    public var chatroom: String
    
    public var createAt: Date
    public var readedAt: Date
    
    public var rID: String
    public var rName: String
    
    public var sID: String
    public var sName: String
    
    public var text: String
}

extension ChatLog : Persistable {
    typealias Identity = String
    
    var identity: Identity { return id }
    
   typealias T = NSManagedObject
    
    static var entityName: String {
        return "ChatLog"
    }
    
    static var primaryAttributeName: String {
        return "id"
    }
    
    init(entity: T) {
        id = entity.value(forKey: "id") as! String
        chatroom = entity.value(forKey: "chatroom") as! String
        createAt = entity.value(forKey: "createAt") as! Date
        readedAt = entity.value(forKey: "readedAt") as! Date
        rID = entity.value(forKey: "rID") as! String
        rName = entity.value(forKey: "rName") as! String
        sID = entity.value(forKey: "sID") as! String
        sName = entity.value(forKey: "sName") as! String
        text = entity.value(forKey: "text") as! String
    }
    
    func update(_ entity: T) {
        entity.setValue(id, forKey: "id")
        
        do {
            try entity.managedObjectContext?.save()
        } catch let e {
            print(e)
        }
    }
}
