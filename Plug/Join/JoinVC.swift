//
//  JoinVC.swift
//  Plug
//
//  Created by changmin lee on 2018. 10. 22..
//  Copyright © 2018년 changmin. All rights reserved.
//

import UIKit

class JoinVC: PlugViewController ,UITextFieldDelegate {

    @IBOutlet weak var bottomBtn: WideButton!
    
    @IBOutlet weak var emailTextField: PlugTextField!
    @IBOutlet weak var passwordTextField: PlugTextField!
    
    var emailCheck = false {
        didSet {
            bottomBtn.isEnabled = emailCheck && passwdCheck
        }
    }
    var passwdCheck = false {
        didSet {
            bottomBtn.isEnabled = emailCheck && passwdCheck
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setKeyboardHide()
        self.setTextFields()
        self.bottomButton = bottomBtn
        bottomBtn.isEnabled = false
        
        self.bottomAction = {
            guard let email = self.emailTextField.text, let password = self.passwordTextField.text else { return }
            self.play()
            Networking.verifyEmail(email, completion: { (code) in
                self.stop()
                if let code = code {
                    let user = Session()
                    user.userId = email
                    user.password = password
                    Session.me = user
                    self.performSegue(withIdentifier: "next", sender: (email, code))
                } else {
                    showAlertWithString("", message: "오류가 발생하였습니다.", sender: self)
                }
            })
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        setColors()
        super.viewWillAppear(animated)
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
        }
        super.willMove(toParentViewController: parent)
    }
    
    private func setColors() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    func setTextFields() {
        emailTextField.delegate = self
        emailTextField.type = .email
        emailTextField.changeHandler = { [weak self] text, check in
            self?.emailCheck = check
        }
        
        passwordTextField.delegate = self
        passwordTextField.type = .passwd
//        passwordTextField.isSecureTextEntry = true
        passwordTextField.changeHandler = { [weak self] text, check in
            self?.passwdCheck = check
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            passwordTextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "next" {
            let vc = segue.destination as! CodeVC
            let data = sender as! (String, String)
            vc.email = data.0
            vc.key = data.1
            vc.bottomAction = {
                if true {
//                if vc.codeTextField.text == vc.key {
                    vc.performSegue(withIdentifier: "next", sender: nil)
                } else {
                    showAlertWithString("인증코드 오류", message: "유효하지 않은 인증코드입니다.\n초대코드는 6자리의 알파벳 대문자입니다.", sender: vc)
                }
            }
        }
    }
}
