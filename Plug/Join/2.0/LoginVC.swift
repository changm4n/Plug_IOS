//
//  LoginVC.swift
//  Plug
//
//  Created by changmin lee on 2020/02/05.
//  Copyright © 2020 changmin. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa


class LoginVC2: PlugViewControllerWithButton {
    let disposeBag = DisposeBag()
    var viewModel = LoginViewModel()
    
    let emailTF: PlugTextField = {
        let tf = PlugTextField(type: .email)
        tf.placeholder = "이메일 주소"
        tf.placeholderColor = .black
        tf.titleColor = .textBlue
        tf.lineHeight = 1
        tf.selectedLineColor = .plugBlue
        tf.errorColor = .plugRed
        return tf
    }()
    
    let passwdTF: PlugTextField = {
        let tf = PlugTextField(type: .passwd)
        tf.placeholder = "비밀번호"
        tf.placeholderColor = .black
        tf.titleColor = .textBlue
        tf.lineHeight = 1
        tf.selectedLineColor = .plugBlue
        tf.errorColor = .plugRed
        return tf
    }()
    
    let confirmButton: PlugButton = {
        let btn = PlugButton(theme: ButtonTheme.BLUE, isShadow: true, enable: false)
        btn.setTitle("로그인", for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setBinding() {
        Observable.combineLatest(emailTF.validation, passwdTF.validation,
                                 resultSelector: { $0 && $1 })
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        let loginForm = Observable.combineLatest(emailTF.inputText.asObserver(), passwdTF.inputText.asObserver()) { (email, password) in
            return (email, password)
        }
        
        confirmButton.rx.tap.debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(loginForm).bind(to: viewModel.loginPressed).disposed(by: disposeBag)
        
        viewModel.loginSuccess.subscribe(onNext: { (result) in
            let storyboard = UIStoryboard(name: "Chat", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MainNVC")
            controller.modalPresentationStyle = .fullScreen
            self.navigationController?.present(controller, animated: true, completion: nil)
            
        }).disposed(by: disposeBag)
        
        viewModel.loginError.asDriver(onErrorJustReturn: "오류")
            .drive(onNext: { (errorMessage) in
                print(errorMessage)
            }).disposed(by: disposeBag)
        
    }
    
    override func setViews() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(emailTF)
        self.view.addSubview(passwdTF)
        self.view.addSubview(confirmButton)
        
        self.bottomButton = confirmButton
        setLayout()
    }
    
    func setLayout() {
        emailTF.snp.makeConstraints({
            $0.left.equalToSuperview().offset(28)
            $0.top.equalToSuperview().offset(177)
            $0.right.equalToSuperview().offset(-28)
            $0.height.equalTo(52)
        })
        
        passwdTF.snp.makeConstraints({
            $0.left.equalToSuperview().offset(28)
            $0.top.equalTo(emailTF.snp.bottom).offset(32)
            $0.right.equalToSuperview().offset(-28)
            $0.height.equalTo(52)
        })
    }
}

class LoginViewModel {
    let disposeBag = DisposeBag()
    //input
    var loginPressed: PublishSubject<(String, String)> = PublishSubject()
    
    //output
    var loginSuccess: PublishSubject<Bool> = PublishSubject()
    var loginError: PublishSubject<String> = PublishSubject()
    
    init() {
        loginPressed.subscribe(onNext: { [unowned self] (form) in
            self.login(form: form)
        }).disposed(by: disposeBag)
    }
    
    func login(form: (String, String)) {
        UserAPI.login(form: form)
            .flatMap({ data in
                return UserAPI.getMe()
            }).flatMap({ _ in
                return UserAPI.registerPushKey()
            }).flatMap({ _ in
                return UserAPI.getUserInfo()
            }).subscribe(onSuccess: { [weak self] (_) in
                self?.loginSuccess.onNext(true)
                self?.loginSuccess.onCompleted()
                }, onError: { [weak self] (error) in
                    switch error {
                    case let ApolloError.gqlErrors(errors):
                        self?.loginError.onNext(errors.first?.message ?? "로그인 중 오류가 발생하였습니다.")
                    default:
                        self?.loginError.onNext("로그인 중 오류가 발생하였습니다.")
                    }
            }).disposed(by: disposeBag)
    }
}
