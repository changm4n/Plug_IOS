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
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    var desc: String?
    var code: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bottomButton = bottomBtn
        if let desc = desc {
            descLabel.text = desc
        }
        
        if let code = code {
            codeLabel.text = code
        }
    }
}
