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
    var classData: ChatRoomApolloFragment!
    @IBOutlet weak var classInfoLabel: UILabel!
    
    var members: [UserApolloFragment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        guard let me = Session.me , let userId = me.userId else { return }
        members = classData.users?.map({$0.fragments.userApolloFragment}) ?? []
        members = members.filter{ $0.userId != userId }
        for member in members {
            print(member.userId)
        }
        tableView.reloadData()
        
        classNameLabel.text = classData.name
        classInfoLabel.text = "\(members.count) ・ 2018 학년도"
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
