//
//  InviteCodeVC.swift
//  Plug
//
//  Created by changmin lee on 04/11/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit

class InviteCodeVC: PlugViewController {

    @IBOutlet weak var bottomBtn: WideButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bottomButton = bottomBtn
        setButtonAction()
    }
    
    func setButtonAction() {
        self.bottomAction = {
            
        }
    }
}
