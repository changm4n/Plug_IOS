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
    
    open static var myClasses: [ChatRoomApolloFragment]? = nil
    
    open var id: String?
    open var name: String?
    open var role: Role?
    open var userId: String?
    open var profileImageUrl: String?
    open var phoneNumber: String?
    
    public convenience override init() {
        self.init(withDic:  ["userType" : "EMAIL" as AnyObject,
                             "role" : "TEACHER" as AnyObject] )
    }
    
    public init (withDic dic: [String : Any]) {
    }
}
