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
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "비밀번호를 잊으셨나요?"
        lb.font = UIFont.getBold(withSize: 20)
        lb.textColor = UIColor.charcoalGrey
        lb.numberOfLines = 1
        return lb
    }()
    
    let subTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "가입한 이메일 주소로 임시 비밀번호를 보내드릴게요"
        lb.font = UIFont.getRegular(withSize: 14)   
        lb.textColor = UIColor.blueGrey
        lb.adjustsFontSizeToFitWidth = true
        lb.numberOfLines = 1
        return lb
    }()
    
    let emailTF: PlugTextField = {
        let tf = PlugTextField(type: .email)
        tf.placeholder = "plug@plugapp.me"
        tf.title = "이메일 주소"
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
        self.viewModel.target = self
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
        setTitle(title: "")
        self.view.addSubview(titleLabel)
        self.view.addSubview(subTitleLabel)
        self.view.addSubview(emailTF)
        self.view.addSubview(confirmButton)
        self.emailTF.becomeFirstResponder()
        self.bottomButton = confirmButton
        setLayout()
    }
    
    func setLayout() {
        titleLabel.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(29)
        })
        
        subTitleLabel.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(20)
        })
        
        emailTF.snp.makeConstraints({
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(30)
            $0.left.right.equalToSuperview().inset(24)
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
    var isNetworking: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var target: UIViewController?
    
    init() {
        forgotPressed.subscribe(onNext: { [unowned self] (email) in
            self.isNetworking.accept(true)
            self.reset(email: email)
        }).disposed(by: disposeBag)
    }
    
    func reset(email: String) {
        UserAPI.resetPassword(email: email).subscribe(onSuccess: { [weak self] (_) in
            self?.isNetworking.accept(false)
            self?.forgotSuccess.onNext(true)
            }, onError: { [unowned self] (error) in
                self.isNetworking.accept(false)
                //                showErrorAlert(error: error, sender: self.target)
                self.forgotSuccess.onNext(false)
        }).disposed(by: disposeBag)
    }
}
