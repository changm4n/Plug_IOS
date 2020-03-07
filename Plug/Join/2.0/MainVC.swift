//
//  MainVC.swift
//  Plug
//
//  Created by changmin lee on 2020/02/05.
//  Copyright © 2020 changmin. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

class MainVC: PlugViewController {
    
    let kakaoManager = KakaoLoginManager()
    let disposeBag = DisposeBag()
    
    let selectorView: LoginSelectorView = LoginSelectorView()
    
    let logoIV: UIImageView = {
        var iv = UIImageView(image: UIImage(named: "icTextLogoPrimary"))
        return iv
    }()
    
    let titleLabel: UILabel = {
        var lb = UILabel(frame: CGRect.zero)
        lb.text = "학부모와 교사를\n새롭게\n연결합니다."
        lb.font = UIFont.getBold(withSize: 38)
        lb.numberOfLines = 3
        return lb
    }()
    
    let kakaoButton: PlugButton = {
        let btn = PlugButton(theme: ButtonTheme.BLUE, isShadow: true)
        btn.setTitle("카카오톡 회원가입", for: .normal)
        return btn
    }()
    
    let emailButton: PlugButton = {
        let btn = PlugButton(theme: ButtonTheme.WHITE, isShadow: true)
        btn.setTitle("이메일로 회원가입", for: .normal)
        return btn
    }()
    
    let loginButton: PlugButton = {
        let btn = PlugButton(theme: ButtonTheme.WHITE, isShadow: false)
        btn.setTitle("로그인", for: .normal)
        return btn
    }()
    
    let descLabel: UILabel = {
        let lb = UILabel(frame: CGRect.zero)
        lb.attributedText = kLaunchDescString
        lb.numberOfLines = 2
        lb.textColor = UIColor.textBlue
        lb.textAlignment = .center
        return lb
    }()
    
    let blockView: UIView = {
        let v = UIView(frame: CGRect.zero)
        v.isUserInteractionEnabled = false
        v.backgroundColor = UIColor(white: 0, alpha: 0.0)
        v.isHidden = true
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    override func setViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(logoIV)
        self.view.addSubview(titleLabel)
        self.view.addSubview(kakaoButton)
        self.view.addSubview(emailButton)
        self.view.addSubview(loginButton)
        self.view.addSubview(descLabel)
        self.view.addSubview(blockView)
        self.view.addSubview(selectorView)
        
        setLayout()
    }
    
    override func setBinding() {
        descLabel.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] (_) in
            let vc = DescViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
        Observable.of(kakaoButton.rx.tap.asDriver(), selectorView.kakaoButton.rx.tap.asDriver()).merge()
            .asDriver(onErrorJustReturn: ())
            .drive(kakaoManager.input)
            .disposed(by: disposeBag)
        
        kakaoManager.isNetworking.subscribe(onNext: { [weak self] (isNetworking) in
            if isNetworking {
                self?.play()
            } else {
                self?.stop()
            }
        }).disposed(by: disposeBag)
        
        kakaoManager.output.subscribe(onNext: { [unowned self] (isMember, id) in
            if isMember {
                let storyboard = UIStoryboard(name: "Chat", bundle: nil)

                let vc = storyboard.instantiateViewController(withIdentifier: "ChatListVC")
                vc.modalPresentationStyle = .fullScreen
                let nvc = UINavigationController(rootViewController: vc)
                nvc.navigationBar.prefersLargeTitles = true
                nvc.modalPresentationStyle = .fullScreen
                self.present(nvc, animated: true, completion: nil)
            } else {
                let vc = SetProfileViewController()
                let viewModel = SignUpViewModel(type: .KAKAO)
                viewModel.signUpForm.onNext((id, ""))
                viewModel.selectedId = id
                
                vc.viewModel = viewModel
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }).disposed(by: disposeBag)
        
        kakaoManager.error.subscribe(onNext: { [unowned self] (message) in
            showAlertWithString("오류", message: message, sender: self)
        }).disposed(by: disposeBag)
        
        emailButton.rx.tap.asDriver().drive(onNext: { [weak self]  in
            let vc = SignUpViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
        loginButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.showSelector()
        }).disposed(by: disposeBag)
        
        selectorView.emailButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.hideSelector()
            let VC = LoginVC2()
            self?.navigationController?.pushViewController(VC, animated: true)
        }).disposed(by: disposeBag)
        
        blockView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            self?.hideSelector()
        }).disposed(by: disposeBag)
    }
    
    func showSelector() {
        blockView.isHidden = false
        self.selectorView.snp.updateConstraints {
            $0.top.equalTo(self.view.snp.bottom).offset(-260)
        }
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.blockView.backgroundColor = UIColor(white: 0, alpha: 0.4)
            self?.view.layoutIfNeeded()
        })
        blockView.isUserInteractionEnabled = true
    }
    
    func hideSelector() {
        self.selectorView.snp.updateConstraints {
            $0.top.equalTo(self.view.snp.bottom)
        }
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.blockView.backgroundColor = UIColor(white: 0, alpha: 0.0)
            self?.view.layoutIfNeeded()
            }, completion: { [weak self] _ in
                self?.blockView.isHidden = true
        })
        blockView.isUserInteractionEnabled = false
    }
    
    func setLayout() {
        logoIV.snp.makeConstraints {
            $0.top.equalToSuperview().offset(74)
            $0.left.equalToSuperview().offset(24)
            $0.height.equalTo(26)
            $0.width.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints({
            $0.top.equalTo(logoIV.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(24)
            $0.bottom.equalTo(kakaoButton.snp.top).offset(-40)
        })
        
        kakaoButton.snp.makeConstraints({
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(56)
            $0.bottom.equalTo(emailButton.snp.top).offset(-14)
        })
        
        emailButton.snp.makeConstraints({
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(56)
            $0.bottom.equalTo(loginButton.snp.top).offset(-14)
        })
        
        loginButton.snp.makeConstraints({
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(56)
            $0.bottom.equalTo(descLabel.snp.top).offset(-14)
        })
        
        descLabel.snp.makeConstraints({
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(-30)
        })
        
        selectorView.snp.makeConstraints({
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalTo(self.view.snp.bottom)
            $0.height.equalTo(270)
        })
        selectorView.layoutIfNeeded()
        
        blockView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
}

class LoginSelectorView: UIView {
    let titleLabel: UILabel = {
        var lb = UILabel(frame: CGRect.zero)
        lb.text = "로그인 방법을 선택해주세요"
        lb.font = UIFont.getBold(withSize: 17)
        lb.numberOfLines = 1
        return lb
    }()
    
    let kakaoButton: PlugButton = {
        let btn = PlugButton(theme: ButtonTheme.BLUE, isShadow: true)
        btn.setTitle("카카오톡으로 로그인", for: .normal)
        return btn
    }()
    
    let emailButton: PlugButton = {
        let btn = PlugButton(theme: ButtonTheme.WHITE, isShadow: true)
        btn.setTitle("이메일로 로그인", for: .normal)
        return btn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(titleLabel)
        self.addSubview(kakaoButton)
        self.addSubview(emailButton)
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        
        setLayout()
    }
    
    func setLayout() {
        titleLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(29)
            $0.left.equalToSuperview().offset(28)
            $0.height.equalTo(25)
        })
        
        kakaoButton.snp.makeConstraints({
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(56)
            $0.top.equalTo(titleLabel.snp.bottom).offset(26)
        })
        
        emailButton.snp.makeConstraints({
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.height.equalTo(56)
            $0.top.equalTo(kakaoButton.snp.bottom).offset(16)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
