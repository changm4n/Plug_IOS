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
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let confirmButton: PlugButton = {
        let btn = PlugButton(theme: ButtonTheme.BLUE, isShadow: true, enable: false)
        btn.setTitle("로그인", for: .normal)
        return btn
    }()
    
    let forgotButton: PlugButton = {
        let btn = PlugButton(theme: ButtonTheme.WHITE, isShadow: false, enable: true)
        btn.setTitle("비밀번호 찾기", for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func setBinding() {
        self.viewModel.target = self
        Observable.combineLatest(emailTF.validation, passwdTF.validation,
                                 resultSelector: { $0 && $1 })
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        let loginForm = Observable.combineLatest(emailTF.inputText.asObserver(), passwdTF.inputText.asObserver()) { (email, password) in
            return (email, password)
        }
        
        confirmButton.rx.tap.debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(loginForm).bind(to: viewModel.loginPressed).disposed(by: disposeBag)
        
        forgotButton.rx.tap.subscribe(onNext: { [weak self] _ in
            let vc = ForgotVC()
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.loginSuccess.subscribe(onNext: { [weak self] (result) in
            let storyboard = UIStoryboard(name: "Chat", bundle: nil)

            let vc = storyboard.instantiateViewController(withIdentifier: "ChatListVC")
            vc.modalPresentationStyle = .fullScreen
            let nvc = UINavigationController(rootViewController: vc)
            nvc.navigationBar.prefersLargeTitles = true
            nvc.modalPresentationStyle = .fullScreen
            self?.present(nvc, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        viewModel.loginError.asDriver(onErrorJustReturn: "오류")
            .drive(onNext: { [unowned self] (errorMessage) in
                showAlertWithString("로그인 오류", message: errorMessage, sender: self)
            }).disposed(by: disposeBag)
        
        viewModel.isNetworking.subscribe(onNext: { [weak self] (isNetworking) in
            if isNetworking {
                self?.play()
            } else {
                self?.stop()
            }
        }).disposed(by: disposeBag)
    }
    
    override func setViews() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(emailTF)
        self.view.addSubview(passwdTF)
        self.view.addSubview(confirmButton)
        self.view.addSubview(forgotButton)
        self.emailTF.becomeFirstResponder()
        self.bottomButton = forgotButton
        setLayout()
    }
    
    func setLayout() {
        emailTF.snp.makeConstraints({
            $0.left.equalToSuperview().offset(28)
            $0.top.equalToSuperview().offset(145)
            $0.right.equalToSuperview().offset(-28)
            $0.height.equalTo(52)
        })
        
        passwdTF.snp.makeConstraints({
            $0.left.equalToSuperview().offset(28)
            $0.top.equalTo(emailTF.snp.bottom).offset(32)
            $0.right.equalToSuperview().offset(-28)
            $0.height.equalTo(52)
        })
        
        confirmButton.snp.makeConstraints({
            $0.left.equalToSuperview().offset(28)
            $0.right.equalToSuperview().offset(-28)
            $0.height.equalTo(56)
            $0.bottom.equalTo(forgotButton.snp.top).offset(-14)
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
    
    var isNetworking: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var target: UIViewController?
    init() {
        loginPressed.subscribe(onNext: { [unowned self] (form) in
            self.isNetworking.accept(true)
            self.login(form: form)
        }).disposed(by: disposeBag)
    }
    
    func login(form: (String, String)) {
        UserAPI.login(form: form)
            .flatMap({ data in
                return UserAPI.getMe()
            }).flatMap({ _ in
                return MessageAPI.registerPushKey()
            }).flatMap({ _ in
                return UserAPI.getUserInfo()
            }).flatMap({ _ in
                return Session.me!.reload()
            }).subscribe(onSuccess: { [weak self] (_) in
                SubscriptionManager.shared.start()
                self?.isNetworking.accept(false)
                self?.loginSuccess.onNext(true)
                self?.loginSuccess.onCompleted()
                }, onError: { [unowned self] (error) in
                    self.isNetworking.accept(false)
                    showErrorAlert(error: error, sender: self.target)
            }).disposed(by: disposeBag)
    }
}
