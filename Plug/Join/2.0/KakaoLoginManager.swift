//
//  KakaoLoginManager.swift
//  Plug
//
//  Created by changmin lee on 2020/02/16.
//  Copyright © 2020 changmin. All rights reserved.
//

import Foundation
import KakaoOpenSDK
import RxSwift
import RxCocoa

class KakaoLoginManager {
    
    let disposeBag = DisposeBag()
    
    //input
    
    let input = PublishSubject<Void>()
    
    //output
    
    let output = PublishSubject<Bool>()
    let error = PublishSubject<String>()
    
    init() {
        bind()
    }
    
    func bind() {
        input.bind { [weak self] in
            self?.check()
        }.disposed(by: disposeBag)
    }
    
    func check() {
        getKakaoId().flatMap({ id in
            return UserAPI.isMemeber(id: id).map({ ($0, id) })
        }).subscribe(onNext: { [weak self] (isSignup, id) in
            if isSignup {
                self?.login(id: id)
            } else {
             
            }
        }, onError: { [weak self] (error) in
            self?.error.onNext("카카오 로그인 중 오류가 발생하였습니다.")
        }).disposed(by: disposeBag)
    }
    
    func getKakaoId() -> Observable<String> {
        return Observable<String>.create { (observable) -> Disposable in
            print(#function)
            KOSession.shared()?.close()
            KOSession.shared()?.open(completionHandler: { (error) in
                guard KOSession.shared()?.isOpen() ?? false else {
                    observable.onError(NSError())
                    return
                }
                
                KOSessionTask.userMeTask(completion: { (error, me) in
                    if let id = me?.id {
                        observable.onNext(id)
                        observable.onCompleted()
                    } else {
                        observable.onError(NSError())
                    }
                })
            }, authTypes: [NSNumber(value: KOAuthType.talk.rawValue)])
            
            return Disposables.create()
        }
    }
    
    func login(id: String) {
        UserAPI.kakaoLogin(id: id)
        .flatMap({ data in
            return UserAPI.getMe()
        }).flatMap({ _ in
            return MessageAPI.registerPushKey()
        }).flatMap({ _ in
            return UserAPI.getUserInfo()
        }).flatMap({ _ in
            return Session.me!.reload()
        }).subscribe(onSuccess: { [weak self] (_) in
            self?.output.onNext(true)
            self?.output.onCompleted()
            }, onError: { [weak self] (error) in
                switch error {
                case let ApolloError.gqlErrors(errors):
                    self?.error.onNext(errors.first?.message ?? "로그인 중 오류가 발생하였습니다.")
                default:
                    self?.error.onNext("로그인 중 오류가 발생하였습니다.")
                }
        }).disposed(by: disposeBag)
    }
}
