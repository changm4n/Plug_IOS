//
//  MultiMessageCell.swift
//  Plug
//
//  Created by changmin lee on 2020/02/28.
//  Copyright © 2020 changmin. All rights reserved.
//

import Foundation
import UIKit

class MultiMessageCell: UITableViewCell {
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        bubbleView.clipsToBounds = true
        bubbleView.layer.cornerRadius = 12
        self.backgroundColor = UIColor.clear
    }
    
    func configure(item: MessageViewItem) {
        if let message = item.message {
            messageLabel.text = message.text
            timeLabel.text = message.timeStamp
        }
    }
}
