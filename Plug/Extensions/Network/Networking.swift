//
//  Network.swift
//  Plug
//
//  Created by changmin lee on 2020/02/09.
//  Copyright © 2020 changmin. All rights reserved.
//

import Foundation
import Apollo
import UIKit
import RxSwift
import Alamofire
import RxCocoa

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
        Network.isNetworking(status: true)
        return self.apollo.rx
            .fetch(query: query, cachePolicy: cachePolicy, queue: queue)
            .do(onNext: { (_) in
                Network.isNetworking(status: false)
            }, onError: { _ in
                Network.isNetworking(status: false)
            })
    }
    
    func perform<Query: GraphQLMutation>(query: Query) -> Maybe<Query.Data> {
        Network.isNetworking(status: true)
        return self.apollo.rx.perform(mutation: query, context: nil, queue: .main)
            .do(onNext: { (_) in
                Network.isNetworking(status: false)
            }, onError: { _ in
                Network.isNetworking(status: false)
            })
    }
    
    func uploadImage(image: UIImage?, userId: String) -> Observable<String?> {
        let headers = ["accept" : "application/json",
                               "content-type": "multipart/form-data"]
        
        guard let data = image?.jpegData(compressionQuality: 1) else {
            return Observable.create { observable in
                observable.onNext(nil)
                return Disposables.create()
            }
        }
        return Observable.create { observable in
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                let q1 = stringToData(str: """
                       { "query":"mutation ($files: [Upload!]!) { multipleUpload(files: $files) }","variables": { "files": [null]}}
                       """)
                let q2 = stringToData(str: """
                       { "0": ["variables.files.0"] }
                       """)
                multipartFormData.append(q1, withName: "operations")
                multipartFormData.append(q2, withName: "map")
                multipartFormData.append(data, withName: "0", fileName: "\(userId).jpeg", mimeType: "image/jpeg")
                
            }, usingThreshold: UInt64.init(), to: kBaseURL, method: .post, headers: headers) { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseJSON(completionHandler: { (jsonData) in
                        switch jsonData.result {
                        case .success(let data):
                            if let json = data as? [String : AnyObject],
                                let urls = json["data"]?["multipleUpload"] as? [String],
                                let url = urls.first {
                                observable.onNext(url)
                            } else {
                                observable.onNext(nil)
                            }
                        case .failure:
                            observable.onNext(nil)
                        }
                    })
                case .failure(_):
                    observable.onNext(nil)
                }
            }
            return Disposables.create()
        }
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

extension Network {
    static func isNetworking(status: Bool) {
        if status {
            PlugIndicator.shared.play()
        } else {
            PlugIndicator.shared.stop()
        }
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
