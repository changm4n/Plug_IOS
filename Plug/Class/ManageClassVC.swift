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
    @IBOutlet weak var emptyLabel: UILabel!
    
    var classID: String?
    var classData: ChatRoomApolloFragment? {
        return Session.me?.getChatroomBy(id: classID)
    }
    var members: [UserApolloFragment] = []
    var meUser: UserApolloFragment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "invite" {
            FBLogger.shared.log(id: "myclassEach_invitMembers_to")
            let nvc = segue.destination as! UINavigationController
            let vc = nvc.viewControllers[0] as! InviteCodeVC2
            vc.title = "클래스에 초대하기"
            vc.code = classData?.inviteCode ?? "-"
            vc.desc = "\(classData?.name ?? "") 클래스의 초대코드입니다."
            vc.bottomAction = {
                vc.dismiss(animated: true, completion: nil)
            }
        } else if segue.identifier == "chat" {
            FBLogger.shared.log(id: "myclassEach_chatEach_to")
            let vc = segue.destination as! ChatVC
            vc.receiver = meUser
            vc.sender = sender as? UserApolloFragment
            vc.chatroom = ChatRoomSummaryApolloFragment(id: classData!.id, name: classData!.name, chatRoomAt: classData!.chatRoomAt, createdAt: classData!.createdAt)
        } else {
            FBLogger.shared.log(id: "myclassEach_editClass_to")
            let nvc = segue.destination as! UINavigationController
            let vc = nvc.viewControllers[0] as! EditClassVC
            vc.classID = self.classID
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setData()
        self.setUI()
        setColors()
        super.viewWillAppear(animated)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            parent?.resetNavigationBar()
            navigationController?.navigationBar.barTintColor = UIColor.plugBlue
            navigationController?.navigationBar.tintColor = .white
            self.navigationController?.navigationBar.shadowImage = nil
            statusbarLight = true
        }
        
        super.willMove(toParent: parent)
    }
    
    private func setColors() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        statusbarLight = false
    }
    
    func setData() {
        guard let me = Session.me , let userId = me.userId , let classData = classData else { return }
        members = classData.users?.map({$0.fragments.userApolloFragment}) ?? []
        meUser = members.filter({ $0.userId == userId }).first
        members = members.filter{ $0.userId != userId }
        members.sort { (user1, user2) -> Bool in
            if let kidName1 = Session.me?.getKid(chatroomID: classID ?? "", parentID: user1.userId)?.name,
                let kidName2 = Session.me?.getKid(chatroomID: classID ?? "", parentID: user2.userId)?.name {
               return kidName1 < kidName2
            } else {
               return true
            }
        }
        tableView.reloadData()
    }
    
    func setUI() {
        guard let me = Session.me , let userId = me.userId , let classData = classData else { return }
        
        let year = classData.chatRoomAt
        classNameLabel.text = classData.name
        classInfoLabel.text = "\(members.count) ・ \(year[...year.index(year.startIndex, offsetBy: 3)]) 학년도"
        
        emptyLabel.isHidden = !(members.count == 0)
    }
}


extension ManageClassVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MemberCell
        let member = members[indexPath.row]
        if let kidName = Session.me?.getKid(chatroomID: classID ?? "", parentID: member.userId)?.name {
            cell.memberNameLabel.text = "\(kidName) 부모님"
        } else {
            cell.memberNameLabel.text = member.name
        }
        cell.setProfile(with: member.profileImageUrl)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let member = members[indexPath.row]
        performSegue(withIdentifier: "chat", sender: member)
    }
}


class MemberCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.makeCircle()
    }
    
    func setProfile(with urlString: String?) {
        if let urlStr = urlString {
            profileImage.kf.setImage(with: URL(string: urlStr))
        }
    }
}
