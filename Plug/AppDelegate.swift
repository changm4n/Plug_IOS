//
//  AppDelegate.swift
//  Plug
//
//  Created by changmin lee on 2018. 10. 20..
//  Copyright © 2018년 changmin. All rights reserved.
//

import UIKit
import KakaoOpenSDK
import Firebase
import UserNotifications
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var state:[AnyHashable: Any] = [:]
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        print("log didfinish")
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        if let noti = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] {
            self.application(application, didReceiveRemoteNotification: noti as! [AnyHashable : Any])
        }
        
        if let user = Session.fetchUserFromSavedData() {
            Session.me = user
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if KOSession.isKakaoAccountLoginCallback(url) {
            return KOSession.handleOpen(url)
        }
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if KOSession.isKakaoAccountLoginCallback(url) {
            return KOSession.handleOpen(url)
        }
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        KOSession.handleDidBecomeActive()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(#function)
        state = userInfo
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newMessage"), object: nil)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let me = Session.me else { return }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newMessage"), object: nil)
        
//        application.applicationIconBadgeNumber += 1
//        var text = ""
//        var sender = ""
//        if me.role == .TEACHER {
//            print(userInfo)
//            let data = userInfo["data"] as! String
//
//            let d = data.data(using: String.Encoding.utf8)!
//            let json = try! JSON(data: d)
//            let senderName = json["sender"]["name"].stringValue
//            let kids = json["lastMessage"]["chatRoom"]["kids"].arrayValue
//            for kid in kids {
//                for parent in kid["parents"].arrayValue {
//                    if parent["name"].stringValue == senderName {
//                        sender = "\(kid["name"].stringValue) 부모님"
//                    }
//                }
//            }
//            text = json["lastMessage"]["text"].stringValue
//        } else {
//            let data = userInfo["data"] as! String
//
//            let d = data.data(using: String.Encoding.utf8)!
//            let json = try! JSON(data: d)
//            let senderName = json["sender"]["name"].stringValue
//            text = json["lastMessage"]["text"].stringValue
//            sender = "\(senderName) 선생님"
//        }
//
//        let noti = UNMutableNotificationContent()
////        noti.title = sender
//        noti.body = "\(sender) : \(text)"
//        let request = UNNotificationRequest(identifier: "noti", content: noti, trigger: nil)
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        let dataDict:[String: String] = ["token": fcmToken]
        PlugLog(string: "push token [\(dataDict["token"])")
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        Session.saveDeviceKey(fcmToken)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("message")
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
    }
}
