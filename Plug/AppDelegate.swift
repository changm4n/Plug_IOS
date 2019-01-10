//
//  AppDelegate.swift
//  Plug
//
//  Created by changmin lee on 2018. 10. 20..
//  Copyright © 2018년 changmin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let user = Session.fetchUserFromSavedData() {
            Session.me = user
        }
        return true
    }
}

