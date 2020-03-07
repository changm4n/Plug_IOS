//
//  PlugClassCell.swift
//  Plug
//
//  Created by changmin lee on 23/12/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit

class PlugClassCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    func configure(title: String, info: String, showArrow: Bool = false) {
        self.nameLabel.text = title
        self.infoLabel.text = info
        self.accessoryType = showArrow ? .disclosureIndicator : .none
    }
    
    func configure(item: ChatRoomApolloFragment, isAdmin: Bool = true) {
        let year = item.chatRoomAt
        let count = "\(item.kids?.count ?? 0)"
        
        self.nameLabel.text = item.name
        self.accessoryType = isAdmin ? .disclosureIndicator : .none
        
        if isAdmin {
            self.infoLabel.text = "\(year[..<year.index(year.startIndex, offsetBy: 4)]) 학년도 ・ \(count)명"
        } else {
            let tName = item.admins?.first?.fragments.userApolloFragment.name ?? ""
            self.infoLabel.text = "\(year[..<year.index(year.startIndex, offsetBy: 4)]) 학년도 ・ \(tName)"
        }
    }
}
