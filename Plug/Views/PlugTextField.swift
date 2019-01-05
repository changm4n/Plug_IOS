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

enum FieldType {
    case email, passwd, code, name, none
}
class PlugTextField: SkyFloatingLabelTextField {
    
    var changeHandler: ((String, Bool)->Void)?
    var type: FieldType = .none
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        let text = textField.text ?? ""
        
        switch type {
        case .name:
            if 2...10 ~= text.count {
                errorMessage = ""
                self.changeHandler?(text, true)
            } else if text.count > 10 {
                errorMessage = "10자까지 입력할 수 있습니다. "
                self.changeHandler?(text, false)
            } else {
                errorMessage = "2자 이상 입력해주세요."
                self.changeHandler?(text, false)
            }
            
        case .code:
            self.text = text.uppercased()
            if text.count == 6 {
                errorMessage = ""
                self.changeHandler?(text, true)
            } else {
                errorMessage = "인증번호는 6자리 입니다."
                self.changeHandler?(text, false)
            }
        case .none:
            self.changeHandler?(text, false)
        case .email:
            if(!Validator.isValidEmail(testStr: text)) {
                errorMessage = "이메일 양식으로 입력해주세요."
                self.changeHandler?(text, false)
            } else {
                errorMessage = ""
                self.changeHandler?(text, true)
            }
        case .passwd:
            if 1...7 ~= text.count {
                errorMessage = "8자 이상 입력해주세요."
                self.changeHandler?(text, false)
            } else if text.count >= 8 {
                errorMessage = ""
                self.changeHandler?(text, true)
            } else {
                errorMessage = ""
                self.changeHandler?(text, false)
            }
        }
    }
}
