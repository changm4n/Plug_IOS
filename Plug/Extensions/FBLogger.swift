//
//  FBLogger.swift
//  Plug
//
//  Created by changmin lee on 14/03/2019.
//  Copyright © 2019 changmin. All rights reserved.
//

import Foundation
import Firebase

class FBLogger: NSObject {
    
    static let shared = FBLogger()
    
    func log(id: String) {
        Analytics.logEvent(id, parameters: nil)
    }
    
    func log(id: String, param:[String : String]) {
        Analytics.logEvent(id, parameters: param)
    }
    
    private override init() {
        super.init()
        
        let key = Session.me?.role == .TEACHER ? kTeacherKey : kParentKey
        Analytics.setUserProperty(key, forName: "userType")
    }
}
