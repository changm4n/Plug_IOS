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
//    var emailCheck = false {
//        didSet {
//            bottomBtn.isEnabled = emailCheck && passwdCheck
//        }
//    }
//    var passwdCheck = false {
//        didSet {
//            bottomBtn.isEnabled = emailCheck && passwdCheck
//        }
//    }
    
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
        
//        confirmButton.snp.makeConstraints({
//
//        })
    }
}
