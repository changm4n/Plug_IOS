//
//  SettingVC.swift
//  Plug
//
//  Created by changmin lee on 23/12/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit

class SettingVC: PlugViewController {
    
    let teacherHeaders = ["플러그 오프 설정", "기타"]
    let parentHeaders = ["클래스 정보 설정", "기타"]
    
    var teacherTitlesOn: [(String, String)] = [("플러그 오프 설정","plug"), ("휴일 설정","off"), ("근무 시작시간","start"), ("근무 종료시간","end"), ("","desc")]
    var teacherTitlesOff: [(String, String)] = [("플러그 오프 설정","plug"),  ("","desc")]
    let shareTitles: [(String, String)] = [("접근 권한 설정","cell"), ("약관 및 개인정보 처리방침","cell"), ("오픈소스 라이선스","cell")]
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ruleLabel: UILabel!
    
    var datePicker: UIDatePicker?
    var textfield: UITextField = UITextField(frame: CGRect.zero)
    
    var role = SessionRole.NONE
    
    var currentShowing: Int = 0
    var isplugOn: Bool = true
    
    var currentList: [(String, String)] {
        return isplugOn ? teacherTitlesOn : teacherTitlesOff
    }
    
    var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a hh:mm"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "PlugClassCell", bundle: nil), forCellReuseIdentifier: "class")
        self.profileImageView.makeCircle()
        self.setUI()
        self.setData()
        
        view.addSubview(textfield)
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .time
        datePicker?.addTarget(self, action: #selector(pickerChanged(picker:)), for: .valueChanged)
        textfield.inputView = datePicker
        
        self.tableView.tableFooterView = UIView()
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    func setData() {
        guard let me = Session.me else { return }
        self.role = me.role ?? .NONE
    }
    
    func setUI() {
        guard let me = Session.me else { return }
        
        self.nameLabel.text = me.name
        self.ruleLabel.text = me.role == .TEACHER ? "선생님" : "학부모님"
    }
    
    @objc func pickerChanged(picker: UIDatePicker) {
        let indexPath = IndexPath(row: currentShowing == 1 ? 2 : 3, section: 0)
        if let label = tableView.cellForRow(at: indexPath)?.viewWithTag(1) as? UILabel,
            let me = Session.me {
            currentShowing == 1 ? me.schedule.setStartDate(with: picker.date) : me.schedule.setEndDate(with: picker.date)
            label.text = formatter.string(from: picker.date)
        }
    }
    
    @objc func switchChanged(switch: UISwitch) {
        isplugOn = !isplugOn
        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}

extension SettingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        view.endEditing(true)
        guard let me = Session.me else { return }
        
        if self.role == .TEACHER {
            let list = section == 0 ? currentList : shareTitles
            let item = list[row]
            if section == 0 {
                if item.1 == "plug" {
                    
                } else if item.1 == "off" {
                    performSegue(withIdentifier: "holiday", sender: nil)
                } else if item.1 == "start" {
                    if currentShowing == 1 {
                        currentShowing = 0
                        view.endEditing(true)
                    } else {
                        currentShowing = 1
                        if let date = me.schedule.getStartDate() {
                            datePicker?.date = date
                        }
                        textfield.becomeFirstResponder()
                    }
                    
                } else if item.1 == "end" {
                    if currentShowing == 2 {
                        currentShowing = 0
                        view.endEditing(true)
                    } else {
                        currentShowing = 2
                        if let date = me.schedule.getEndDate() {
                            datePicker?.date = date
                        }
                        textfield.becomeFirstResponder()
                    }
                }
                
            } else {
            }
            
        } else if self.role == .PARENT {
//            let item = parentTitles[row]
            if section == 0 {
                
            } else {
                
            }
        } else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        if self.role == .TEACHER {
            let list = section == 0 ? currentList : shareTitles
            let item = list[row]
            let cell = tableView.dequeueReusableCell(withIdentifier: item.1, for: indexPath)
            cell.textLabel?.text = item.0
            if (section == 0 && row == list.count - 2) ||
                (section == 1 && row == list.count - 1) {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            if section == 0 {
                if item.1 == "plug" {
                    if let s = cell.viewWithTag(1) as? UISwitch {
                        s.isOn = isplugOn
                        s.addTarget(self, action: #selector(switchChanged(switch:)), for: .valueChanged)
                    }
                } else if item.1 == "off" {
                    cell.accessoryType = .disclosureIndicator
                    if let v = cell.viewWithTag(1) as? UILabel {
                        if let me = Session.me {
                            let str = me.schedule.getDaysString()
                            v.text = str
                        }
                    }
                    
                } else if item.1 == "start" || item.1 == "end" {
                    if let v = cell.viewWithTag(1) as? UILabel {
                            if let me = Session.me,
                                let startDate = me.schedule.getStartDate(),
                            let endDate = me.schedule.getEndDate() {
                            v.text = formatter.string(from: item.1 == "start" ? startDate : endDate)
                        }
                    }
                }
                return cell
            } else {
                return cell
            }
        } else if self.role == .PARENT {
            if section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlugClassCell
                cell.configure(title: "창민학교", info: "2018 학년도 ・ 이아린", showArrow: true)
                return cell
                
            } else {
                let item = shareTitles[row]
                let cell = tableView.dequeueReusableCell(withIdentifier: item.1, for: indexPath)
                cell.textLabel?.text = item.0
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = ""
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.role == .TEACHER {
            switch section {
            case 0:
                return currentList.count
            case 1:
                return shareTitles.count
            default:
                return 0
            }
            
        } else if self.role == .PARENT {
            return section == 0 ? 0 : shareTitles.count
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header =  UINib(nibName: "ClassHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ClassHeader
        switch self.role {
        case .PARENT:
            header?.label.text = parentHeaders[section]
        case .TEACHER:
            header?.label.text = teacherHeaders[section]
        default:
            break
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        switch section {
        case 0:
            if self.role == .PARENT {
                return 60
            } else {
                let item = currentList[row]
                return item.1 == "desc" ? 64 : 45
            }
        case 1:
            return 45
        default:
            return 0
        }
    }   
}

class SettingCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textLabel?.backgroundColor = UIColor.clear
    }
}
