//
//  UserInfo.swift
//  Plug
//
//  Created by changmin lee on 04/12/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import Foundation
import Apollo

class UserInfo: NSObject {
    
    public static var myClasses: [ChatRoomApolloFragment]? = nil
    
    public var id: String?
    public var name: String?
    public var role: Role?
    public var userId: String?
    public var profileImageUrl: String?
    public var phoneNumber: String?
    
    public convenience override init() {
        self.init(withDic:  ["userType" : "EMAIL" as AnyObject,
                             "role" : "TEACHER" as AnyObject] )
    }
    
    public init (withDic dic: [String : Any]) {
    }
}
