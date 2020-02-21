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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var codeTextField: PlugTextField!
    
    var key = "ERRORR"
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboardHide()
        bottomButton = bottomBtn
        bottomBtn.isEnabled = false
        setUI()
        setTextFields()
    }
    
    func setUI() {
        titleLabel.text = "\(email)으로 전송된\n인증번호 6자리를 입력해주세요."
    }
    
    func setTextFields() {
        firstResponder = codeTextField
        
        codeTextField.type = .code
        codeTextField.changeHandler = { [weak self] text, check in
            self?.bottomBtn.isEnabled = check
        }
    }
}

class ChioceVC: PlugViewController {
    
    @IBOutlet weak var teacherBtn: UIButton!
    @IBOutlet weak var parentBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teacherBtn.setPlugWhite()
        parentBtn.setPlugWhite()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let logId = sender.tag == 0 ? "signUpRole_teacher_toSignUpUsername" : "signUpRole_parents_toSignUpUsername"
        FBLogger.shared.log(id: logId)
        Session.me?.role = sender.tag == 0 ? .TEACHER : .PARENT
        self.performSegue(withIdentifier: "next", sender: nil)
    }
}