//
//  ClassTVC.swift
//  Plug
//
//  Created by changmin lee on 03/11/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit

class ClassTVC: UITableViewController {
    var type = Role.TEACHER
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setStatusBar(isWhite: true)
        self.setNavibar(isBlue: true)
    }
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return type == .TEACHER ? 2 : 1
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell\(section + 1)", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell\(indexPath.section + 1)", for: indexPath)
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
            self.performSegue(withIdentifier: "list", sender: nil)
        }
    }
}
