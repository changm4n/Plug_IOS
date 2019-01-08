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
    
    var classData: [ChatRoomApolloFragment] = []
    
    var items: [(String, String)] =
        [("classPlus","새로운 클래스 만들기"),
         ("classInvite","기존 클래스에 초대하기")]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setStatusBar(isWhite: true)
        self.setNavibar(isBlue: true)
        self.setData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "list" {
            let vc = segue.destination as! ManageClassVC
            vc.classID = (sender as! ChatRoomApolloFragment).id
        } else if segue.identifier == "invite" {
            let nvc = segue.destination as! UINavigationController
            let vc = nvc.viewControllers[0] as! SelectClassTVC
            vc.classData = classData
        }
    }
    func setData() {
        self.classData = Session.me?.classData ?? []
        self.tableView.reloadData()
    }
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return type == .TEACHER ? 2 : 1
        } else {
            return classData.count
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
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell\(indexPath.section + 1)", for: indexPath) as! ClassCell
            let classItem = classData[indexPath.row]
            cell.configure(title: classItem.name, year: classItem.chatRoomAt, count: classItem.kids?.count ?? 0)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header =  UINib(nibName: "ClassHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ClassHeader
        header?.configure(type: .TEACHER, count: 3)
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
            self.performSegue(withIdentifier: "list", sender: classData[indexPath.row])
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
}
