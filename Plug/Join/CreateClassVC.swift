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
    
    let rows = ["2016","2017","2018","2019","2020"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setKeyboardHide()
        self.bottomButton = bottomBtn
        let thePicker = UIPickerView()
        thePicker.delegate = self
        yearTextField.inputView = thePicker
        yearTextField.text = "2019"
        
        self.bottomAction = {
            self.performSegue(withIdentifier: "next", sender: nil)
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
        return rows[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        yearTextField.text = rows[row]
    }
}
