//
//  CodeVC.swift
//  Plug
//
//  Created by changmin lee on 2020/02/23.
//  Copyright © 2020 changmin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CodeVC: PlugViewControllerWithButton {
    
    let disposeBag = DisposeBag()
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.darkGreyText
        lb.numberOfLines = 1
        return lb
    }()
    
    let subtitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "학부모님들이 이 클래스에 가입할 수 있도록\n아래 초대코드를 안내해주세요"
        lb.font = UIFont.getRegular(withSize: 14)
        lb.textColor = UIColor.charcoalGreyTwo
        lb.textAlignment = .center
        lb.numberOfLines = 2
        return lb
    }()
    
    let codeLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.getBold(withSize: 38)
        lb.textColor = UIColor.textBlue
        lb.numberOfLines = 1
        return lb
    }()
    
    let confirmButton: PlugButton = {
        let btn = PlugButton(theme: ButtonTheme.BLUE, isShadow: true, enable: true)
        btn.setTitle("완료", for: .normal)
        return btn
    }()
    
    let forgotButton: PlugButton = {
        let btn = PlugButton(theme: ButtonTheme.WHITE, isShadow: false, enable: true)
        btn.setTitle("초대방법 자세히 보기", for: .normal)
        return btn
    }()
    
    var year: String? = nil
    var name: String? = nil
    var code: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setBinding() {
        
        confirmButton.rx.tap.subscribe { [weak self] _ in
            Session.me?.reloadChatRoom()
            self?.navigationController?.popToViewController(ofClass: SettingVC.self)
        }.disposed(by: disposeBag)
        
        forgotButton.rx.tap.subscribe(onNext: { [weak self] _ in
//            let vc = ForgotVC()
//            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }
    
    override func setViews() {
        setTitle(title: "")
        self.view.backgroundColor = .white
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(subtitleLabel)
        self.view.addSubview(codeLabel)
        self.view.addSubview(confirmButton)
        self.view.addSubview(forgotButton)
        
        self.bottomButton = forgotButton
        setStrings()
        setLayout()
    }
    
    func setStrings() {
        guard let year = year, let name = name, let code = code else { return }
        let str = "\(year) \(name)클래스를 만들었습니다"
        let myMutableString = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font : UIFont.getBold(withSize: 16)])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor,
                                     value: UIColor.plugBlue,
                                     range: NSRange(location: 0, length: year.count + name.count + 4))
        
        titleLabel.attributedText = myMutableString
        codeLabel.text = code
    }
    
    func setLayout() {
        codeLabel.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
            $0.height.equalTo(47)
        })
        
        subtitleLabel.snp.makeConstraints({
            $0.bottom.equalTo(codeLabel.snp.top).offset(-38)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(42)
        })
                
        titleLabel.snp.makeConstraints({
            $0.bottom.equalTo(subtitleLabel.snp.top).offset(-14)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
        })

        confirmButton.snp.makeConstraints({
            $0.left.equalToSuperview().offset(28)
            $0.right.equalToSuperview().offset(-28)
            $0.height.equalTo(56)
            $0.bottom.equalTo(forgotButton.snp.top).offset(-14)
        })
    }
}

