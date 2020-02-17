//
//  ForgotVC.swift
//  Plug
//
//  Created by changmin lee on 2020/02/18.
//  Copyright © 2020 changmin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ForgotVC: PlugViewControllerWithButton {
    
    let disposeBag = DisposeBag()
    var viewModel = ForgotViewModel()
    
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
    
    let confirmButton: PlugButton = {
        let btn = PlugButton(theme: ButtonTheme.BLUE, isShadow: true, enable: false)
        btn.setTitle("로그인", for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setBinding() {
        emailTF.validation.bind(to: confirmButton.rx.isEnabled).disposed(by: disposeBag)
        
        confirmButton.rx.tap.debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(emailTF.rx.text.orEmpty).bind(to: viewModel.forgotPressed).disposed(by: disposeBag)
        
        viewModel.forgotSuccess.subscribe(onNext: { [unowned self] (result) in
            if result {
                showAlertWithString("비밀번호 초기화", message: "전송받은 임시 비밀번호로 로그인해주세요.", sender: self, handler: { _ in self.navigationController?.popViewController(animated: true)})
            } else {
                showAlertWithString("비밀번호 초기화", message: "존재하지 않는 이메일입니다.", sender: self)
            }
        }).disposed(by: disposeBag)
    }
    
    override func setViews() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(emailTF)
        
        self.view.addSubview(confirmButton)
        
        
        self.bottomButton = confirmButton
        setLayout()
    }
    
    func setLayout() {
        emailTF.snp.makeConstraints({
            $0.left.equalToSuperview().offset(28)
            $0.top.equalToSuperview().offset(145)
            $0.right.equalToSuperview().offset(-28)
            $0.height.equalTo(52)
        })
    }
}

class ForgotViewModel {
    let disposeBag = DisposeBag()
    //input
    var forgotInput: PublishSubject<String> = PublishSubject()
    var forgotPressed: PublishSubject<String> = PublishSubject()
    
    //output
    var forgotSuccess: PublishSubject<Bool> = PublishSubject()
    
    init() {
        forgotPressed.subscribe(onNext: { [unowned self] (email) in
            self.reset(email: email)
        }).disposed(by: disposeBag)
    }
    
    func reset(email: String) {
        UserAPI.resetPassword(email: email).subscribe(onSuccess: { [weak self] (_) in
                self?.forgotSuccess.onNext(true)
            }, onError: { [weak self] (_) in
                self?.forgotSuccess.onNext(false)
        }).disposed(by: disposeBag)
    }
}
