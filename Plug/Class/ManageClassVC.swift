//
//  ManageClassVC.swift
//  Plug
//
//  Created by changmin lee on 05/11/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit

class ManageClassVC: PlugViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var classInfoLabel: UILabel!
    
    
    var classID: String?
    var classData: ChatRoomApolloFragment? {
        return Session.me?.getChatroomBy(id: classID)
    }
    var members: [UserApolloFragment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "invite" {
            let nvc = segue.destination as! UINavigationController
            let vc = nvc.viewControllers[0] as! InviteCodeVC2
            vc.title = "클래스에 초대하기"
            vc.code = classData?.inviteCode ?? "-"
            vc.nameText = "\(classData?.name ?? "") 클래스의 초대코드입니다."
            vc.bottomAction = {
                vc.dismiss(animated: true, completion: nil)
            }
        } else {
            let nvc = segue.destination as! UINavigationController
            let vc = nvc.viewControllers[0] as! EditClassVC
            vc.classID = self.classID
        }
        
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
        guard let me = Session.me , let userId = me.userId , let classData = classData else { return }
        members = classData.users?.map({$0.fragments.userApolloFragment}) ?? []
        members = members.filter{ $0.userId != userId }
       
        tableView.reloadData()
        
        let year = classData.chatRoomAt
        classNameLabel.text = classData.name
        classInfoLabel.text = "\(members.count) ・ \(year[...year.index(year.startIndex, offsetBy: 3)]) 학년도"
    }
}


extension ManageClassVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MemberCell
        let member = members[indexPath.row]
        cell.memberNameLabel.text = member.name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header =  UINib(nibName: "ClassHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ClassHeader
        header?.label.text = "클래스 구성원"
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
}


class MemberCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
}
