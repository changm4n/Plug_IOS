//
//  OutClassVC.swift
//  Plug
//
//  Created by changmin lee on 03/01/2019.
//  Copyright © 2019 changmin. All rights reserved.
//

import UIKit

class OutClassVC: PlugViewController {
    let items = ["cell", "outcell"]
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var classID: String?
    var classData: ChatRoomApolloFragment? {
        return Session.me?.getChatroomBy(id: classID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.tableView.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        guard let classData = classData else { return }
        let members = classData.users?.map({$0.fragments.userApolloFragment}) ?? []
        
        tableView.reloadData()
        
        let year = classData.chatRoomAt
        nameLabel.text = classData.name
        infoLabel.text = "\(members.count) ・ \(year[...year.index(year.startIndex, offsetBy: 3)]) 학년도"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setColors()
        setNavibar(isHide: true)
        super.viewWillAppear(animated)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            navigationController?.navigationBar.barTintColor = UIColor.plugBlue
            self.navigationController?.navigationBar.shadowImage = nil
            statusbarLight = true
            
        }
        
        super.willMove(toParent: parent)
    }
    
    private func setColors() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
        statusbarLight = false
    }
}


extension OutClassVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            guard let classData = self.classData else { return }
            let alert = UIAlertController(title: "클래스 나가기", message: "\(classData.name) 클래스에서 나가시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { action in
                
                guard let kid = Session.me?.getKid(chatroom: classData),
                    let roomID = self.classData?.id,
                    let userID = Session.me?.userId else {
                        showAlertWithString("오류", message: "나가기에 실패하였습니다.", sender: self)
                        return
                }
                Networking.withdrawKid(roomID, userID: userID, kidName: kid.name, completion: { (id) in
                    if id == nil {
                        showAlertWithString("오류", message: "나가기에 실패하였습니다.", sender: self)
                        return
                    } else {
                        FBLogger.shared.log(id: "settingParentsClass_dropOut_to")
                        Session.me?.refreshRoom(completion: { (rooms) in
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                })
            }))
            alert.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section  = indexPath.section
        let cell = tableView.dequeueReusableCell(withIdentifier: items[section], for: indexPath)
        cell.separatorInset = .zero
        if section == 0 {
            if let classData = classData,
                let kidName = Session.me?.getKid(chatroom: classData)?.name {
                cell.textLabel?.text = kidName
            }
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header =  UINib(nibName: "ClassHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ClassHeader
        header?.label.text = section == 0 ? "자녀 이름" : ""
        return header
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
}
