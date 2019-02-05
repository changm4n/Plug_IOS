//
//  LoginVC.swift
//  Plug
//
//  Created by changmin lee on 2018. 10. 22..
//  Copyright © 2018년 changmin. All rights reserved.
//

import UIKit

class LoginVC: PlugViewController ,UITextFieldDelegate {

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
            PlugIndicator.shared.play()
            Networking.login(email, password: password, completion: { (token) in
                if let token = token {
                    let tmp = Session()
                    Session.me = tmp
                    tmp.token = token
                    tmp.save()
                    Networking.getMe(completion: { (me) in
                        if let me = me {
                            let user = Session(withUser: me)
                            user.token = token
                            Session.me = user
                            user.save()
                            Networking.getUserInfoinStart(completion: { (classData, crontab, summary) in
                                Session.me?.classData = classData
                                if let crontab = crontab {
                                    Session.me?.schedule = Schedule(schedule: crontab)
                                }
                                PlugIndicator.shared.stop()
                                self.performSegue(withIdentifier: "next", sender: summary)
                            })
                        } else {
                            PlugIndicator.shared.stop()
                        }
                    })
                } else {
                    PlugIndicator.shared.stop()
                    showAlertWithString("", message: "이메일 또는 비밀번호가 틀렸습니다.", sender: self)
                }
            })
        }
    }
    
    func setTextFields() {
        emailTextField.delegate = self
        emailTextField.type = .email
        emailTextField.changeHandler = { [weak self] text, check in
            self?.emailCheck = check
        }
        
        passwordTextField.delegate = self
        passwordTextField.type = .passwd
        passwordTextField.isSecureTextEntry = true
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
            let tvc = segue.destination as! UITabBarController
            let nvc = tvc.viewControllers?[0] as! UINavigationController
            let vc = nvc.viewControllers[0] as! HomeVC
            vc.summaryData = sender as? [MessageSummary] ?? []
        }
    }
}



