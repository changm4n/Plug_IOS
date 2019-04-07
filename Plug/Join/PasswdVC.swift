//
//  PasswdVC.swift
//  Plug
//
//  Created by changmin lee on 2018. 10. 22..
//  Copyright © 2018년 changmin. All rights reserved.
//

import UIKit

class PasswdVC: PlugViewController {

    @IBOutlet weak var emailTextField: PlugTextField!
    @IBOutlet weak var bottomBtn: WideButton!
    
    var emailCheck = false {
        didSet {
            bottomBtn.isEnabled = emailCheck
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setKeyboardHide()
        self.setTextFields()
        self.bottomButton = bottomBtn
        self.bottomBtn.isEnabled = false
        self.bottomAction = {
            guard let email = self.emailTextField.text else { return }
            FBLogger.shared.log(id: "signFindPw_nextBtn_toSignInTempPw")
            FBLogger.shared.log(id: "signFindPw_emailInput")
            self.play()
            
            Networking.refreshPassword(email, completion: { (message, error) in
                self.stop()
                if let message = message {
                    showNetworkError(message: message, sender: self)
                } else {
                    showAlertWithString("비밀번호 초기화", message: "입력하신 메일로 임시 비밀번호가 전송되었습니다.", sender: self)
                }
            })
        }
    }
    
    func setTextFields() {
        emailTextField.type = .email
        emailTextField.changeHandler = { [weak self] text, check in
            self?.emailCheck = check
        }
    }
}
