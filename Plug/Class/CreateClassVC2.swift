//
//  CreateClassVC2.swift
//  Plug
//
//  Created by changmin lee on 04/11/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit

class CreateClassVC2: CreateClassVC {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setStatusBar(isWhite: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTextFields()
        self.bottomBtn.isEnabled = false
        self.bottomAction = {
            guard let name = self.nameTextField.text ,
                let me = Session.me?.userId,
                let year = self.yearTextField.text else { return }
            
            FBLogger.shared.log(id: "myclassCreateClass_nextBtn_toMyClassShareInvitCode")
            self.play()
            self.view.endEditing(true)
            Networking.createChatRoom(name, userID: me, year: year, completion: { (code) in
                self.stop()
                if let code = code {
                    Session.me?.refreshRoom(completion: { (rooms) in
                        self.performSegue(withIdentifier: "next", sender: (name,code))
                    })
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "next" {
            if let set = sender as? (String, String) {
                let vc = segue.destination as! InviteCodeVC2
                vc.code = set.1
                vc.desc = "\(set.0) 클래스를 만들었습니다."
                vc.bottomAction = {
                    FBLogger.shared.log(id: "myClassShareInvitCode_completeBtn_toChatMain")
                    vc.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    
    func setTextFields() {
        nameTextField.type = .name
        nameTextField.changeHandler = { [weak self] text, check in
            self?.bottomButton?.isEnabled = check
        }
    }
    
    override func setUI() {
        
    }
}
