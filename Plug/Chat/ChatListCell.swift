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
        profileImageView.setImageWithURL(urlString: item.sender.profileImageUrl)
        
        let messageItem = item.lastMessage
        timeLabel.text = messageItem.createAt.isToday() ? messageItem.timeStamp : messageItem.timeStampLong
    }
    
    override func prepareForReuse() {
        nameLabel.text = ""
        contentLabel.text = ""
        roomLabel.text = ""
        newImageView.isHidden = true
        profileImageView.image = nil
        timeLabel.text = ""
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
    
    func setUI() {}
}

class ChatRCell: ChatCell, Configurable {
    
    override func awakeFromNib() {
        bubbleView.clipsToBounds = true
        bubbleView.layer.cornerRadius = 12
        
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
    func setUI() {}
}
