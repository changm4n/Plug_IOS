//
//  Network.swift
//  Plug
//
//  Created by changmin lee on 02/12/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import Foundation
import Apollo
import Alamofire

class Networking: NSObject {
    
    static func getClient() -> ApolloClient {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        configuration.timeoutIntervalForResource = 5
        if let token = Session.fetchToken() {
            configuration.httpAdditionalHeaders = ["Authorization" : token]
        }
        let url = URL(string: kBaseURL)!
        return ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
    }
    
    static func getSubscriptClient() -> ApolloClient {
        let token = Session.fetchToken() ?? ""
        let configuration = URLSessionConfiguration.default
        let map: GraphQLMap = ["Authorization" : token]
        configuration.httpAdditionalHeaders = ["Authorization" : token]
        
        let wsEndpointURL = URL(string: kBaseURL)!
        let endpointURL = URL(string: kBaseURL)!
        let websocket = WebSocketTransport(request: URLRequest(url: wsEndpointURL), connectingPayload: map)
        let splitNetworkTransport = SplitNetworkTransport(
            httpNetworkTransport: HTTPNetworkTransport(
                url: endpointURL,
                configuration: configuration
            ),
            webSocketNetworkTransport: websocket
        )
        return ApolloClient(networkTransport: splitNetworkTransport)
    }
    
    static func getMe(completion:@escaping (_ me: UserApolloFragment?) -> Void) {
        let apollo = getClient()
        apollo.fetch(query: MeQuery(), cachePolicy: CachePolicy.fetchIgnoringCacheData, queue: DispatchQueue.main) { (result, error) in
            if let me = result?.data?.me.fragments.userApolloFragment {
                completion(me)
            } else {
                completion(nil)
            }
        }
    }
    
    static func getUserInfoinStart(completion:@escaping (_ classes: [ChatRoomApolloFragment], _ crontab: String?, _ summary: [MessageSummary]) -> Void) {
        let apollo = getClient()
        if let id = Session.me?.id,
            let userID = Session.me?.userId {
            apollo.fetch(query: GetUserInfoInStartQuery(id: id, userId: userID), cachePolicy: CachePolicy.fetchIgnoringCacheData, queue: DispatchQueue.main) { (result, error) in
                let crontab = result?.data?.officePeriods.first?.crontab
                let rooms = result?.data?.chatRooms ?? []
                let tmp: [MessageSummary] = result?.data?.messageSummaries.compactMap({
                    return MessageSummary(with: $0!.fragments.messageSummaryApolloFragment)
                }) ?? []
                let summary = MessageSummary.sortSummary(arr: tmp)
                completion(rooms.compactMap({$0.fragments.chatRoomApolloFragment}), crontab, summary)
            }
        } else {
            completion([], nil, [])
        }
    }
    
    static func getUserInfo(completion:@escaping (_ classes: [ChatRoomApolloFragment], _ crontab:String?) -> Void) {
        let apollo = getClient()
        if let id = Session.me?.id,
            let userID = Session.me?.userId {
            apollo.fetch(query: GetUserInfoQuery(id: id, userId: userID), cachePolicy: CachePolicy.fetchIgnoringCacheData, queue: DispatchQueue.main) { (result, error) in
                let crontab = result?.data?.officePeriods.first?.crontab
                let rooms = result?.data?.chatRooms ?? []
                completion(rooms.compactMap({$0.fragments.chatRoomApolloFragment}), crontab)
            }
        } else {
            completion([], nil)
        }
    }
    
    static func login(_ id:String, password:String, completion:@escaping (_ token:String?) -> Void) {
        let apollo = getClient()
        apollo.perform(mutation: SignInMutation(userId: id, password: password), queue: DispatchQueue.main) { (result, error) in
            completion(result?.data?.signin.token)
        }
    }
    
    static func signUp(user: Session, completion:@escaping (_ name: String?, _ error: Error?) -> Void) {
        let apollo = getClient()
        if let role = Role.init(rawValue: user.role.rawValue),
            let userId = user.userId, let name = user.name, let pw = user.password {
            
            let data = UserInput(role: role, userId: userId, name: name, password: pw, profileImageUrl: user.profileImageUrl, phoneNumber: user.phoneNumber)
            apollo.perform(mutation: SignUpMutation(data: data), queue: DispatchQueue.main) { (result, error) in
                completion(result?.data?.signup.name, error)
            }
        } else {
            completion(nil, nil)
        }
    }
    
    static func changePW(_ id:String, old:String, new:String, completion:@escaping (_ name:String?, _ error: GraphQLError?) -> Void) {
        let apollo = getClient()
        apollo.perform(mutation: ChangePwMutation(userId: id, old: old, new: new), queue: DispatchQueue.main) { (result, error) in
            if result?.errors?.first != nil {
                completion(nil, result?.errors?.first)
            } else {
                completion(result?.data?.updateNewPassword?.name, nil)
            }
        }
    }
    
    static func updateUser(user: Session, name: String, url: String, completion:@escaping (_ name:String?, _ error: GraphQLError?) -> Void) {
        let apollo = getClient()
        let data = UserUpdateInput(role: user.role == .PARENT ? .parent : .teacher, name: name, profileImageUrl: url, phoneNumber: user.phoneNumber)
        let input = UserWhereUniqueInput(id: user.id, userId: user.userId)
        apollo.perform(mutation: UpdateUserMutation(data: data, where: input), queue: DispatchQueue.main) { (result, error) in
            if result?.errors?.first != nil {
                completion(nil, result?.errors?.first)
            } else {
                completion(result?.data?.updateUser?.name, nil)
            }
        }
    }
    
    static func verifyEmail(_ email:String, completion:@escaping (_ code:String?) -> Void) {
        let apollo = getClient()
        apollo.perform(mutation: VerifyEmailResponseMutation(email: email), queue: DispatchQueue.main) { (result, error) in
            completion(result?.data?.verifyEmail.verifyCode)
        }
    }
    
    static func createChatRoom(_ name:String, userID: String, year: String, completion:@escaping (_ code:String?) -> Void) {
        let apollo = getClient()
        apollo.perform(mutation: CreateRoomMutation(roomName: name, userId: userID, year: "\(year)-12-02T14:07:13.995Z"), queue: DispatchQueue.main) { (result, error) in
            completion(result?.data?.createChatRoom.inviteCode)
        }
    }
    
    static func getChatroom(byCode code:String, completion:@escaping (_ room: ChatRoomApolloFragment?) -> Void) {
        let apollo = getClient()
        apollo.fetch(query: GetChatroomQuery(code: code), cachePolicy: CachePolicy.fetchIgnoringCacheData, queue: DispatchQueue.main) { (result, error) in
            if let room = result?.data?.chatRooms.first?.fragments.chatRoomApolloFragment {
                completion(room)
            } else {
                completion(nil)
            }
        }
    }
    
    static func applyChatroom(_ id: String, userId: String, kidName: String, completion:@escaping (_ id:String?) -> Void) {
        let apollo = getClient()
        apollo.perform(mutation: ApplyChatRoomMutation(id: id, userId: userId, kidName: kidName), queue: DispatchQueue.main) { (result, error) in
            completion(result?.data?.applyChatRoom.id)
        }
    }
    
    static func updateChatRoom(_ roomID:String, newName: String, newYear: String, completion:@escaping (_ id:String?) -> Void) {
        let apollo = getClient()
        apollo.perform(mutation: UpdateChatRoomMutation(id: roomID, newName: newName, newYear: "\(newYear)-12-02T14:07:13.995Z"), queue: DispatchQueue.main) { (result, error) in
            completion(result?.data?.updateChatRoom.id)
        }
    }
    
    static func getOffice(completion:@escaping (_ crontab:String?) -> Void) {
        let apollo = getClient()
        if let id = Session.me?.id {
            apollo.fetch(query: GetCronTabQuery(id: id), cachePolicy: CachePolicy.fetchIgnoringCacheData, queue: DispatchQueue.main) { (result, error) in
                if let crontab = result?.data?.officePeriods.first?.crontab{
                    completion(crontab)
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
    
    static func updateOffice(_ crontab:String, completion:@escaping (_ crontab:String?) -> Void) {
        let apollo = getClient()
        apollo.perform(mutation: SetOfficeMutation(crontab: crontab), queue: DispatchQueue.main) { (result, error) in
            completion(result?.data?.upsertOfficePeriod.crontab)
        }
    }
    
    static func withdrawKid(_ roomID:String, userID: String, kidName: String, completion:@escaping (_ id:String?) -> Void) {
        let apollo = getClient()
        apollo.perform(mutation: WithdrawKidMutation(chatroomID: roomID, userID: userID, kidName: kidName), queue: DispatchQueue.main) { (result, error) in
            completion(result?.data?.withdrawChatRoomUser.id)
        }
    }
    
    static func getMessageSummary(userID: String, completion:@escaping (_ lastMessages: [MessageSummary]) -> Void) {
        let apollo = getClient()
        apollo.fetch(query: MessageSummariesQuery(userId: userID), cachePolicy: CachePolicy.fetchIgnoringCacheData, queue: .main) { (result, error) in
            let tmp: [MessageSummary] = result?.data?.messageSummaries.compactMap({
                return MessageSummary(with: $0!.fragments.messageSummaryApolloFragment)
            }) ?? []
            let summary = MessageSummary.sortSummary(arr: tmp)
            completion(summary)
        }
    }
    
    static func getMeassages(chatroomId: String, userId: String, receiverId: String, last: Int = 50, before: String?, completion:@escaping (_ lastMessages: [MessageApolloFragment]) -> Void) {
        getClient().fetch(query: MessagesQuery(chatRoomId: chatroomId, myId: userId, userId: receiverId, pageCount: last, startCursor: before), cachePolicy: CachePolicy.fetchIgnoringCacheData, queue: .main) { (result, error) in
            if let messages = result?.data?.messages { completion(messages.compactMap({$0.fragments.messageApolloFragment}))
            } else {
                completion([])
            }
        }
    }
    
    static func sendMessage(text: String, chatRoomId: String, receiverId: String, completion:@escaping (_ message: MessageApolloFragment?) -> Void) {
        
        getClient().perform(mutation: SendMessageMutation(text: text, chatRoomId: chatRoomId, receiverId: receiverId, fileIds: []), queue: .main)
        { (result, error) in
            if let message = result?.data?.sendMessage.fragments.messageApolloFragment {
                completion(message)
            } else {
                completion(nil)
            }
        }
    }
    
    static func readMessage(chatRoomId: String, receiverId: String, senderId: String) {
        getClient().perform(mutation: ReadMessageMutation(chatroom: chatRoomId, sender: senderId, receiver: receiverId), queue: .main, resultHandler: nil)
    }
    
    static func registerPushKey(pushKey: String) {
        getClient().perform(mutation: RegisterPushKeyMutation(pushKey: pushKey), queue: .main, resultHandler: nil)
    }
    
    static func subscribeMessage(completion:@escaping (_ message: MessageSubscriptionPayloadApolloFragment) -> Void) {
        getSubscriptClient().subscribe(subscription: MessageSubscriptionSubscription(), queue: DispatchQueue.main) { (result, error) in
            if let message = result?.data?.message?.fragments.messageSubscriptionPayloadApolloFragment {
                completion(message)
            }
        }
    }
    
    static func getMyClasses(completion:@escaping (_ classes: [ChatRoomApolloFragment]) -> Void) {
        let apollo = getClient()
        apollo.fetch(query: MyChatroomsQuery(userId: Session.me?.userId), cachePolicy: CachePolicy.fetchIgnoringCacheData  , queue: .main) { (result, error) in
            if let rooms = result?.data?.chatRooms {
                completion(rooms.compactMap({$0.fragments.chatRoomApolloFragment}))
            }  else {
                completion([])
            }
        }
    }
    
    static func uploadImage(image: UIImage, completion:@escaping (_ error: String?) -> Void) {
        
        if let data = UIImageJPEGRepresentation(image, 1),
            let token = Session.fetchToken(),
        let userId = Session.me?.userId{
            
            let headers = ["Authorization" : token,
                           "accept" : "application/json",
                           "content-type": "application/json"]
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append("""
            { "query": "mutation(${"$"}files: [Upload!]!) { multipleUpload(files: ${"$"}files) }", "variables": { "files": [null] } }
            """.data(using: .utf8)!, withName: "operations")
                
                multipartFormData.append("""
            { "0": ["variables.files.0"] }
            """.data(using: .utf8)!, withName: "map")
                
                multipartFormData.append(data, withName: "0", fileName: "\(userId).jpg", mimeType: "image/jpg")
                
                
            }, usingThreshold: UInt64.init(), to: kBaseURL, method: .post, headers: headers) { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (progress) in
                        PlugLog(string: "Upload Progress: \(progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON(completionHandler: { (json) in
                        PlugLog(string: String(data: json.data!, encoding: .utf8)!)
                    })
                case .failure(let error):
                    print(error)
                }
            }
        }
            
    }
}
