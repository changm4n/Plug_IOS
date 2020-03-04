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

class KakaoSignUpViewModel {
    typealias formType = (String, String, String)
    let disposeBag = DisposeBag()
    var target: UIViewController?
    
    var signUpForm: BehaviorSubject<(String, String)> = BehaviorSubject(value: ("",""))
    var infoForm: BehaviorSubject<String> = BehaviorSubject(value: "")
    //input
    var checkPressed: PublishSubject<Void> = PublishSubject() //email, passwd
    var signUpPressed: PublishSubject<Void> = PublishSubject() // name, url
    
    var selectedId: String = ""
    var seletedImage: UIImage? = nil
    
    var form: Observable<formType>

    //output
    var checkSuccess: PublishSubject<(Bool, String)> = PublishSubject()
    
    var signUpSuccess: PublishSubject<Bool> = PublishSubject()
    
    init() {
        form = Observable.zip(signUpForm.asObserver(), infoForm.asObserver(), resultSelector: { form, name in
            (form.0, form.1, name)
        })
        
        checkPressed.withLatestFrom(signUpForm)
            .subscribe(onNext: { [unowned self] (form) in
                self.selectedId = form.0
                self.isMember(form: form)
            }).disposed(by: disposeBag)
        
        signUpPressed.subscribe(onNext: { [weak self] in
            self?.signUp()
        }).disposed(by: disposeBag)
    }
    
    func isMember(form: (String, String)) {
        UserAPI.isMemeber(id: form.0).subscribe(onSuccess: { [weak self] (success) in
            self?.checkSuccess.onNext((success, "존재하는 사용자 이메일입니다."))
        }, onError: { [weak self] (error) in
            self?.checkSuccess.onNext((true, "네트워크 오류가 발생하였습니다."))
        }).disposed(by: disposeBag)
    }
    
    func signUp() {
        let upload = uploadImage()
        Observable.combineLatest(form, upload) { (f, url) in
            (f.0, f.1, f.2, url)
        }.flatMap({ newForm in
            UserAPI.signUp(userId: newForm.0, passwd: newForm.1, name: newForm.2, url: newForm.3)
        }) .subscribe(onNext: { [weak self] (_) in
            self?.signUpSuccess.onNext(true)
            }, onError: { [weak self] (error) in
                self?.signUpSuccess.onNext(false)
                showErrorAlert(error: error, sender: self?.target)
        }).disposed(by: disposeBag)
    }
    
    func uploadImage() -> Observable<String?> {
        return  UserAPI.uploadIamge(image: seletedImage, userId: selectedId)
    }
    
    func updateImage(image: UIImage, userId: String) {
        UserAPI.uploadIamge(image: seletedImage, userId: selectedId)
    }
}
