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
    var socket: WebSocketTransport? = nil
    private var subscriptionObject: Cancellable?
    
    private var magicToken = ""
    
    private lazy var webSocketTransport: WebSocketTransport = {
      let url = URL(string: kPrismaURL)!
      let request = URLRequest(url: url)
      let authPayload = ["Authorization": magicToken]
      return WebSocketTransport(request: request, connectingPayload: authPayload)
    }()
    
    private lazy var httpTransport: HTTPNetworkTransport = {
      let url = URL(string: kPrismaURL)!
      return HTTPNetworkTransport(url: url)
    }()

    private lazy var splitNetworkTransport = SplitNetworkTransport(
      httpNetworkTransport: self.httpTransport,
      webSocketNetworkTransport: self.webSocketTransport
    )

    private(set) lazy var client = ApolloClient(networkTransport: self.splitNetworkTransport)
    
    func subscription() {
        self.subscriptionObject = self.client.subscribe(subscription: MessageSubscription(), queue: .main) { (result) in
            print("[sub] received")
            switch result {
            case .success(let graphQLResult):
                if let message = graphQLResult.data?.message?.fragments.messageSubscriptionPayloadApolloFragment.node?.fragments.messageApolloFragment {
                
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: kMessageReceived), object: nil, userInfo: ["message" : message])
              } // else, something went wrong and you should check `graphQLResult.error` for problems
            case .failure(_): break
            }
        }
    }
    
    func start() {
        guard subscriptionObject == nil else {
            print("start sub but nil")
            return
        }
        print("start sub")
        MessageAPI.getSubscriptToken().subscribe(onSuccess:  { (token) in
            self.magicToken = "Bearer \(token)"
            self.subscription()
        }).disposed(by: dispoeBag)
    }
    
    func stop() {
        print("stop sub")
        self.subscriptionObject?.cancel()
        self.subscriptionObject = nil
    }
}

// MARK: - Pre-flight delegate
extension SubscriptionManager: HTTPNetworkTransportPreflightDelegate, HTTPNetworkTransportGraphQLErrorDelegate {
    func networkTransport(_ networkTransport: HTTPNetworkTransport, receivedGraphQLErrors errors: [GraphQLError], retryHandler: @escaping (Bool) -> Void) {
        print("[sub] \(errors.first?.message ?? "")")
    }

    func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          shouldSend request: URLRequest) -> Bool {
        print("[sub] should send")
        return true
    }

    func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          willSend request: inout URLRequest) {
        print("[sub] through delegate")
//        var headers = request.allHTTPHeaderFields ?? [String: String]()
//        request.allHTTPHeaderFields = headers
    }
}

extension SubscriptionManager: WebSocketTransportDelegate {
    
    func webSocketTransportDidConnect(_ webSocketTransport: WebSocketTransport) {
        print("[sub] socket connected \(webSocketTransport.self.isConnected())")
        
    }
    
    func webSocketTransportDidReconnect(_ webSocketTransport: WebSocketTransport) {
        print("[sub] socket disconnected")
    }
    
    func webSocketTransport(_ webSocketTransport: WebSocketTransport, didDisconnectWithError error:Error?) {
        print("[sub] socket error \(error?.localizedDescription)")
    }
}


//            if let newMessage = data.message?.fragments.messageSubscriptionPayloadApolloFragment
//                .node?.fragments.messageApolloFragment {
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kMessageReceived), object: nil, userInfo: ["message" : newMessage])
//            }

//subscription Message($userId: String!) {
//  message(where : {OR :
//    [{node :{receivers_some : {userId : $userId}}},
//  , {node : {sender : {userId : $userId} }}]}) {
//    ...MessageSubscriptionPayloadApolloFragment
//  }
//}
