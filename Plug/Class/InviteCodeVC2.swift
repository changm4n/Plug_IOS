//
//  CodeVC2.swift
//  Plug
//
//  Created by changmin lee on 04/11/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit

class InviteCodeVC2: InviteCodeVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()    
        self.bottomButton = self.bottomBtn
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "share" {
            FBLogger.log(id: "myclassShareInvitCode_invitIntro_to")
            let nvc = segue.destination as! UINavigationController
            let vc = nvc.viewControllers[0] as! WebVC
            vc.urlStr = kUserTip
            vc.title = "초대 방법"
        }
    }
}
