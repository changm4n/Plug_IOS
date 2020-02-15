//
//  UserAPI.swift
//  Plug
//
//  Created by changmin lee on 2020/02/09.
//  Copyright © 2020 changmin. All rights reserved.
//

import Foundation
import RxSwift
import Firebase

class UserAPI: NSObject {
    
    static func kakaoLogin(id: String) -> Maybe<KakaoSignInMutation.Data> {
        return Network.shared.perform(query: KakaoSignInMutation(userId: id)).do(onNext: { (data) in
            Session.saveWithToken(token: data.kakaoSignin.token)
        })
    }
    
    static func login(form: (String, String)) -> Maybe<SignInMutation.Data> {
        return Network.shared.perform(query: SignInMutation(userId: form.0, password: form.1)).do(onNext: { (data) in
            Session.saveWithToken(token: data.signin.token)
        })
    }
    
    static func getMe() -> Maybe<MeQuery.Data> {
        return Network.shared.fetch(query: MeQuery()).do(onNext: { (data) in
            let user = Session(withUser: data.me.fragments.userApolloFragment)
            user.token = Session.me?.token
            Session.me = user
            Session.me?.save()
        })
    }
    
    static func registerPushKey() -> Maybe<RegisterPushKeyMutation.Data> {
        let key = Messaging.messaging().fcmToken ?? ""
        return Network.shared.perform(query: RegisterPushKeyMutation(pushKey: key))
    }
    
    static func getUserInfo() -> Maybe<GetUserInfoInStartQuery.Data> {
        guard let id = Session.me?.id, let userId = Session.me?.userId else {
            return Maybe.error(ApolloError.gqlErrors([]))
        }
        return Network.shared.fetch(query: GetUserInfoInStartQuery(id: id, userId: userId))
            .do(onNext: { (data) in
                let crontab = data.officePeriods.first?.crontab
                //            Session.me?.classData = classData
                if let crontab = crontab {
                    Session.me?.schedule = Schedule(schedule: crontab)
                }
                
                let tmp: [MessageSummary] = data.messageSummaries.compactMap{ $0 }.map({
                    MessageSummary(with: $0.fragments.messageSummaryApolloFragment)
                })
                let summary = MessageSummary.sortSummary(arr: tmp)
                Session.me?.summaryData.accept(summary)
            })
    }
}
