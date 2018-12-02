//
//  LoginVC.swift
//  Plug
//
//  Created by changmin lee on 2018. 10. 22..
//  Copyright © 2018년 changmin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginVC: PlugViewController {

    @IBOutlet weak var bottomBtn: WideButton!
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setKeyboardHide()
        self.bottomButton = bottomBtn
//        bottomBtn.isEnabled = false
        
        self.bottomAction = {
            guard let email = self.emailTextField.text, let password = self.passwordTextField.text else { return }
            
            Networking.login(email, password: password, completion: { (token) in
                if let token = token {
                    let user = User()
                    user.userId = email
                    User.me = user
                    user.token = token
                    user.save()
                    self.performSegue(withIdentifier: "next", sender: nil)
                }
            })
        }
    }
}



