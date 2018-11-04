//
//  CodeVC2.swift
//  Plug
//
//  Created by changmin lee on 04/11/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit

class InviteCodeVC2: InviteCodeVC {
    
    override func setButtonAction() {
        self.bottomAction = {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
