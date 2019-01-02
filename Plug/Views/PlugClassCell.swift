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
    @IBOutlet weak var arrowImage: UIImageView!
    
    func configure(title: String, info: String, showArrow: Bool = false) {
        self.nameLabel.text = title
        self.infoLabel.text = info
        self.arrowImage.isHidden = !showArrow
    }
}
