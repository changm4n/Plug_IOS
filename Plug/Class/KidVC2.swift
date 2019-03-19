//
//  KidVC2.swift
//  Plug
//
//  Created by changmin lee on 13/01/2019.
//  Copyright © 2019 changmin. All rights reserved.
//

import UIKit

class KidVC2: kidVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bottomAction = {
            guard let name = self.nameTextField.text,
                let roomId = self.classData?.id,
                let userId = Session.me?.userId else { return }
            FBLogger.log(id: "myclassInputChildname_completeBtn")
            Networking.applyChatroom(roomId, userId: userId, kidName: name, completion: { (id) in
                if id != nil {
                    Networking.getUserInfo(completion: { (classData, crontab) in
                        Session.me?.classData = classData
                        self.dismiss(animated: true, completion: nil)
                    })
                } else {
                    showAlertWithString("오류", message: "오류가 발생하였습니다.", sender: self)
                }
            })
        }
    }
}
