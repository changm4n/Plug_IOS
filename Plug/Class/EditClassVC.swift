//
//  EditClassVC.swift
//  Plug
//
//  Created by changmin lee on 17/11/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit

class EditClassVC: PlugViewController {

    var data = ["a","b","c","d","e"]
    var yearField = UITextField(frame: CGRect.zero)
    var selectedYear = 2019
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let thePicker = UIPickerView()
        thePicker.delegate = self
        yearField.inputView = thePicker
        yearField.text = "2019"
        view.addSubview(yearField)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([spaceButton, cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        yearField.inputAccessoryView = toolBar
    }
    
    @objc func cancelClick() {
        yearField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "invite" {
            let vc = segue.destination as! InviteCodeVC2
            vc.title = "클래스에 초대하기"
        }
    }
}

extension EditClassVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "option", for: indexPath) as! EditCell
            if indexPath.row == 0 {
                cell.leftLabel.text = "클래스 이름"
                cell.rightLabel.text = "서원초 5-1"
            } else {
                cell.leftLabel.text = "학년도"
                cell.rightLabel.text = "\(selectedYear)"
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                yearField.becomeFirstResponder()
            }
        } else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : data.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header =  UINib(nibName: "ClassHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ClassHeader
        header?.label.text = section == 0 ? "클래스 정보" : "클래스 정보"
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 50 : 70
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "클래스 맴버 삭제", message: "이창민 부모님을 클래스에서 삭제하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { action in
                self.data.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }))
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        }
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
    @IBOutlet weak var rightLabel: UILabel!
}
