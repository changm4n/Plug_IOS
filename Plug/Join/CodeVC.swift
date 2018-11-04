//
//  CodeVC.swift
//  Plug
//
//  Created by changmin lee on 2018. 10. 22..
//  Copyright © 2018년 changmin. All rights reserved.
//

import UIKit

class CodeVC: PlugViewController {
    @IBOutlet weak var bottomBtn: WideButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboardHide()
        bottomButton = bottomBtn
        self.bottomAction = {
            self.performSegue(withIdentifier: "next", sender: nil)
        }
    }
}

class ChioceVC: PlugViewController {
    @IBAction func buttonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "next", sender: nil)
    }
}
