//
//  RegisterPlugIDVC.swift
//  Plug
//
//  Created by changmin lee on 02/01/2019.
//  Copyright © 2019 changmin. All rights reserved.
//

import UIKit

class RegisterPlugIDVC: PlugViewController {
    
    @IBOutlet weak var bottomBtn: WideButton!
    @IBOutlet weak var emailTextField: PlugTextField!
    @IBOutlet weak var passwordTextField: PlugTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setKeyboardHide()
        bottomButton = bottomBtn
//        self.bottomBtn.isEnabled = false
        self.bottomAction = {
            guard let email = self.emailTextField.text, let password = self.passwordTextField.text else { return }
            self.performSegue(withIdentifier: "next", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "next" {
            let vc = segue.destination as! RegisterCodeVC
            vc.bottomAction = {
                vc.navigationController?.popViewControllers(viewsToPop: 2, animated: true)
            }
        }
    }
}

class RegisterCodeVC: CodeVC {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
