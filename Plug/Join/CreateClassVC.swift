//
//  CreateClassVC.swift
//  Plug
//
//  Created by changmin lee on 29/10/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit

class CreateClassVC: PlugViewController {
    
    @IBOutlet weak var nameTextField: PlugTextField!
    @IBOutlet weak var yearTextField: PlugTextField!
    @IBOutlet weak var bottomBtn: WideButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setKeyboardHide()
        self.setTextField()
        self.bottomButton = bottomBtn
        bottomBtn.isEnabled = false
        let thePicker = UIPickerView()
        thePicker.delegate = self
        yearTextField.inputView = thePicker
        yearTextField.text = "2019"
        
        self.bottomAction = {
            guard let userID = Session.me?.userId,
                let name = self.nameTextField.text,
                let year = self.yearTextField.text else { return }
            Networking.createChatRoom(name, userID: userID, year: year, completion: { (code) in
                if code != nil {
                    self.performSegue(withIdentifier: "next", sender: nil)
                } else {
                    showAlertWithString("오류", message: "클래스 생성 중 오류가 발생하였습니다.", sender: self)
                }
            })
        }
    }
    
    func setTextField() {
        nameTextField.type = .name
        nameTextField.changeHandler = { [weak self] text, check in
            self?.bottomButton?.isEnabled = check
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "next" {
            let vc = segue.destination as! InviteCodeVC
            vc.bottomAction = {
                Networking.getUserInfo(completion: { (classData, crontab) in
                    Session.me?.classData = classData
                    if let crontab = crontab {
                        Session.me?.schedule = Schedule(schedule: crontab)
                        
                    }
                    self.performSegue(withIdentifier: "next", sender: nil)
                })
            }
        }
    }
    
}

extension CreateClassVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return kYears[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        yearTextField.text = kYears[row]
    }
}
