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
        if let token = User.fetchToken() {
            configuration.httpAdditionalHeaders = ["Authorization" : token]
        }
        let url = URL(string: kBaseURL)!
        return ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
    }

    static func login(_ id:String, password:String, completion:@escaping (_ token:String?) -> Void) {
        let apollo = getClient()
        apollo.perform(mutation: SignInMutation(userId: id, password: password), queue: DispatchQueue.main) { (result, error) in
            completion(result?.data?.signin.token)
        }
    }
    
    static func getMessageSummary(completion:@escaping (_ lastMessages: [String]) -> Void) {
        let apollo = getClient()
//        apollo.fetch(query: MessageSummariesQuery(), cachePolicy: CachePolicy.returnCacheDataAndFetch, queue: DispatchQueue.main) { (result, error) in
//            print(result?.data?.messageSummaries.flatMap({$0.m}))
//        }
    }
}
