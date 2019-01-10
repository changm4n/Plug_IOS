//
//  Network.swift
//  Plug
//
//  Created by changmin lee on 02/12/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import Foundation
import Apollo

class Networking: NSObject {
    
    static func getClient() -> ApolloClient {
        let configuration = URLSessionConfiguration.default
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
    
    static func getUserInfo(completion:@escaping (_ classes: [ChatRoomApolloFragment], _ crontab:String?) -> Void) {
        let apollo = getClient()
        if let id = Session.me?.id,
            let userID = Session.me?.userId {
            apollo.fetch(query: GetUserInfoQuery(id: id, userId: userID), cachePolicy: CachePolicy.fetchIgnoringCacheData, queue: DispatchQueue.main) { (result, error) in
                if let crontab = result?.data?.officePeriods.first?.crontab ,
                    let rooms = result?.data?.chatRooms {
                    completion(rooms.compactMap({$0.fragments.chatRoomApolloFragment}), crontab)
                } else {
                    completion([], nil)
                }
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
    
    static func getMessageSummary(userID: String, start: Int, end: String?, completion:@escaping (_ lastMessages: [MessageSummaryApolloFragment]) -> Void) {
        let apollo = getClient()
        apollo.fetch(query: MessageSummariesQuery(myId: userID, pageCount: start, startCursor: end), cachePolicy: CachePolicy.fetchIgnoringCacheData, queue: .main) { (result, error) in
            if let summaries = result?.data?.messageSummaries {
                completion(summaries.compactMap({ $0?.fragments.messageSummaryApolloFragment }))
            } else {
                completion([])
            }
        }
    }
    
    static func getMeassages(chatroomId: String, userId: String, receiverId: String, start: Int, end: String?, completion:@escaping (_ lastMessages: [MessageApolloFragment]) -> Void) {
        getClient().fetch(query: MessagesQuery(chatRoomId: chatroomId, myId: userId, userId: receiverId, pageCount: start, startCursor: end), cachePolicy: CachePolicy.fetchIgnoringCacheData, queue: .main) { (result, error) in
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
}
