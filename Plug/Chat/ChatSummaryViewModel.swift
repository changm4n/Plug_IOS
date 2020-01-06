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
    
    var me: Session
    //output
    var summaryObservable: Observable<[MessageSummary]>
    
    init(me: Session) {
        self.me = me
        summaryObservable  = Observable.of(me.summaryData)
    }
}
