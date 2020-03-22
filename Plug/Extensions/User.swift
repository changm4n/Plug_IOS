//
//  Sessionswift
//  Plug
//
//  Created by changmin lee on 04/11/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import RxSwift
import RxCocoa

let kYears = ["2020","2019","2018"]
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

public class Session {
    
    let disposeBag = DisposeBag()
    
    public static var me: Session? = nil
    
    public var id: String?
    public var name: BehaviorRelay<String> = BehaviorRelay(value: "")
    public var role: SessionRole = .NONE
    public var userType: SessionType?
    public var userId: String?
    public var profileImageUrl: String? {
        didSet {
            if let urlStr = profileImageUrl,
                let url = URL(string: urlStr) {
                do {
                    let ImageData = try Data(contentsOf: url)
                    profileImage.onNext(UIImage(data: ImageData))
                } catch {
                    profileImage.onNext(UIImage.getDefaultProfile())
                }
            } else {
                profileImage.onNext(UIImage.getDefaultProfile())
            }
        }
    }
    
    public var phoneNumber: String?
    public var token: String?
    public var password: String?
    var schedule: BehaviorRelay<Schedule> = BehaviorRelay(value: Schedule())
    
    var subscriptionToken: String?
    var profileImage: BehaviorSubject<UIImage?> = BehaviorSubject(value: UIImage.getDefaultProfile())
    
    var adminClass: BehaviorRelay<[ChatRoomApolloFragment]> = BehaviorRelay(value: [])
    var memberClass: BehaviorRelay<[ChatRoomApolloFragment]> = BehaviorRelay(value: [])
    var allClass: BehaviorRelay<[ChatRoomApolloFragment]> = BehaviorRelay(value: [])
    
    var summaryData: BehaviorRelay<[MessageSummary]> = BehaviorRelay(value: [])
    
    var kids: BehaviorRelay<[KidItem]> = BehaviorRelay(value: [])
    var users: BehaviorRelay<[UserItem]> = BehaviorRelay(value: [])
    
    
    public convenience init() {
        self.init(withDic:  ["userType" : "EMAIL" as AnyObject,
                             "role" : "TEACHER" as AnyObject] )
    }
    
    public init (withUser data: UserApolloFragment) {
        id = data.id
        name.accept(data.name)
        role = SessionRole(rawValue: data.role.rawValue) ?? .NONE
        userType = SessionType(rawValue: data.type.rawValue)
        userId = data.userId
        profileImageUrl = data.profileImageUrl
        phoneNumber = data.phoneNumber
        password = nil
        
        if let urlStr = profileImageUrl,
            let url = URL(string: urlStr) {
            do {
                let ImageData = try Data(contentsOf: url)
                profileImage.onNext(UIImage(data: ImageData))
            } catch {
                profileImage.onNext(nil)
            }
        }
        setBinding()
    }
    
    public init (withDic dic: [String : Any]) {
        id = dic["id"] as? String
        name.accept((dic["name"] as? String) ?? "")
        role = SessionRole(rawValue: dic["role"] as! String) ?? .NONE
        userType = SessionType(rawValue: dic["userType"] as! String)
        userId = dic["userId"] as? String
        profileImageUrl = dic["profileImageUrl"] as? String
        phoneNumber = dic["phoneNumber"] as? String
        token = dic["token"] as? String
        
        subscriptionToken = dic["subscriptionToken"] as? String
        
        setBinding()
    }
    
    func setBinding() {
//        self.adminClass.map({
//            $0.compactMap({$0}).compactMap({$0.kids}).flatMap({$0}).map({$0.fragments.kidApolloFragment})
//        }).bind(to: kids).disposed(by: disposeBag)
//
        //kids = (kid, classname)
        self.adminClass.asDriver().drive(onNext: { (rooms) in
            var kidList: [KidItem] = []
            rooms.forEach({
                let chatroom = $0
                $0.kids?.forEach({
                    kidList.append(KidItem(kid: $0.fragments.kidApolloFragment, chatroom: chatroom))
                })
            })
            self.kids.accept(kidList)
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(adminClass, memberClass).map({
            var arr: [UserItem] = []
            $0.0.forEach({ room in
                room.kids?.forEach({ kid in
                    let k = kid.fragments.kidApolloFragment
                    if let parent = k.parent {
                        arr.append(UserItem(displayname: "\(k.name) 부모님", user: parent, chatroom: room, role: .PARENT))
                    }
                })
            })
            
            $0.1.forEach({ room in
                if let admin = room.admin {
                    arr.append(UserItem(displayname: "\(admin.name) 선생님", user: admin, chatroom: room, role: .TEACHER))
                }
            })
            return arr
        }).bind(to: users).disposed(by: disposeBag)
        
        Observable.combineLatest(adminClass, memberClass).map({
            $0.0 + $0.1
        }).bind(to: allClass).disposed(by: disposeBag)
    }
    
    func save() {
        Session.me = self
        self.saveToken()
        self.saveMyProfile()
    }
    
    static func saveWithToken(token: String) {
        let sess = Session()
        Session.me = sess
        sess.token = token
        sess.save()
    }
    
    func refreshSummary() {
        guard let userId = userId else {
            return
        }
        MessageAPI.getSummary(userId: userId).subscribe(onSuccess: { [unowned self] (data) in
           let list = MessageSummary.sortSummary(arr: data).filter({ summary in
                if let index = self.allClass.value.firstIndex(of: summary.chatroom) {
                    let users = self.allClass.value[index].users ?? []
                    return users.map({$0.fragments.userApolloFragment}).contains(summary.sender)
                } else {
                    return false
                }
            })
            self.summaryData.accept(list)
        }).disposed(by: disposeBag)
    }
    
    func reloadChatRoom() {
        guard let userId = self.userId else { return }
        let member = ChatroomAPI.getMemberChatroom(userId: userId).asObservable()
        let admin = ChatroomAPI.getAdminChatroom(userId: userId).asObservable()
        Observable.zip(member, admin) { return ($0, $1) }.subscribe(onNext: { [weak self] (member, admin) in
            let memberData = member.chatRooms.compactMap { $0.fragments.chatRoomApolloFragment }
            self?.memberClass.accept(memberData)
            
            let adminData = admin.chatRooms.compactMap { $0.fragments.chatRoomApolloFragment }
            self?.adminClass.accept(adminData)
        }).disposed(by: disposeBag)
    }
    
    func reload() -> Maybe<Void> {
        guard let userId = self.userId else { return Maybe.error(NSError()) }
        let member = ChatroomAPI.getMemberChatroom(userId: userId).asObservable()
        let admin = ChatroomAPI.getAdminChatroom(userId: userId).asObservable()
        
        return Observable.zip(member, admin) { return ($0, $1) }
        .do(onNext: { [weak self] (member, admin) in
            let memberData = member.chatRooms.compactMap { $0.fragments.chatRoomApolloFragment }
            self?.memberClass.accept(memberData)
            
            let adminData = admin.chatRooms.compactMap { $0.fragments.chatRoomApolloFragment }
            self?.adminClass.accept(adminData)
        }).flatMap({ (_,_) in
            MessageAPI.registerPushKey()
        })
        .flatMap ({ (_) in
            MessageAPI.getSummary(userId: userId).asObservable()
        }).retry(2).do(onNext: { (data) in
            let list = MessageSummary.sortSummary(arr: data).filter({ summary in
                if let index = self.allClass.value.firstIndex(of: summary.chatroom) {
                    let users = self.allClass.value[index].users ?? []
                    return users.map({$0.fragments.userApolloFragment}).contains(summary.sender)
                } else {
                    return false
                }
            })
            self.summaryData.accept(list)
        }).map({ _ in Void() }).asMaybe()
    }
    
    func refreshMe(completion:@escaping (_ m: Session?) -> Void) {
//        Networking.getMe(completion: { (me) in
//            if let me = me {
//                let user = Session(withUser: me)
//                user.token = self.token
//                Session.me = user
//                user.save()
//                Networking.registerPushKey()
//
//                completion(user)
//            } else {
//                completion(nil)
//            }
//        })
    }
    
    func readChat(chatRoomId: String, senderId: String) {
        var summary = summaryData.value
        for index in 0..<summary.count {
            if summary[index].chatroom.id == chatRoomId &&
                summary[index].sender.userId == senderId {
                summary[index].unreadCount = 0
                self.summaryData.accept(summary)
                return
            }
        }
    }
    
    func getKid(chatroom: ChatRoomApolloFragment) -> KidApolloFragment? {
        let kids = chatroom.kids?.compactMap({ $0.fragments.kidApolloFragment }) ?? []
        let kid = kids.filter({ ($0.parents?.filter({$0.fragments.userApolloFragment.id == id}) ?? []).count > 0}).first
        return kid
    }
    
    fileprivate func saveToken() {
        UserDefaults.standard.set(self.token, forKey: "UserToken")
        UserDefaults.standard.synchronize()
    }
    
    public static func fetchUserFromSavedData() -> Session? {
        guard let savedDic = UserDefaults.standard.object(forKey: kSavedUserData) as? [String:AnyObject] else {
            return nil
        }
        
        return Session(withDic: savedDic)
    }
    
    public static func removeSavedUser() {
        Session.me = nil
        UserDefaults.standard.removeObject(forKey: "UserToken")
        UserDefaults.standard.removeObject(forKey: kSavedUserData)
        UserDefaults.standard.synchronize()
    }
    
    public static func fetchToken() -> String? {
        if let token = UserDefaults.standard.object(forKey: "UserToken") as? String {
            return token
        } else {
            return nil
        }
    }
    
    public static func fetchDeviceKey() -> String {
        if let deviceKey = UserDefaults.standard.object(forKey: "DeviceKey") as? String {
            return deviceKey
        } else {
            return "InvalidDeviceKey"
        }
    }
    
    public static func saveDeviceKey(_ key:String) {
        UserDefaults.standard.set(key, forKey: "DeviceKey")
        UserDefaults.standard.synchronize()
    }
    
    fileprivate func saveMyProfile() {
        UserDefaults.standard.removeObject(forKey: kSavedUserData)
        var data = [String:AnyObject]()
        
        if let id = self.id { data["id"] = id as AnyObject }
        data["name"] = self.name.value as AnyObject 
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
    public func httpHeaders() -> [String:String] {
        var defaultHeaders = [String:String]()
        
        if let token = Session.fetchToken() {
            defaultHeaders["Authorization"] = token
        }
        defaultHeaders["pushtoken"] = Session.fetchDeviceKey()
        
        return defaultHeaders
    }
}

extension Session {
    func updateProfile(name: String, image: UIImage?) {
        guard let userId = userId else { return }
        UserAPI.uploadIamge(image: image, userId: userId)
            .flatMap { (url) in
                return UserAPI.updateUser(me: Session.me, name: name, url: url)
        }.subscribe(onNext: { (result) in
            Session.me?.profileImageUrl = result.updateUser?.profileImageUrl
            Session.me?.name.accept(result.updateUser?.name ?? "")
        }).disposed(by: disposeBag)
    }
    
    func updateOffice(newOffice: Schedule) {
        if self.schedule.value != newOffice {
            print("update office")
            ChatroomAPI.updateOffice(crontab:newOffice.toString()).subscribe(onSuccess: { [weak self] (data) in
                print("update success")
                self?.schedule.accept(Schedule(schedule: data.upsertOfficePeriod.crontab ?? ""))
            }).disposed(by: disposeBag)
        }
    }
}
