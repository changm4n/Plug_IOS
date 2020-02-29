//
//  SettingVC.swift
//  Plug
//
//  Created by changmin lee on 23/12/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingVC: PlugViewController {
    
    let headers = ["플러그 오프 설정", "클래스 관리", "기타"]
    
    var mainCell: [(String, String)] = [("플러그 오프 설정","switch"), ("휴일 설정","off"), ("근무 시작시간","start"), ("근무 종료시간","end"), ("","desc")]
    
    let classCell: [(String, String)] = [("내 클래스 관리/초대코드", "class"), ("새 클래스 만들기", "new"),("클래스 가입하기", "join")]
    let exCell: [(String, String)] = [("약관 및 개인정보 처리방침","privacy"), ("오픈소스 라이선스","opensource"),("로그아웃","logout")]
    
    var cells: [[(String, String)]] {
        get{
            return [mainCell, classCell,exCell]
        }
    }
    
    var classItems: [ChatRoomApolloFragment] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    //    var datePicker: UIDatePicker?
    //    var textfield: UITextField = UITextField(frame: CGRect.zero)
    
    var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a hh:mm"
        return formatter
    }()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.setData()
        
        //        view.addSubview(textfield)
        //
        //        datePicker = UIDatePicker()
        //        datePicker?.datePickerMode = .time
        //        datePicker?.addTarget(self, action: #selector(pickerChanged(picker:)), for: .valueChanged)
        //        textfield.inputView = datePicker
        
        
        self.tableView.register(UINib(nibName: "DefaultCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.tableFooterView = UIView()
        self.tableView.keyboardDismissMode = .onDrag
    }
    
    override func setBinding() {
        guard let me = Session.me else { return }
        me.profileImage.bind(to: profileImageView.rx.image)
            .disposed(by: disposeBag)
        
        headerView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            self?.performSegue(withIdentifier: "profile", sender: nil)
        }).disposed(by: disposeBag)
    }
    
    override func setViews() {
        setTitle(title: "계정 설정")
        guard let me = Session.me else { return }
        self.profileImageView.makeCircle()
        self.nameLabel.text = me.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.setData()
        //        self.setUI()
        

        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        NotificationCenter.default.addObserver(self, selector: #selector(SettingVC.updateOffice), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateOffice()
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func updateOffice() {
        guard let me = Session.me else { return }
        
        //        Networking.updateOffice(isplugOn ? me.schedule.toString() : "") { (cron) in
        //            me.schedule = Schedule(schedule: cron ?? "")
        //        }
    }
    
    //    @objc func pickerChanged(picker: UIDatePicker) {
    //        let indexPath = IndexPath(row: currentShowing == 1 ? 2 : 3, section: 0)
    //        if let label = tableView.cellForRow(at: indexPath)?.viewWithTag(1) as? UILabel,
    //            let me = Session.me {
    //            currentShowing == 1 ? me.schedule.setStartDate(with: picker.date) : me.schedule.setEndDate(with: picker.date)
    //            label.text = formatter.string(from: picker.date)
    //        }
    //    }
    
    @objc func switchChanged(switch: UISwitch) {
        //        FBLogger.shared.log(id: "edit_onoff")
        //        isplugOn = !isplugOn
        //        if isplugOn {
        //            Session.me?.schedule = Schedule(schedule: "0-30 9-18 6,7")
        //        }
        //        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}

extension SettingVC: UITableViewDelegate, UITableViewDataSource {
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y <= 0 {
//            scrollView.contentOffset = CGPoint.zero
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        let item = cells[section][row]
        let id = item.1
        view.endEditing(true)
        guard let me = Session.me else { return }
        
        if id == "class" {
            let vc = ClassListVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if id == "new" {
            let vc = CreateClassVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if id == "join" {
            let vc = JoinClassVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
//                if self.role == .TEACHER {
//                    let list = section == 0 ? currentList : shareTitles
//                    let item = list[row]
//                    if section == 0 {
//                        if item.1 == "plug" {
//
//                        } else if item.1 == "off" {
//                            performSegue(withIdentifier: "holiday", sender: nil)
//                        } else if item.1 == "start" {
//                            FBLogger.shared.log(id: "edit_on_time_start")
//                            if currentShowing == 1 {
//                                currentShowing = 0
//                                view.endEditing(true)
//                            } else {
//                                currentShowing = 1
//                                if let date = me.schedule.getStartDate() {
//                                    datePicker?.date = date
//                                }
//                                textfield.becomeFirstResponder()
//                            }
//
//                        } else if item.1 == "end" {
//                            FBLogger.shared.log(id: "edit_on_time_end")
//                            if currentShowing == 2 {
//                                currentShowing = 0
//                                view.endEditing(true)
//                            } else {
//                                currentShowing = 2
//                                if let date = me.schedule.getEndDate() {
//                                    datePicker?.date = date
//                                }
//                                textfield.becomeFirstResponder()
//                            }
//                        }
//                    } else {
//                    }
//
//                } else if self.role == .PARENT {
//                    if section == 0 {
//                        let classData = classItems[row]
//                        performSegue(withIdentifier: "out", sender: classData.id)
//                    }
//                }
        //
        
        else if id == "logout" {
            showAlertWithSelect("로그아웃", message: "로그아웃 하시겠습니까?", sender: self, handler: { (action) in
//                Networking.removePushKey()
                Session.removeSavedUser()
                let VC = MainVC()
                let NVC = UINavigationController(rootViewController: VC)
                NVC.modalPresentationStyle = .fullScreen
                self.present(NVC, animated: false, completion: nil)
                
            }, canceltype: .default, confirmtype: .destructive)
        } else if id == "privacy" {
            let vc = DescViewController()
            vc.type = .privacy
            self.navigationController?.pushViewController(vc, animated: true)
        } else if item.0 == "오픈소스 라이선스" {
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let item = cells[section][row]
        let id = item.1
        
        if id == "desc" {
            let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! SettingDescCell
//            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            return cell
        }
        
        if id == "switch" {
            let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! SettingSwitchCell
            cell.titleLabel.text = item.0
            cell.switcher.isOn = Session.me?.schedule.isOn ?? false
            cell.switcher.addTarget(self, action: #selector(switchChanged(switch:)), for: .valueChanged)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DefaultCell
        cell.titleLabel.text = item.0
        
        if id == "off" {
            cell.setContentText(text: Session.me?.schedule.getDaysString() ?? "-")
        } else if id == "start" {
            if let date = Session.me?.schedule.getStartDate() {
                cell.setContentText(text: formatter.string(from: date))
            } else {
                cell.setContentText(text: "-")
            }
        } else if id == "end" {
            if let date = Session.me?.schedule.getEndDate(){
                cell.setContentText(text: formatter.string(from: date))
            } else {
                cell.setContentText(text: "-")
            }
        } else {
            cell.indicator.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header =  UINib(nibName: "ClassHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ClassHeader
        header?.label.text = headers[section]
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }   
}

//class SettingCell: UITableViewCell {
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.textLabel?.backgroundColor = UIColor.clear
//    }
//}
