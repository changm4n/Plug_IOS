//
//  CreateClassVC.swift
//  Plug
//
//  Created by changmin lee on 2020/02/23.
//  Copyright © 2020 changmin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CreateClassVC: PlugViewControllerWithButton {
    
    let disposeBag = DisposeBag()
    
    let viewModel = CreateClassViewModel()
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "클래스 이름을 정해주세요"
        lb.font = UIFont.getBold(withSize: 20)
        lb.textColor = UIColor.charcoalGrey
        lb.numberOfLines = 1
        return lb
    }()
    
    let subTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "클래스 이름은 짧을수록 좋아요"
        lb.font = UIFont.getRegular(withSize: 14)
        lb.textColor = UIColor.blueGrey
        lb.adjustsFontSizeToFitWidth = true
        lb.numberOfLines = 1
        return lb
    }()
    
    let nameTF: PlugTextField = {
        let tf = PlugTextField(type: .name)
        tf.placeholder = "플러그초 6-1"
        tf.title = "클래스 이름"
        tf.titleColor = .textBlue
        tf.lineHeight = 1
        tf.selectedLineColor = .plugBlue
        tf.errorColor = .plugRed
        return tf
    }()
    
    let yearTF: PlugTextField = {
        let tf = PlugTextField(type: .none)
        tf.placeholder = "2020"
        tf.title = "학년도"
        tf.text = "2020"
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
        nameTF.validation.bind(to: confirmButton.rx.isEnabled).disposed(by: disposeBag)
        self.bindForm()
    }
    
    func bindForm() {
        self.viewModel.target = self
        let createForm = Observable.combineLatest(nameTF.rx.text.orEmpty, yearTF.rx.text.orEmpty) { (email, year) in
            return (email, year)
        }
        
        confirmButton.rx.tap.debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(createForm).bind(to: viewModel.createPressed).disposed(by: disposeBag)
        
        viewModel.createSuccess.subscribe(onNext: { [unowned self] (result) in
            if let code = result {
                let vc = CodeVC()
                vc.code = code
                vc.name = self.nameTF.text
                vc.year = self.yearTF.text
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                showAlertWithString("오류", message: "클래스 생성에 실패하였습니다.", sender: self, handler: nil)
            }}
        ).disposed(by: disposeBag)
    }
    
    override func setViews() {
        setTitle(title: "")
        self.view.backgroundColor = .white
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(subTitleLabel)
        self.view.addSubview(nameTF)
        self.view.addSubview(yearTF)
        self.view.addSubview(confirmButton)
        
        let thePicker = UIPickerView()
        thePicker.delegate = self
        yearTF.inputView = thePicker
        
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
        
        nameTF.snp.makeConstraints({
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(30)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        })
        
        yearTF.snp.makeConstraints({
            $0.top.equalTo(nameTF.snp.bottom).offset(32)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        })
    }
}

extension CreateClassVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return kYears.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return kYears[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        yearTF.text = kYears[row]
    }
}


class CreateClassViewModel {
    let disposeBag = DisposeBag()
    var target: UIViewController?
    //input
    var createPressed: PublishSubject<(String, String)> = PublishSubject()

    //output
    var createSuccess: PublishSubject<String?> = PublishSubject()

    init() {
        createPressed.subscribe(onNext: { [unowned self] (name, year) in
            self.create(name: name, year: year)
        }).disposed(by: disposeBag)
    }

    func create(name: String, year: String) {
        guard let userId = Session.me?.userId else {
            createSuccess.onNext(nil)
            return
        }
        ChatroomAPI.createChatroom(userId: userId, name: name, year: year)
            .subscribe(onSuccess: { [weak self] (code) in
                self?.createSuccess.onNext(code)
                }, onError: { [weak self] (error) in
                    showErrorAlert(error: error, sender: self?.target)
            }).disposed(by: disposeBag)
    }
}

