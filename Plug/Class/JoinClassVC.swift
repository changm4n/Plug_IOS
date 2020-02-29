//
//  JoinClassVC.swift
//  Plug
//
//  Created by changmin lee on 2020/02/24.
//  Copyright © 2020 changmin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class JoinClassVC: PlugViewControllerWithButton {
    
    let disposeBag = DisposeBag()
    
    let viewModel = JoinClassViewModel()
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "초대 코드를 입력해주세요"
        lb.font = UIFont.getBold(withSize: 20)
        lb.textColor = UIColor.charcoalGrey
        lb.numberOfLines = 1
        return lb
    }()
    
    let subTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "선생님이 안내해준 초대코드를 입력해주세요"
        lb.font = UIFont.getRegular(withSize: 14)
        lb.textColor = UIColor.blueGrey
        lb.adjustsFontSizeToFitWidth = true
        lb.numberOfLines = 1
        return lb
    }()
    
    let codeTF: PlugTextField = {
        let tf = PlugTextField(type: .code)
        tf.placeholder = "알파벳 6자리를 입력해주세요"
        tf.title = "초대코드 6자리"
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.target = self
    }
    override func setBinding() {
        codeTF.validation.bind(to: confirmButton.rx.isEnabled).disposed(by: disposeBag)
        
        confirmButton.rx.tap.debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(codeTF.rx.text.orEmpty).bind(to: viewModel.checkPressed).disposed(by: disposeBag)
        
        viewModel.checkSuccess.subscribe(onNext: { [unowned self] (result) in
            if result {
                let vc = JoinKidVC()
                vc.viewModel = self.viewModel
                vc.viewModel?.target = vc
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                showAlertWithString("클래스 가입 오류", message: "초대코드를 확인해주세요.", sender: self, handler: nil)
            }}).disposed(by: disposeBag)
    }
    
    override func setViews() {
        setTitle(title: "")
        self.view.backgroundColor = .white
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(subTitleLabel)
        self.view.addSubview(codeTF)
        self.view.addSubview(confirmButton)
        
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
        
        codeTF.snp.makeConstraints({
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(30)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        })
    }
}

class JoinClassViewModel {
    var target: UIViewController?
    let disposeBag = DisposeBag()
    var chatroom: ChatRoomApolloFragment? = nil
    //input
    var checkPressed: PublishSubject<(String)> = PublishSubject()
    var joinPressed: PublishSubject<(String)> = PublishSubject()
    
    //output
    var checkSuccess: PublishSubject<Bool> = PublishSubject()
    var joinSuccess: PublishSubject<(Bool, String)> = PublishSubject()

    init() {
        checkPressed.subscribe(onNext: { [unowned self] (code) in
            self.check(code: code)
        }).disposed(by: disposeBag)
        
        joinPressed.subscribe(onNext: { [unowned self] (name) in
            if let userId = Session.me?.userId, let id = self.chatroom?.id {
                self.join(id: id, userId: userId, name: name)
            } else {
                self.joinSuccess.onNext((false, ""))
            }
        }).disposed(by: disposeBag)
    }

    func check(code: String) {
        ChatroomAPI.getChatroom(byCode: code).subscribe(
            onSuccess: { [unowned self] (chatroom) in
                self.chatroom = chatroom
                self.checkSuccess.onNext(true)
            }, onError: { [unowned self] (error) in
                showErrorAlert(error: error, sender: self.target)
        }).disposed(by: disposeBag)
    }
    
    func join(id: String, userId: String, name: String) {
        ChatroomAPI.joinChatroom(id: id, userId: userId, name: name).subscribe(
            onSuccess: { [weak self] (data) in
                self?.joinSuccess.onNext((true, data.applyChatRoom.name))
            }, onError: { [weak self] (error) in
                showErrorAlert(error: error, sender: self?.target)
        }).disposed(by: disposeBag)
    }
}

