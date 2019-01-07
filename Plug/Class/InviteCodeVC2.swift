//
//  CodeVC2.swift
//  Plug
//
//  Created by changmin lee on 04/11/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit

class InviteCodeVC2: InviteCodeVC {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    var code: String = "-"
    var nameText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bottomButton = self.bottomBtn
        nameLabel.text = nameText
        codeLabel.text = code
    }
}
