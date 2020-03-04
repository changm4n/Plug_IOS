//
//  MultiSendCell.swift
//  Plug
//
//  Created by changmin lee on 2020/02/27.
//  Copyright © 2020 changmin. All rights reserved.
//

import Foundation
import UIKit

class MultiSendCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var classNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.makeCircle()
    }

    func configure(name: String, desc: String, urlString: String?) {
        nameLabel.text = name
        classNameLabel.text = desc
        profileImage.setImageWithURL(urlString: urlString)
    }
}
