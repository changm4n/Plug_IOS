//
//  MessageAPI.swift
//  Plug
//
//  Created by changmin lee on 2020/02/09.
//  Copyright © 2020 changmin. All rights reserved.
//

import Foundation
import RxSwift


class MessageAPI: NSObject {
    static func getSummary(userId: String) -> Maybe<MessageSummariesQuery.Data> {
        return Network.shared.fetch(query: MessageSummariesQuery(userId: userId))
    }
}
