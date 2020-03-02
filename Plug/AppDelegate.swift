//
//  AppDelegate.swift
//  Plug
//
//  Created by changmin lee on 2018. 10. 20..
//  Copyright © 2018년 changmin. All rights reserved.
//
import Siren
import UIKit
import KakaoOpenSDK
import Firebase
import UserNotifications
import SwiftyJSON
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var state:[AnyHashable: Any] = [:]
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        Siren.shared.presentationManager = PresentationManager(forceLanguageLocalization: .korean)
        Siren.shared.rulesManager = RulesManager(globalRules: Rules(promptFrequency: .daily, forAlertType: .none))
        Siren.shared.wail()
        
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (garanted, error) in
            }
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        if let noti = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] {
            self.application(application, didReceiveRemoteNotification: noti as! [AnyHashable : Any])
        }
        
        if let user = Session.fetchUserFromSavedData() {
            Session.me = user
        }
        
//        if let token = UserDefaults.standard.object(forKey: kSubscriptToken) {
//
//        }
//
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
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
       
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    }
    
   
    func applicationWillEnterForeground(_ application: UIApplication) {
        if let me = Session.me {
            me.reload().subscribe().disposed(by: me.disposeBag)
        }
    }
   
    func applicationDidEnterBackground(_ application: UIApplication) {
        guard let me = Session.me else {
            application.applicationIconBadgeNumber = 0
            return
        }
        let badgeCount = me.summaryData.value.reduce(0) { (result, summary) -> Int in
            return result + summary.unreadCount
        }
        
        application.applicationIconBadgeNumber = badgeCount
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
//        let userInfo = notification.request.content.userInfo
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print(#function)
    }
}
