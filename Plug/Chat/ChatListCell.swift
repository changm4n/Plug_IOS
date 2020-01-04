//
//  ChatListCell.swift
//  Plug
//
//  Created by changmin lee on 2019/12/08.
//  Copyright © 2019 changmin. All rights reserved.
//

import UIKit

class ChatListCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var newImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.makeCircle()
    }
}
