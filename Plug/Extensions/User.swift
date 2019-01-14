//
//  Sessionswift
//  Plug
//
//  Created by changmin lee on 04/11/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import Foundation
import UIKit

let kYears = ["2016","2017","2018","2019","2020"]
let kDidLogoutNotification = "kDidLogoutNotification"
let kSavedUserData = "kSavedUserData"

public enum SessionType: String {
    case KAKAO = "KAKAO"
    , EMAIL = "EMAIL"
}


public enum SessionRole: String {
    case PARENT = "PARENT"
    , TEACHER = "TEACHER"
    , NONE = "NONE"
}

open class Session : NSObject {
    
    open static var me: Session? = nil
    
    open var id: String?
    open var name: String?
    open var role: SessionRole = .NONE
    open var userType: SessionType?
    open var userId: String?
    open var profileImageUrl: String?
    open var phoneNumber: String?
    open var token: String?
    open var password: String?
    var schedule: Schedule
    
    var appPushID: String?
    var profileImage: UIImage?
    
    var classData: [ChatRoomApolloFragment] = []
    
    public convenience override init() {
        self.init(withDic:  ["userType" : "EMAIL" as AnyObject,
                             "role" : "TEACHER" as AnyObject] )
         schedule = Schedule(schedule: "0-30 9-18 1,2,3")
    }
    
    public init (withUser data: UserApolloFragment) {
        id = data.id
        name = data.name
        role = SessionRole(rawValue: data.role.rawValue) ?? .NONE
        userType = SessionType(rawValue: data.type.rawValue)
        userId = data.userId
        profileImageUrl = data.profileImageUrl
        phoneNumber = data.phoneNumber
        schedule = Schedule(schedule: "0-30 9-18 1,2,3")
        password = nil
        
        if let urlStr = profileImageUrl,
            let url = URL(string: urlStr) {
            do {
                let ImageData = try Data(contentsOf: url)
                profileImage = UIImage(data: ImageData)
            } catch {
                profileImage = nil
            }
        }
    }
    
    public init (withDic dic: [String : Any]) {
        id = dic["id"] as? String
        name = dic["name"] as? String
        role = SessionRole(rawValue: dic["role"] as! String) ?? .NONE
        userType = SessionType(rawValue: dic["userType"] as! String)
        userId = dic["userId"] as? String
        profileImageUrl = dic["profileImageUrl"] as? String
        phoneNumber = dic["phoneNumber"] as? String
        token = dic["token"] as? String
        
        appPushID = dic["appPushId"] as? String
        
        schedule = Schedule(schedule: "0-30 9-18 1,2,3")
    }
    
    func save() {
        Session.me = self
        self.saveToken()
        self.saveMyProfile()
    }
    
    func refreshRoom(completion:@escaping (_ chatrooms:[ChatRoomApolloFragment]) -> Void) {
        Networking.getMyClasses { (classData) in
            Session.me?.classData = classData
            completion(classData)
        }
    }
    
    func refreshMe(completion:@escaping (_ m: Session) -> Void) {
        Networking.getMe(completion: { (me) in
            if let me = me {
                let user = Session(withUser: me)
                user.token = self.token
                Session.me = user
                user.save()
                completion(user)
            }
        })
    }
    
    func getChatroomBy(id: String?) -> ChatRoomApolloFragment? {
        if let id = id {
            return Session.me?.classData.filter({$0.id == id}).first ?? nil
        } else {
            return nil
        }
    }
    
    func getKid(chatroom: ChatRoomApolloFragment) -> KidApolloFragment? {
        let kids = chatroom.kids?.compactMap({ $0.fragments.kidApolloFragment }) ?? []
        let kid = kids.filter({ ($0.parents?.filter({$0.fragments.userApolloFragment.id == id}) ?? []).count > 0}).first
        return kid
    }
    
    func getKid(chatroomID: String,parentID: String) -> KidApolloFragment? {
        if let room = classData.filter({ $0.id == chatroomID }).first,
            let kids = room.kids?.compactMap({ $0.fragments.kidApolloFragment }),
        let kid = kids.filter({ ($0.parents?.filter({$0.fragments.userApolloFragment.userId == parentID }) ?? []).count > 0}).first {
            return kid
        } else {
            return nil
        }
    }
    
    fileprivate func saveToken() {
        UserDefaults.standard.set(self.token, forKey: "UserToken")
        UserDefaults.standard.synchronize()
    }
    
    open static func fetchUserFromSavedData() -> Session? {
        guard let savedDic = UserDefaults.standard.object(forKey: kSavedUserData) as? [String:AnyObject] else {
            return nil
        }
        
        return Session(withDic: savedDic)
    }
    
    open static func removeSavedUser() {
        Session.me = nil
        UserDefaults.standard.removeObject(forKey: "UserToken")
        UserDefaults.standard.removeObject(forKey: "DeviceKey")
        UserDefaults.standard.removeObject(forKey: kSavedUserData)
        UserDefaults.standard.synchronize()
    }
    
    open static func fetchToken() -> String? {
        if let token = UserDefaults.standard.object(forKey: "UserToken") as? String {
            return token
        } else {
            return nil
        }
    }
    
    open static func fetchDeviceKey() -> String {
        if let deviceKey = UserDefaults.standard.object(forKey: "DeviceKey") as? String {
            return deviceKey
        } else {
            return "InvalidDeviceKey"
        }
    }
    
    open static func saveDeviceKey(_ key:String) {
        UserDefaults.standard.set(key, forKey: "DeviceKey")
        UserDefaults.standard.synchronize()
    }
    
    fileprivate func saveMyProfile() {
        UserDefaults.standard.removeObject(forKey: kSavedUserData)
        var data = [String:AnyObject]()
        
        if let id = self.id { data["id"] = id as AnyObject }
        if let name = self.name { data["name"] = name as AnyObject }
        if let userType = self.userType?.rawValue { data["userType"] = userType as AnyObject }
        if let userId = self.userId { data["userId"] = userId as AnyObject }
        if let profileImageUrl = self.profileImageUrl { data["profileImageUrl"] = profileImageUrl as AnyObject }
        if let phoneNumber = self.phoneNumber { data["phoneNumber"] = phoneNumber as AnyObject }
        if let token = self.token { data["token"] = token as AnyObject }
        data["push_id"] = Session.fetchDeviceKey() as AnyObject
        data["role"] = role.rawValue as AnyObject
        UserDefaults.standard.set(data, forKey: kSavedUserData)
        UserDefaults.standard.synchronize()
        
        Session.me = self
    }
    
    //MARK: UserProtocol
    open func httpHeaders() -> [String:String] {
        var defaultHeaders = [String:String]()
        
        if let token = Session.fetchToken() {
            defaultHeaders["Authorization"] = token
        }
        defaultHeaders["pushtoken"] = Session.fetchDeviceKey()
        
        return defaultHeaders
    }
    
    func toJSON() -> [String : Any] {
        var data = [String : Any]()
        
        if let id = self.id { data["id"] = id as String }
        if let name = self.name { data["name"] = name as String }
        
        if let userType = self.userType?.rawValue { data["userType"] = userType as String }
        if let userId = self.userId { data["userId"] = userId as String }
        if let profileImageUrl = self.profileImageUrl { data["profileImageUrl"] = profileImageUrl as String }
        if let phoneNumber = self.phoneNumber { data["phoneNumber"] = phoneNumber as String }
        
        data["role"] = role.rawValue
        data["push_id"] = Session.fetchDeviceKey()
     
        return data
    }
}



