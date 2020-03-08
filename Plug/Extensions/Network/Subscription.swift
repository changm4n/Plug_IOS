//
//  Subscription.swift
//  Plug
//
//  Created by changmin lee on 2020/03/05.
//  Copyright © 2020 changmin. All rights reserved.
//

import Foundation
import Apollo
import UIKit
import RxSwift
import Alamofire
import RxCocoa

class SubscriptionManager {
    
    static let shared = SubscriptionManager()
    let dispoeBag = DisposeBag()
    var token = "" {
        willSet {
            self.subscription2(token: newValue)
        }
    }
    
    func getSubscriptClient2(token: String) -> ApolloClient {
        print("[sub] start with \(token)")
        let map: GraphQLMap = ["Authorization" : token]
        let wsEndpointURL = URL(string: kPrismaURL)!
        let endpointURL = URL(string: kPrismaURL)!
        
        var request = URLRequest(url: wsEndpointURL)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        let websocket = WebSocketTransport(request: request, connectingPayload: map)
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Authorization" : token]
        
        let urlSession = URLSession(configuration: configuration)
        
        let a = HTTPNetworkTransport(url: endpointURL, session: urlSession)
        let split = SplitNetworkTransport(httpNetworkTransport: a,
                                          webSocketNetworkTransport: websocket)
        return ApolloClient(networkTransport: split)
    }

    
    func getSubscriptClient(token: String) -> ApolloClient {
        let map: GraphQLMap = ["Authorization" : token]
        let wsEndpointURL = URL(string: kPrismaURL)!
        let endpointURL = URL(string: kPrismaURL)!
        let websocket = WebSocketTransport(request: URLRequest(url: wsEndpointURL), connectingPayload: map)
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Authorization" : token]
        
        
        let a = HTTPNetworkTransport(url: endpointURL, session: URLSession(configuration: configuration),  delegate: self)
        let split = SplitNetworkTransport(httpNetworkTransport: a,
                                          webSocketNetworkTransport: websocket)
        
        return ApolloClient(networkTransport: split)
    }
    
    func subscription(token: String) -> Observable<MessageSubscriptionSubscription.Data> {
        self.token = token
        print("[sub] token : \(token)")
        return self.getSubscriptClient2(token: token)
            .rx.subscribe(subscription: MessageSubscriptionSubscription(), queue: .main)
    }
    
    func subscription2(token: String) {
        
        self.getSubscriptClient2(token: "Bearer \(token)").subscribe(subscription: MessageSubscriptionSubscription(), queue: .main) { (result) in
         print("[sub] received")
        }
    }
    
//    func start() {
//        print("[sub] start")
//        #if DEBUG
//        MessageAPI.getSubscriptToken().asObservable().flatMap { [unowned self] (token) in
//            self.subscription(token: "Bearer " + token)
//        }.subscribe(onNext: { (data) in
//            print("[sub] received")
//            if let newMessage = data.message?.fragments.messageSubscriptionPayloadApolloFragment
//                .node?.fragments.messageApolloFragment {
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kMessageReceived), object: nil, userInfo: ["message" : newMessage])
//            }
//        }, onError: { error in
//            print("[sub] onerror")
//        }, onDisposed: {
//            print("[sub] disposed")
//        }).disposed(by: dispoeBag)
//        #else
//        MessageAPI.getSubscriptToken().asObservable().flatMap { [unowned self] (token) in
//            self.subscription(token: "Bearer " + token)
//        }.subscribe(onNext: { (data) in
//            print("[sub] received")
//            if let newMessage = data.message?.fragments.messageSubscriptionPayloadApolloFragment
//                .node?.fragments.messageApolloFragment {
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kMessageReceived), object: nil, userInfo: ["message" : newMessage])
//            }
//        }, onError: { error in
//            print("[sub] onerror")
//        }, onDisposed: {
//            print("[sub] disposed")
//        }).disposed(by: dispoeBag)
//        #endif
//    }
    func start() {
        print("[sub] start")
        MessageAPI.getSubscriptToken().asObservable().subscribe(onNext: { (token) in
            print("[sub] \(token)")
            self.token = token
        }, onError: nil, onCompleted: {
            print("[sub] onComplete")
        }, onDisposed: {
                print("[sub] disposed")
        }).disposed(by: dispoeBag)
    }
}

// MARK: - Pre-flight delegate
extension SubscriptionManager: HTTPNetworkTransportPreflightDelegate {

    func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          shouldSend request: URLRequest) -> Bool {
        // If there's an authenticated user, send the request. If not, don't.
        return true
    }

    func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          willSend request: inout URLRequest) {
        print("[sub] through delegate")
        // Get the existing headers, or create new ones if they're nil
        var headers = request.allHTTPHeaderFields ?? [String: String]()
        headers["Authorization"] = self.token
        // Re-assign the updated headers to the request.
        request.allHTTPHeaderFields = headers
    }
}

