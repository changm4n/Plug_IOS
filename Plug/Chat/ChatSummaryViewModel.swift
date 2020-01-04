//
//  ChatSummaryViewModel.swift
//  Plug
//
//  Created by changmin lee on 2020/01/04.
//  Copyright © 2020 changmin. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct ChatSummaryViewModel {
    
//    var summaryObservable: Observable<MessageSummary> = Observable.of(MessageSummary())
    var summaryObservable: Observable<[Int]> = Observable.of([1,2,3])
}
