//
//  FBLogger.swift
//  Plug
//
//  Created by changmin lee on 14/03/2019.
//  Copyright © 2019 changmin. All rights reserved.
//

import Foundation
import Firebase

class FBLogger {
    static func log(id: String) {
        Analytics.logEvent(id, parameters: nil)
    }
    
    static func log(id: String, param:[String : String]) {
        Analytics.logEvent(id, parameters: param)
    }
}
