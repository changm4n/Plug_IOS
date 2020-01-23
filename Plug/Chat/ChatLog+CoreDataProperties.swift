//
//  ChatLog+CoreDataProperties.swift
//  
//
//  Created by changmin lee on 2020/01/23.
//
//

import Foundation
import CoreData


extension ChatLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatLog> {
        return NSFetchRequest<ChatLog>(entityName: "ChatLog")
    }

    @NSManaged public var id: String?
    @NSManaged public var chatroom: String?
    @NSManaged public var text: String?
    @NSManaged public var rID: String?
    @NSManaged public var rName: String?
    @NSManaged public var sID: String?
    @NSManaged public var sName: String?
    @NSManaged public var createAt: Date?
    @NSManaged public var readedAt: Date?

}
