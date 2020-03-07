//
//  ChangePWVC.swift
//  Plug
//
//  Created by changmin lee on 2020/03/05.
//  Copyright © 2020 changmin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ChangePWVC: PlugViewControllerWithButton {
    
    let disposeBag = DisposeBag()
    var viewModel: ChangePWViewModel!
    
    let originTF: PlugTextField = {
        let tf = PlugTextField(type: .passwd)
        tf.placeholder = "비밀번호를 입력해주세요"
        tf.title = "기존 비밀번호 입력"
        tf.titleColor = .textBlue
        tf.lineHeight = 1
        tf.selectedLineColor = .plugBlue
        tf.errorColor = .plugRed
        return tf
    }()
    
    let newTF: PlugTextField = {
        let tf = PlugTextField(type: .passwd)
        tf.placeholder = "새로운 비밀번호"
        tf.placeholderColor = .black
        tf.titleColor = .textBlue
        tf.lineHeight = 1
        tf.selectedLineColor = .plugBlue
        tf.errorColor = .plugRed
        return tf
    }()
    
    let confirmButton: PlugButton = {
        let btn = PlugButton(theme: ButtonTheme.BLUE, isShadow: true, enable: false)
        btn.setTitle("완료", for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setBinding() {
        guard let userId = Session.me?.userId else { return }
        viewModel = ChangePWViewModel(userId: userId)
        viewModel.target = self
        
        Observable.combineLatest(originTF.validation, newTF.validation,
                                 resultSelector: { $0 && $1 })
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        let changeForm = Observable.combineLatest(originTF.inputText.asObserver(), newTF.inputText.asObserver()) { (origin, new) in
            return (origin, new)
        }
        
        confirmButton.rx.tap.debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(changeForm).bind(to: viewModel.changePressed).disposed(by: disposeBag)
        
        viewModel.changeSuccess.subscribe(onNext: { (success) in
            showAlertWithString("비밀변호 변경", message: "비밀변호를 변경하였습니다.", sender: self) { [weak self] (_) in
                self?.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
    }
    
    override func setViews() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(originTF)
        self.view.addSubview(newTF)
        self.view.addSubview(confirmButton)
        
        self.bottomButton = confirmButton
        setLayout()
    }
    
    func setLayout() {
        originTF.snp.makeConstraints({
            $0.left.equalToSuperview().offset(28)
            $0.top.equalToSuperview().offset(145)
            $0.right.equalToSuperview().offset(-28)
            $0.height.equalTo(52)
        })
        
        newTF.snp.makeConstraints({
            $0.left.equalToSuperview().offset(28)
            $0.top.equalTo(originTF.snp.bottom).offset(32)
            $0.right.equalToSuperview().offset(-28)
            $0.height.equalTo(52)
        })
    }
}

class ChangePWViewModel {
    let disposeBag = DisposeBag()
    //input
    var changePressed: PublishSubject<(String, String)> = PublishSubject()
    
    //output
    var changeSuccess: PublishSubject<Bool> = PublishSubject()
    
    var target: UIViewController?
    var userId: String
    
    init(userId: String) {
        self.userId = userId
        changePressed.subscribe(onNext: { [unowned self] (form) in
            self.change(form: form)
        }).disposed(by: disposeBag)
    }
    
    func change(form: (String, String)) {
        UserAPI.changePw(userId: userId, origin: form.0, new: form.1)
            .subscribe(onSuccess: { [weak self] (_) in
                self?.changeSuccess.onNext(true)
                self?.changeSuccess.onCompleted()
                }, onError: { [unowned self] (error) in
                    showErrorAlert(error: error, sender: self.target)
            }).disposed(by: disposeBag)
    }
}
