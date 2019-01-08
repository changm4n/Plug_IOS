//
//  ChangePlugIDVC.swift
//  Plug
//
//  Created by changmin lee on 02/01/2019.
//  Copyright © 2019 changmin. All rights reserved.
//

import UIKit

class ChangePlugIDVC: PlugViewController {
    @IBOutlet weak var emailTextField: PlugTextField!
    @IBOutlet weak var bottomBtn: WideButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboardHide()
        setTextFields()
        bottomButton = bottomBtn
        bottomBtn.isEnabled = false
        emailTextField.becomeFirstResponder()
        
        self.bottomAction = {
            if let email = self.emailTextField.text {
                Networking.verifyEmail(email, completion: { (code) in
                    if let code = code {
                        self.performSegue(withIdentifier: "next", sender: code)
                    } else {
                        showAlertWithString("오류", message: "인증에 오류가 발생하였습니다.", sender: self)
                    }
                })
            }
        }
        
    }
    func setTextFields() {
        emailTextField.type = .email
        emailTextField.changeHandler = { [weak self] text, check in
            self?.bottomBtn.isEnabled = check
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "next" {
            let vc = segue.destination as! RegisterCodeVC
            vc.title = "플러그 계정 변경"
            vc.key = sender as! String
            vc.email = emailTextField.text ?? ""
            vc.bottomAction = {
                if let input = vc.codeTextField.text, input == vc.key {
                    vc.navigationController?.popViewControllers(viewsToPop: 2, animated: true)
                } else {
                    showAlertWithString("인증코드 오류", message: "유효하지 않은 인증코드입니다.\n초대코드는 6자리의 알파벳 대문자입니다.", sender: vc)
                }
            }
        }
    }
}


class ChangePWVC: PlugViewController, UITextFieldDelegate {
    @IBOutlet weak var oldPasswdTextFIeld: PlugTextField!
    @IBOutlet weak var newPasswdTextFIeld: PlugTextField!
    
    @IBOutlet weak var bottomBtn: WideButton!
    
    var oldCheck = false {
        didSet {
            bottomBtn.isEnabled = oldCheck && newCheck
        }
    }
    var newCheck = false {
        didSet {
            bottomBtn.isEnabled = oldCheck && newCheck
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setKeyboardHide()
        self.setTextFields()
        bottomButton = bottomBtn
        
        self.bottomAction = {
            if let email = Session.me?.userId,
                let old = self.oldPasswdTextFIeld.text,
                let new = self.newPasswdTextFIeld.text {
                Networking.changePW(email, old: old, new: new, completion: { (name, error) in
                    if error != nil {
                        showAlertWithString("오류", message: error?.message ?? "오류가 발생하였습니다.", sender: self)
                    } else {
                        showAlertWithString("", message: "비밀번호를 변경했습니다.", sender: self, handler: { (action) in
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                })
                
            }
        }
    }
    
    func setTextFields() {
        oldPasswdTextFIeld.delegate = self
        oldPasswdTextFIeld.type = .passwd
        oldPasswdTextFIeld.isSecureTextEntry = true
        oldPasswdTextFIeld.changeHandler = { [weak self] text, check in
            self?.oldCheck = check
        }
        
        newPasswdTextFIeld.delegate = self
        newPasswdTextFIeld.type = .passwd
        newPasswdTextFIeld.isSecureTextEntry = true
        newPasswdTextFIeld.changeHandler = { [weak self] text, check in
            self?.newCheck = check
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            return newPasswdTextFIeld.becomeFirstResponder()
        } else {
            return view.endEditing(true)
        }
    }
}

