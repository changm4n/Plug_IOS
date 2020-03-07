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
    var token = ""
    
    // Use the configured network transport in your Apollo client.
    func getSubscriptClient(token: String) -> ApolloClient {
        let map: GraphQLMap = ["Authorization" : token]
        let wsEndpointURL = URL(string: kPrismaURL)!
        let endpointURL = URL(string: kBaseURL)!
        let websocket = WebSocketTransport(request: URLRequest(url: wsEndpointURL), connectingPayload: map)
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        configuration.timeoutIntervalForResource = 5
        configuration.httpAdditionalHeaders = ["Authorization" : token]
        
        
        let a = HTTPNetworkTransport(url: endpointURL, session: URLSession(configuration: configuration),  delegate: self)
        let split = SplitNetworkTransport(httpNetworkTransport: a,
                                          webSocketNetworkTransport: websocket)
        
        return ApolloClient(networkTransport: split)
    }
    
    func subscription(token: String) -> Observable<MessageSubscriptionSubscription.Data> {
        self.token = token
        print(token)
        return self.getSubscriptClient(token: token).rx.subscribe(subscription: MessageSubscriptionSubscription(), queue: .main)
    }
    
    func start() {
        
        #if DEBUG
        if let token = Session.fetchToken() {
            self.subscription(token: token).subscribe(onNext: { (data) in
               print("message received")
                    if let newMessage = data.message?.fragments.messageSubscriptionPayloadApolloFragment
                        .node?.fragments.messageApolloFragment {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kMessageReceived), object: nil, userInfo: ["message" : newMessage])
                    }
                }, onError: { error in
                    print("subscript error")
                }, onDisposed: {
                    print("subscript disposed")
                }).disposed(by: dispoeBag)
        }
        #else
        MessageAPI.getSubscriptToken().asObservable().flatMap { [unowned self] (token) in
            self.subscription(token: "Bearer " + token)
        }.subscribe(onNext: { (data) in
            print("message received")
            if let newMessage = data.message?.fragments.messageSubscriptionPayloadApolloFragment
                .node?.fragments.messageApolloFragment {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kMessageReceived), object: nil, userInfo: ["message" : newMessage])
            }
        }, onError: { error in
            print("subscript error")
        }, onDisposed: {
            print("subscript disposed")
        }).disposed(by: dispoeBag)
        #endif
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

        // Get the existing headers, or create new ones if they're nil
        var headers = request.allHTTPHeaderFields ?? [String: String]()
        headers["Authorization"] = self.token
        // Re-assign the updated headers to the request.
        request.allHTTPHeaderFields = headers
    }
}

