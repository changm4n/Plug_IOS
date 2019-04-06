//
//  EditClassVC.swift
//  Plug
//
//  Created by changmin lee on 17/11/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit

class EditClassVC: PlugViewController {

    var selectedYear = 2019
    var selectedName: String = ""
    
    var classID: String?
    var classData: ChatRoomApolloFragment? {
        return Session.me?.getChatroomBy(id: classID)
    }
    
    var users: [UserApolloFragment] {
        return classData?.users?.map({$0.fragments.userApolloFragment}) ?? []
    }
    var kids: [KidApolloFragment] {
        return classData?.kids?.map({$0.fragments.kidApolloFragment}) ?? []
    }
    
    let toolBar = UIToolbar()
    let thePicker = UIPickerView()
    
    var nameTextField: UITextField?
    var yearTextField: UITextField?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setKeyboardHide()
        thePicker.delegate = self
        
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([spaceButton, cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        tableView.keyboardDismissMode = .onDrag
        setData()
    }
    
    func setData() {
        guard let me = Session.me , let classData = classData else { return }
        
        selectedName = classData.name
        selectedYear = Int(classData.chatRoomAt.substr(to: 3)) ?? 2019
        
        tableView.reloadData()
    }
    
    @objc func cancelClick() {
        view.endEditing(true)
    }
    
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        guard let classData = classData else {
            showAlertWithString("오류", message: "클래스 편집 중 오류가 발생하였습니다.", sender: self)
            return
        }
        FBLogger.log(id: "myclassEdit_SaveBtn_toMyClassEach")
        let newYear = "\(selectedYear)"
        
        if selectedName != classData.name || newYear != classData.chatRoomAt.substr(to: 3) {
            Networking.updateChatRoom(classData.id, newName: selectedName, newYear: newYear) { (id) in
                if id == nil {
                    showAlertWithString("오류", message: "클래스 편집 중 오류가 발생하였습니다.", sender: self)
                } else {
                    Session.me?.refreshRoom(completion: { (rooms) in
                        self.dismiss(animated: true, completion: nil)
                    })
                }
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit" {
            let vc = segue.destination as! EditClassNameVC
            vc.classData = self.classData
            vc.handler = { newName in
                self.selectedName = newName
                self.tableView.reloadData()
            }
        }
    }
}

extension EditClassVC: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "option", for: indexPath) as! EditCell
            if indexPath.row == 0 {
                cell.leftLabel.text = "클래스 이름"
                cell.textField.text = selectedName
                cell.textField.delegate = self
                cell.textField.isUserInteractionEnabled = false
                nameTextField = cell.textField
            } else {
                cell.leftLabel.text = "학년도"
                cell.textField.text = "\(selectedYear)"
                cell.textField.inputView = thePicker
                cell.textField.inputAccessoryView = toolBar
                yearTextField = cell.textField
            }
            return cell
        } else {
            let kid = kids[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MemberCell
            
            cell.setProfile(with: kid.parents?.first?.fragments.userApolloFragment.profileImageUrl)
            cell.memberNameLabel.text = "\(kid.name) 부모님"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                performSegue(withIdentifier: "edit", sender: nil)
            } else {
                yearTextField?.becomeFirstResponder()
            }
        } else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : kids.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header =  UINib(nibName: "ClassHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ClassHeader
        header?.label.text = section == 0 ? "클래스 정보" : "클래스 멤버"
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 50 : 70
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        if editingStyle == .delete {
            let kid = kids[indexPath.row]
            let alert = UIAlertController(title: "클래스 맴버 삭제", message: "\(kid.name) 부모님을 클래스에서 삭제하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { action in
                let kid = self.kids[indexPath.row]
                
                guard let roomID = self.classData?.id,
                    let userID = kid.parents?.first?.fragments.userApolloFragment.userId else {
                        showAlertWithString("오류", message: "삭제에 실패하였습니다.", sender: self)
                        return
                }
                Networking.withdrawKid(roomID, userID: userID, kidName: kid.name, completion: { (id) in
                    if id == nil {
                        showAlertWithString("오류", message: "삭제에 실패하였습니다.", sender: self)
                        return
                    } else {
                        Session.me?.refreshRoom(completion: { (rooms) in
                            self.tableView.reloadData()
                        })
                    }
                })
            }))
            alert.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

extension EditClassVC: UIPickerViewDelegate, UIPickerViewDataSource{
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
        selectedYear = Int(kYears[row])!
        tableView.reloadRows(at: [IndexPath(item: 1, section: 0)], with: .none)
    }
}

class EditCell: UITableViewCell {
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
}
