//
//  SignUpViewController.swift
//  Plug
//
//  Created by changmin lee on 2020/02/16.
//  Copyright © 2020 changmin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SignUpViewController: PlugViewControllerWithButton {
    
    let disposeBag = DisposeBag()
    var viewModel = SignUpViewModel()
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "회원가입"
        lb.font = UIFont.getBold(withSize: 20)
        lb.textColor = UIColor.charcoalGrey
        return lb
    }()
    
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
        btn.setTitle("다음", for: .normal)
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
        
        let signUpForm = Observable.combineLatest(emailTF.inputText.asObserver(), passwdTF.inputText.asObserver()) { (email, password) in
            return (email, password)
        }
        
        signUpForm.bind(to: viewModel.signUpForm).disposed(by: disposeBag)
        
        confirmButton.rx.tap.debounce(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.checkPressed).disposed(by: disposeBag)
//
        viewModel.checkSuccess.subscribe(onNext: { [unowned self] (result, message) in
            if result {
                print(message)
            } else {
                let vc = SetProfileViewController()
                vc.viewModel = self.viewModel
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }).disposed(by: disposeBag)
    }
    
    override func setViews() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(emailTF)
        self.view.addSubview(passwdTF)
        self.view.addSubview(confirmButton)
        
        self.bottomButton = confirmButton
        setLayout()
    }
    
    func setLayout() {
        titleLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(110)
            $0.leading.trailing.equalToSuperview().offset(24)
            $0.height.equalTo(29)
        })
        
        emailTF.snp.makeConstraints({
            $0.left.equalToSuperview().offset(28)
            $0.top.equalTo(titleLabel.snp.bottom).offset(43)
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
