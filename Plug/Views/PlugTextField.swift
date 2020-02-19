//
//  PlugTextField.swift
//  Plug
//
//  Created by changmin lee on 29/10/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField
import RxSwift
import RxCocoa

enum FieldType {
    case email, passwd, code, name, none
}
class PlugTextField: SkyFloatingLabelTextField {
    
    let inputText = PublishSubject<String>()
    let validation = BehaviorSubject(value: false)
    
    var changeHandler: ((String, Bool)->Void)?
    var type: FieldType = .none
    
    let disposeBag = DisposeBag()
    
    init(type: FieldType) {
        super.init(frame: CGRect.zero)
        self.type = type
        self.rx.text.orEmpty
            .map({$0.trimmingCharacters(in: .whitespacesAndNewlines)})
            .filter({ $0.count > 0 })
            .bind(to: self.inputText).disposed(by: disposeBag)
        
        switch type {
        case .email:
            bindEmail()
        case .passwd:
            bindPasswd()
        case .name:
            bindName()
        default:
            break
        }
    }
    
    func bindEmail() {
        inputText.map(Validator.isValidEmail(testStr:)).bind(to: validation).disposed(by: disposeBag)
        validation.skip(3).subscribe(onNext: { result in
            self.errorMessage = result ? "" : "이메일 양식으로 입력해주세요."
        }).disposed(by: disposeBag)
    }
    
    func bindPasswd() {
        inputText.map({ $0.count > 7 }).bind(to: validation).disposed(by: disposeBag)
        validation.skip(2).subscribe(onNext: { result in
            self.errorMessage = result ? "" : "8자 이상 입력해주세요."
        }).disposed(by: disposeBag)
    }
    
    func bindName() {
        inputText.map({ $0.count > 1 }).bind(to: validation).disposed(by: disposeBag)
        validation.skip(1).subscribe(onNext: { result in
            self.errorMessage = result ? "" : "2자 이상 입력해주세요."
        }).disposed(by: disposeBag)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    @objc func textFieldDidChanged(_ textField: UITextField) {
//        let text = textField.text ?? ""
//
//        switch type {
//        case .name:
//            if 2...10 ~= text.count {
//                errorMessage = ""
//                self.changeHandler?(text, true)
//            } else if text.count > 10 {
//                errorMessage = "10자까지 입력할 수 있습니다. "
//                self.changeHandler?(text, false)
//            } else {
//                errorMessage = "2자 이상 입력해주세요."
//                self.changeHandler?(text, false)
//            }
//
//        case .code:
//            self.text = text.uppercased()
//            if text.count == 6 {
//                errorMessage = ""
//                self.changeHandler?(text, true)
//            } else {
//                errorMessage = "인증번호는 6자리 입니다."
//                self.changeHandler?(text, false)
//            }
//        case .none:
//            self.changeHandler?(text, false)
//        case .email:
//            if(!Validator.isValidEmail(testStr: text)) {
//                errorMessage = "이메일 양식으로 입력해주세요."
//                self.changeHandler?(text, false)
//            } else {
//                errorMessage = ""
//                self.changeHandler?(text, true)
//            }
//        case .passwd:
//            if 1...7 ~= text.count {
//                errorMessage = "8자 이상 입력해주세요."
//                self.changeHandler?(text, false)
//            } else if text.count >= 8 {
//                errorMessage = ""
//                self.changeHandler?(text, true)
//            } else {
//                errorMessage = ""
//                self.changeHandler?(text, false)
//            }
//        }
//    }
}
