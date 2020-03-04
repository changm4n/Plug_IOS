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
    // Configure the network transport to use the singleton as the delegate.
    private lazy var networkTransport = HTTPNetworkTransport(
        url: URL(string: kPrismaURL)!,
        delegate: self
    )
    
    // Use the configured network transport in your Apollo client.
    private(set) lazy var apollo = ApolloClient(networkTransport: self.networkTransport)

    
    func subscription() -> Observable<MessageSubscriptionSubscription.Data> {
        return self.apollo.rx.subscribe(subscription: MessageSubscriptionSubscription(), queue: .global())
    }
    
    func start() {
        MessageAPI.getSubscriptToken().asObservable().do(onNext: { [weak self] (token) in
            self?.token = token
        }).flatMap { [unowned self] (token) in
            self.subscription()
        }.subscribe(onNext: { (data) in
            if let newMessage = data.message?.fragments.messageSubscriptionPayloadApolloFragment
                .node?.fragments.messageApolloFragment {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kMessageReceived), object: nil, userInfo: ["message" : newMessage])
            }
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
        
        // Get the existing headers, or create new ones if they're nil
        var headers = request.allHTTPHeaderFields ?? [String: String]()
        headers["Authorization"] = self.token
        // Re-assign the updated headers to the request.
        request.allHTTPHeaderFields = headers
    }
}
