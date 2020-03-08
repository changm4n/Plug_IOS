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
    
    var onCell: [(String, String)] = [("플러그 오프 설정","switch"), ("휴일 설정","off"), ("근무 시작시간","start"), ("근무 종료시간","end"), ("","desc")]
    var offCell: [(String, String)] = [("플러그 오프 설정","switch"), ("","desc")]
    
    var topCell: [(String, String)] {
        if self.schedule.isOn {
            return onCell
        } else {
            return offCell
        }
    }
    let classCell: [(String, String)] = [("내 클래스 관리/초대코드", "class"), ("새 클래스 만들기", "new"),("클래스 가입하기", "join")]
    let exCell: [(String, String)] = [("약관 및 개인정보 처리방침","privacy"),("로그아웃","logout")]
    
    var cells: [[(String, String)]] {
        get{
            return [topCell, classCell,exCell]
        }
    }
    
    var classItems: [ChatRoomApolloFragment] = []
    var schedule: Schedule!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    //    var datePicker: UIDatePicker?
    //    var textfield: UITextField = UITextField(frame: CGRect.zero)
    
    let selectorView: OffSelectorView = OffSelectorView()
    let startSelector: TimeSelectorView = {
        let selector = TimeSelectorView()
        selector.setTitle(title: "근무 시작시간")
        return selector
    }()
    
    let endSelector: TimeSelectorView = {
           let selector = TimeSelectorView()
           selector.setTitle(title: "근무 종료시간")
           return selector
    }()
    
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
        self.schedule = me.schedule.value
        
        self.schedule.getDaysInt().forEach({ selectorView.selector.selectedDay.insert($0) })
        selectorView.selector.selectedHandler = { [weak self] in
            self?.schedule.setDaysby(arr: $0)
            self?.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        }
        
        if let start = self.schedule.getStartDate() {
            startSelector.selector.picker.setDate(start, animated: false)
        }
        
        startSelector.selector.selectedHandler = { [weak self] in
            self?.schedule.setStartDate(with: $0)
            self?.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
        }
        
        if let end = self.schedule.getEndDate() {
            endSelector.selector.picker.setDate(end, animated: false)
        }
        
        endSelector.selector.selectedHandler = { [weak self] in
            self?.schedule.setEndDate(with: $0)
            self?.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
        }
        
        
        me.profileImage.bind(to: profileImageView.rx.image)
            .disposed(by: disposeBag)
        me.name.bind(to: self.nameLabel.rx.text).disposed(by: disposeBag)
        headerView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            self?.performSegue(withIdentifier: "profile", sender: nil)
        }).disposed(by: disposeBag)
    }
    
    override func setViews() {
        setTitle(title: "계정 설정")
        self.profileImageView.makeCircle()
        self.view.addSubview(selectorView)
        self.view.addSubview(startSelector)
        self.view.addSubview(endSelector)
        
        selectorView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        startSelector.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        endSelector.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        startSelector.layoutIfNeeded()
        endSelector.layoutIfNeeded()
        selectorView.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SettingVC.updateOffice), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateOffice()
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func updateOffice() {
        guard let me = Session.me else { return }
        me.updateOffice(newOffice: self.schedule)
    }
    
    @objc func switchChanged(switchObj: UISwitch) {
        if switchObj.isOn {
            self.schedule = Schedule(schedule: "0-30 9-18 6,7")
        } else {
            self.schedule = Schedule(schedule: "")
        }
        
        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}

extension SettingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        let item = cells[section][row]
        let id = item.1
        view.endEditing(true)
        
        if id == "class" {
            let vc = ClassListVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if id == "new" {
            let vc = CreateClassVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if id == "join" {
            let vc = JoinClassVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if id == "off" {
            self.selectorView.show()
        } else if id == "start" {
            self.startSelector.show()
        } else if id == "end" {
            self.endSelector.show()
        } else if id == "logout" {
            self.logOut()
        } else if id == "privacy" {
            let vc = DescViewController()
            vc.type = .privacy
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let item = cells[section][row]
        let id = item.1
        
        if id == "desc" {
            let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! SettingDescCell
            return cell
        }
        
        if id == "switch" {
            let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! SettingSwitchCell
            cell.titleLabel.text = item.0
            cell.switcher.isOn = self.schedule.isOn
            cell.switcher.addTarget(self, action: #selector(switchChanged(switchObj:)), for: .valueChanged)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DefaultCell
        cell.titleLabel.text = item.0
        
        if id == "off" {
            cell.setContentText(text: self.schedule.getDaysString())
        } else if id == "start" {
            if let date = self.schedule.getStartDate() {
                cell.setContentText(text: formatter.string(from: date))
            } else {
                cell.setContentText(text: "-")
            }
        } else if id == "end" {
            if let date = self.schedule.getEndDate(){
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

extension SettingVC {
    
    func logOut() {
        showAlertWithSelect("로그아웃", message: "로그아웃 하시겠습니까?", sender: self, handler: { [unowned self] (action) in
            UserAPI.logOut().subscribe().disposed(by: self.disposeBag)
            Session.removeSavedUser()
            let VC = MainVC()
            let NVC = UINavigationController(rootViewController: VC)
            NVC.modalPresentationStyle = .fullScreen
            self.present(NVC, animated: false, completion: nil)
            
        }, canceltype: .default, confirmtype: .destructive)
    }
}
