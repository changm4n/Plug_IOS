//
//  LoginVC.swift
//  Plug
//
//  Created by changmin lee on 2018. 10. 22..
//  Copyright © 2018년 changmin. All rights reserved.
//

import UIKit

class LoginVC: PlugViewController {

    @IBOutlet weak var bottomBtn: WideButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setKeyboardHide()
        self.bottomButton = bottomBtn
//        bottomBtn.isEnabled = false
        self.bottomAction = {
            self.performSegue(withIdentifier: "next", sender: nil)
        }
    }
}
