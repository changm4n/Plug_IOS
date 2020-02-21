//
//  EditClassNameVC.swift
//  Plug
//
//  Created by changmin lee on 08/01/2019.
//  Copyright © 2019 changmin. All rights reserved.
//

import UIKit

class EditClassNameVC: PlugViewController {

    @IBOutlet weak var textField: UITextField!
    
    var handler: ((String) -> Void)?
    var classData: ChatRoomApolloFragment?
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    func setData() {
        guard let classData = classData else { return }
        textField.text = classData.name
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        if textField.text != classData?.name {
            self.handler?(textField.text ?? "")
//            showAlertWithString("", message: "클래스 이름을 \(textField.text ?? "")로 변경했습니다.", sender: self)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
