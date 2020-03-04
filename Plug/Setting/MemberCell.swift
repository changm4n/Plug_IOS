//
//  MemberCell.swift
//  Plug
//
//  Created by changmin lee on 2020/02/23.
//  Copyright © 2020 changmin. All rights reserved.
//

import Foundation
import UIKit

class MemberCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var memberNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.makeCircle()
    }
    
    func configure(name: String, urlString: String?) {
        memberNameLabel.text = name
        profileImage.setImageWithURL(urlString: urlString)
    }
}

