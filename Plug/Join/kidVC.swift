//
//  kidVC.swift
//  Plug
//
//  Created by changmin lee on 13/01/2019.
//  Copyright © 2019 changmin. All rights reserved.
//

import UIKit

class kidVC: PlugViewController {

    var code: String?
    var classData: ChatRoomApolloFragment?
    
    @IBOutlet weak var bottomBtn: WideButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: PlugTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setKeyboardHide()
        self.setTextFields()
        bottomButton = bottomBtn
        bottomBtn.isEnabled = false
        
        self.bottomAction = {
            guard let name = self.nameTextField.text,
            let roomId = self.classData?.id,
                let userId = Session.me?.userId else { return }
            self.play()
            Networking.applyChatroom(roomId, userId: userId, kidName: name, completion: { (id) in
                self.stop()
                if id != nil {
                    Networking.getUserInfo(completion: { (classData, crontab) in
                        Session.me?.classData = classData
                        self.performSegue(withIdentifier: "next", sender: nil)
                    })
                } else {
                    showAlertWithString("오류", message: "오류가 발생하였습니다.", sender: self)
                }
            })
        }
        
        if let className = classData?.name,
            let adminName = classData?.admins?.first?.fragments.userApolloFragment.name {
            titleLabel.text = "\(className)클래스 (\(adminName) 선생님)에\n가입했습니다.\n\n자녀 이름을 입력해주세요."
        }
    }
    
    func setTextFields() {
        nameTextField.type = .name
        nameTextField.changeHandler = { [weak self] text, check in
            self?.bottomButton?.isEnabled = check
        }
    }
}
