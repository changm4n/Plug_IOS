//
//  ParentClassVC.swift
//  Plug
//
//  Created by changmin lee on 10/02/2019.
//  Copyright © 2019 changmin. All rights reserved.
//

import UIKit

class ParentClassVC: PlugViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var classYearLabel: UILabel!
    @IBOutlet weak var classCountLabel: UILabel!
    
    var classID: String?
    var classData: ChatRoomApolloFragment? {
        return Session.me?.getChatroomBy(id: classID)
    }
    var members: [UserApolloFragment] = []
    var admins: [UserApolloFragment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setData()
        setColors()
        super.viewWillAppear(animated)
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            navigationController?.navigationBar.barTintColor = UIColor.plugBlue
            navigationController?.navigationBar.tintColor = .white
            self.navigationController?.navigationBar.shadowImage = nil
            statusbarLight = true
        }
        super.willMove(toParentViewController: parent)
    }
    
    private func setColors() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.shadowImage = UIImage()
        statusbarLight = false
    }
    
    func setData() {
        guard let classData = classData else { return }
        members = classData.users?.map({$0.fragments.userApolloFragment}) ?? []
        admins = classData.admins?.compactMap({$0.fragments.userApolloFragment}) ?? []
        members = members.filter({ (member) -> Bool in
            admins.filter({$0.userId == member.userId}).count == 0
        })
        
        tableView.reloadData()
        
        let year = classData.chatRoomAt
        classNameLabel.text = classData.name
        classYearLabel.text = "\(year[...year.index(year.startIndex, offsetBy: 3)]) 학년도"
        classCountLabel.text = "\(members.count + 1)"
    }
}

extension ParentClassVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? admins.count : members.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MemberCell
        let member = section == 0 ? admins[row] : members[row]
        if member.role == .teacher {
            cell.memberNameLabel.text = "\(member.name) 선생님"
            cell.accessoryType = .disclosureIndicator
        } else {
            if let kidName = Session.me?.getKid(chatroomID: classID ?? "", parentID: member.userId)?.name {
                cell.memberNameLabel.text = "\(kidName) 부모님"
            } else {
                cell.memberNameLabel.text = member.name
            }
            cell.accessoryType = .none
        }
        cell.setProfile(with: member.profileImageUrl)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header =  UINib(nibName: "ClassHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ClassHeader
        header?.label.text = section == 0 ? "담당 선생님" : "클래스 구성원"
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let member = members[indexPath.row]
//        performSegue(withIdentifier: "chat", sender: member)
//    }
}