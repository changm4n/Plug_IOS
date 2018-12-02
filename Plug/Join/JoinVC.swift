//
//  JoinVC.swift
//  Plug
//
//  Created by changmin lee on 2018. 10. 22..
//  Copyright © 2018년 changmin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class JoinVC: PlugViewController {

    @IBOutlet weak var bottomBtn: WideButton!
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setKeyboardHide()
        self.bottomButton = bottomBtn
        self.bottomAction = {
            guard let email = self.emailTextField.text, let password = self.passwordTextField.text else { return }
            let user = User()
            user.userId = email
            User.me = user
            self.performSegue(withIdentifier: "next", sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetNavigationBar()
    }
}
