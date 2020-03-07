//
//  ClassTVC.swift
//  Plug
//
//  Created by changmin lee on 03/11/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit

class ClassTVC: UITableViewController {
    var type = SessionRole.TEACHER
    
    var itemT: [(String, String)] =
        [("classPlus","새로운 클래스 만들기"),
         ("classInvite","기존 클래스에 초대하기")]
    
    var itemP: [(String, String)] =
        [("classJoin","클래스 가입하기")]
    
    var items: [(String, String)] {
        return type == .TEACHER ? itemT : itemP
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.type = Session.me?.role ?? .NONE
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setStatusBar(isWhite: true)
        self.setNavibar(isBlue: true)
        self.setData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "list" {
            FBLogger.shared.log(id: "myClassMain_eachClass_to")
            let vc = segue.destination as! ManageClassVC
            vc.classID = (sender as! ChatRoomApolloFragment).id
        } else if segue.identifier == "invite" {
            FBLogger.shared.log(id: "myClassMain_invitMembers_to")
        } else if segue.identifier == "list_parent" {
            let vc = segue.destination as! ParentClassVC
            vc.classID = (sender as! ChatRoomApolloFragment).id
        } else if segue.identifier == "create" {
            FBLogger.shared.log(id: "myClassMain_createClass_to")
        } else if segue.identifier == "join" {
            FBLogger.shared.log(id: "myClassMain_signUpClass_to")
        }
    }
    
    func setData() {
        guard let me = Session.me else { return }
        me.refreshRoom(completion: { (classData) in
            self.tableView.reloadData()
        })
        
    }
   
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            scrollView.contentOffset = CGPoint.zero
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return type == .TEACHER ? 2 : 1
        } else {
            return Session.me?.classData.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
            if let label = cell.viewWithTag(2) as? UILabel,
                let imageView = cell.viewWithTag(1) as? UIImageView {
                imageView.image = UIImage(named: items[row].0)
                label.text = items[row].1
            }
            if row == items.count - 1 {
                cell.addBottomLine()
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell\(indexPath.section + 1)", for: indexPath) as! ClassCell
            
            
            guard let classData = Session.me?.classData,
                let classItem = Session.me?.classData[indexPath.row] else {
                return cell
            }
            
            if type == .TEACHER {
                cell.configure(title: classItem.name, year: classItem.chatRoomAt, count: classItem.kids?.count ?? 0)
            } else {
                let teacherName = classItem.admins?.first?.fragments.userApolloFragment.name
                cell.configure(title: classItem.name, year: classItem.chatRoomAt, info: teacherName == nil ? "" : "\(teacherName!) 선생님")
            }
            
            if row == classData.count - 1 {
                cell.addBottomLine()
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header =  UINib(nibName: "ClassHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ClassHeader
        header?.configure(type: type, count: Session.me?.classData.count ?? 0)
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 48 : 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if indexPath.section == 0 {
            if type == .TEACHER {
                let segue = row == 0 ? "create" : "invite"
                self.performSegue(withIdentifier: segue, sender: nil)
            } else {
                self.performSegue(withIdentifier: "join", sender: nil)
            }
        } else {
            guard let classItem = Session.me?.classData[indexPath.row] else { return }
            self.performSegue(withIdentifier: type == .TEACHER ? "list" : "list_parent", sender: classItem)
        }
    }
}

class ClassCell: UITableViewCell {
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var classInfoLabel: UILabel!
    
    func configure(title: String, info: String) {
        self.classNameLabel.text = title
        self.classInfoLabel.text = info
    }
    
    func configure(title: String, year: String, count: Int) {
        self.classNameLabel.text = title
        self.classInfoLabel.text = "\(year[..<year.index(year.startIndex, offsetBy: 4)]) 학년도 ・ \(count)명"
    }
    
    func configure(title: String, year: String, info: String) {
        self.classNameLabel.text = title
        self.classInfoLabel.text = "\(year[..<year.index(year.startIndex, offsetBy: 4)]) 학년도 ・ \(info)"
    }
}
