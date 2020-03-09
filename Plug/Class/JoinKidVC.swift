//
//  JoinKidVC.swift
//  Plug
//
//  Created by changmin lee on 2020/02/24.
//  Copyright © 2020 changmin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class JoinKidVC: PlugViewControllerWithButton {
    
    let disposeBag = DisposeBag()
    
    var viewModel: JoinClassViewModel? = nil
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.font = UIFont.getBold(withSize: 20)
        lb.textColor = UIColor.charcoalGrey
        lb.numberOfLines = 1
        return lb
    }()
    
    let subTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "자녀이름을 입력해주세요"
        lb.font = UIFont.getRegular(withSize: 14)
        lb.textColor = UIColor.blueGrey
        lb.adjustsFontSizeToFitWidth = true
        lb.numberOfLines = 1
        return lb
    }()
    
    let nameTF: PlugTextField = {
        let tf = PlugTextField(type: .name)
        tf.placeholder = "이름"
        tf.title = "자녀이름"
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
        guard let viewModel = viewModel else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        nameTF.validation.bind(to: confirmButton.rx.isEnabled).disposed(by: disposeBag)
        
        confirmButton.rx.tap.debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(nameTF.rx.text.orEmpty).bind(to: viewModel.joinPressed).disposed(by: disposeBag)
        
        viewModel.joinSuccess.subscribe(onNext: { [unowned self] (success, name) in
            if success {
                showAlertWithString("클래스 가입", message: "\(name)클래스에 가입되었습니다.", sender: self, handler: { [weak self] _ in
                    self?.navigationController?.popToViewController(ofClass: SettingVC.self)
                })
            }
        }).disposed(by: disposeBag)
    }
    
    override func setViews() {
        setTitle(title: "")
        self.view.backgroundColor = .white
        
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(subTitleLabel)
        self.view.addSubview(nameTF)
        self.view.addSubview(confirmButton)
        self.nameTF.becomeFirstResponder()
        self.bottomButton = confirmButton
        setLayout()
        setTitle()
    }
    
    func setTitle() {
        guard let name = self.viewModel?.chatroom?.name else {
            return
        }
        self.titleLabel.text = "\(name) 클래스에 가입했습니다"
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
        
        nameTF.snp.makeConstraints({
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(30)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        })
    }
}
