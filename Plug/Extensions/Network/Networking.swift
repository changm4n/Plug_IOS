//
//  Network.swift
//  Plug
//
//  Created by changmin lee on 2020/02/09.
//  Copyright © 2020 changmin. All rights reserved.
//

import Foundation
import Apollo
import RxSwift

// MARK: - Singleton Wrapper

class Network {
    static let shared = Network()
    
    // Configure the network transport to use the singleton as the delegate.
    private lazy var networkTransport = HTTPNetworkTransport(
        url: URL(string: kBaseURL)!,
        delegate: self
    )
    
    // Use the configured network transport in your Apollo client.
    private(set) lazy var apollo = ApolloClient(networkTransport: self.networkTransport)
    
    func fetch<Query: GraphQLQuery>(
      query: Query,
      cachePolicy: CachePolicy = .fetchIgnoringCacheData,
      queue: DispatchQueue = DispatchQueue.main
    ) -> Maybe<Query.Data> {
      return self.apollo.rx
        .fetch(query: query, cachePolicy: cachePolicy, queue: queue)
    }
    
    func perform<Query: GraphQLMutation>(query: Query) -> Maybe<Query.Data> {
        return self.apollo.rx.perform(mutation: query, context: nil, queue: .main)
    }
}

// MARK: - Pre-flight delegate

extension Network: HTTPNetworkTransportPreflightDelegate {
    
    func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          shouldSend request: URLRequest) -> Bool {
        // If there's an authenticated user, send the request. If not, don't.
        return true
    }
    
    func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          willSend request: inout URLRequest) {
        
        // Get the existing headers, or create new ones if they're nil
        var headers = request.allHTTPHeaderFields ?? [String: String]()
        if let token = Session.fetchToken() {
            headers["Authorization"] = token
            headers["Platform"] = "IOS"
        }
               
        // Re-assign the updated headers to the request.
        request.allHTTPHeaderFields = headers
    }
}

//// MARK: - Task Completed Delegate
//
//extension Network: HTTPNetworkTransportTaskCompletedDelegate {
//    func networkTransport(_ networkTransport: HTTPNetworkTransport,
//                          didCompleteRawTaskForRequest request: URLRequest,
//                          withData data: Data?,
//                          response: URLResponse?,
//                          error: Error?) {
//        Logger.log(.debug, "Raw task completed for request: \(request)")
//
//        if let error = error {
//            Logger.log(.error, "Error: \(error)")
//        }
//
//        if let response = response {
//            Logger.log(.debug, "Response: \(response)")
//        } else {
//            Logger.log(.error, "No URL Response received!")
//        }
//
//        if let data = data {
//            Logger.log(.debug, "Data: \(String(describing: String(bytes: data, encoding: .utf8)))")
//        } else {
//            Logger.log(.error, "No data received!")
//        }
//    }
//}
////
//// MARK: - Retry Delegate
//
//extension Network: HTTPNetworkTransportRetryDelegate {
//
//    func networkTransport(_ networkTransport: HTTPNetworkTransport,
//                          receivedError error: Error,
//                          for request: URLRequest,
//                          response: URLResponse?,
//                          retryHandler: @escaping (_ shouldRetry: Bool) -> Void) {
//        // Check if the error and/or response you've received are something that requires authentication
//        guard UserManager.shared.requiresReAuthentication(basedOn: error, response: response) else {
//            // This is not something this application can handle, do not retry.
//
//            return
//        }
//
//        // Attempt to re-authenticate asynchronously
//        UserManager.shared.reAuthenticate { success in
//            // If re-authentication succeeded, try again. If it didn't, don't.
//            retryHandler(success)
//        }
//    }
//}
