//
//  SelectClassTVC.swift
//  Plug
//
//  Created by changmin lee on 04/11/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit

class SelectClassTVC: UITableViewController {

    var type = SessionRole.TEACHER
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "PlugClassCell", bundle: nil), forCellReuseIdentifier: "classCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setStatusBar(isWhite: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let set = sender as? (String, String) {
            FBLogger.shared.log(id: "myclassChooseClass_classItemBtn_toMyClassShareInvitCode")
            let vc = segue.destination as! InviteCodeVC2
            vc.title = "클래스에 초대하기"
            vc.code = set.1
            vc.desc = "\(set.0) 클래스의 초대코드입니다."
            vc.bottomAction = {
                FBLogger.shared.log(id: "myclassShareInvitCode_completeBtn")
                vc.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Session.me?.classData.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classCell", for: indexPath) as! PlugClassCell
        
        guard let classItem = Session.me?.classData[indexPath.row] else {
            return cell
        }
        
        cell.configure(title: classItem.name, year: classItem.chatRoomAt, count: classItem.kids?.count ?? 0, showArrow: true)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header =  UINib(nibName: "ClassHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ClassHeader
        header?.configure(type: .TEACHER, count: Session.me?.classData.count ?? 0)
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let classItem = Session.me?.classData[indexPath.row] else { return }
        self.performSegue(withIdentifier: "next", sender: (classItem.name,classItem.inviteCode))
    }
}
