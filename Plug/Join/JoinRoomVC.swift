//
//  JoinRoomVC.swift
//  Plug
//
//  Created by changmin lee on 13/01/2019.
//  Copyright © 2019 changmin. All rights reserved.
//

import UIKit

class JoinRoomVC: PlugViewController {

    @IBOutlet weak var codeTextField: PlugTextField!
    @IBOutlet weak var bottomBtn: WideButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboardHide()
        bottomButton = bottomBtn
        bottomBtn.isEnabled = false
        setTextFields()
        bottomAction = {
            guard let code = self.codeTextField.text else { return }
            FBLogger.log(id: "signUpInputInvitCode_nextBtn_toSignUpInputChildName")
            self.play()
            Networking.getChatroom(byCode: code, completion: { (room) in
                self.stop()
                if room != nil {
                    self.performSegue(withIdentifier: "next", sender: room)
                } else {
                    showAlertWithString("초대코드 오류", message: "유효하지 않은 초대코드입니다.\n초대코드는 6자리의 알파벳 대문자입니다.", sender: self)
                }
                
            })
            
            
        }
    }
    
    func setTextFields() {
        codeTextField.type = .code
        codeTextField.changeHandler = { [weak self] text, check in
            self?.bottomBtn.isEnabled = check
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! kidVC
        vc.classData = sender as? ChatRoomApolloFragment
    }
}
