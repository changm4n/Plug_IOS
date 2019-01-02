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
        bottomButton = bottomBtn
        
        self.bottomAction = {
            self.performSegue(withIdentifier: "next", sender: nil)
        }
    }
//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "next" {
            let vc = segue.destination as! RegisterCodeVC
            vc.title = "플러그 계정 변경"
            vc.bottomAction = {
                showAlertWithString("title", message: "strin", sender: vc)
            }
        }
    }
}


class ChangePWVC: PlugViewController {
    @IBOutlet weak var oldPasswdTextFIeld: PlugTextField!
    @IBOutlet weak var newPasswdTextFIeld: PlugTextField!
    
    @IBOutlet weak var bottomBtn: WideButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboardHide()
        bottomButton = bottomBtn
        
        self.bottomAction = {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

