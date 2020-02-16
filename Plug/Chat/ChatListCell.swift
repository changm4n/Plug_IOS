//
//  ChatListCell.swift
//  Plug
//
//  Created by changmin lee on 2019/12/08.
//  Copyright © 2019 changmin. All rights reserved.
//

import UIKit
import Kingfisher

class ChatListCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var newImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.makeCircle()
    }
    
    func bind(item: MessageSummary) {
        nameLabel.text = item.displayName
        contentLabel.text = item.lastMessage.text
        roomLabel.text = item.chatroom.name
        newImageView.isHidden = item.unreadCount == 0
        
        if let url = item.sender.profileImageUrl, item.sender.profileImageUrl != "" {
            profileImageView.kf.setImage(with: URL(string: url))
        }
        
        let messageItem = item.lastMessage
        timeLabel.text = messageItem.createAt.isToday() ? messageItem.timeStamp : messageItem.timeStampLong
    }
}

protocol Configurable: UITableViewCell {
    func configure(item: MessageViewItem)
}

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
}

class BlankCell: UITableViewCell, Configurable {
    func configure(item: MessageViewItem) {
    }
}

class ChatRCell: ChatCell, Configurable {
    
    override func awakeFromNib() {
        bubbleView.layer.cornerRadius = 16
        bubbleView.clipsToBounds = true
    }
    
    func configure(item: MessageViewItem) {
        if let message = item.message {
            messageLabel.text = message.text
            timeLabel.text = message.timeStamp
            timeLabel.isHidden = !item.isShowTime
            //            timeLabel.backgroundColor = viewItem.isShowTime ? .blue : .clear
        }
    }
}

class StampCell: UITableViewCell, Configurable {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    func configure(item: MessageViewItem) {
        let format = DateFormatter()
        format.dateFormat = "yyyy. MM. dd. (E)"
        format.locale = Locale(identifier: "ko_KR")
        if let message = item.message {
            timeLabel.text = format.string(from: message.createAt)
        } else {
            timeLabel.text = "error"
        }
    }
}
