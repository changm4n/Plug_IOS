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
    var classData: [ChatRoomApolloFragment] = []
    
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
            let vc = segue.destination as! InviteCodeVC2
            vc.title = "클래스에 초대하기"
            vc.code = set.1
            vc.nameText = "\(set.0) 클래스의 초대코드입니다."
            vc.bottomAction = {
                vc.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classData.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let classItem = classData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "classCell", for: indexPath) as! PlugClassCell
        cell.configure(title: classItem.name, year: classItem.chatRoomAt, count: classItem.kids?.count ?? 0, showArrow: true)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header =  UINib(nibName: "ClassHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ClassHeader
        header?.configure(type: .TEACHER, count: classData.count)
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let classItem = classData[indexPath.row]
        self.performSegue(withIdentifier: "next", sender: (classItem.name,classItem.inviteCode))
    }
}
