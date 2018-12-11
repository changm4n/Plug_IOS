//
//  ChatVC.swift
//  Plug
//
//  Created by changmin lee on 05/12/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit

class ChatVC: PlugViewController {
    
    let chatModel = MessageModel()
    /*
     [[날짜헤더 ..cells..][날짜헤더 ..]]
     cells => [ssssbrrrrbsssb]
     */
    
    var messageData: [MessageApolloFragment] = []
    
    var receiverId: String? = nil
    var senderId: String? = nil
    var chatroomId: String? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = chatModel
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setData()
    }
    
    @IBAction func addSampleMessage(_ sender: Any) {
        addMessage(newMessage: MessageItem())
    }
    
    func setData() {
        guard
            let chatroomId = chatroomId,
            let receiverId = receiverId,
            let senderid = senderId else { return }
        
        Networking.getMeassages(chatroomId: chatroomId, userId: senderid, receiverId: receiverId, start: 100, end: nil) { (messages) in
            self.messageData = messages
            self.title = "\(messages.count) 개 수신"
            self.chatModel.setItems(messages: messages.map({ MessageItem(with: $0, isMine: receiverId == $0.sender.userId)
            }))
            self.reloadTableView()
        }
        
        Networking.subscribeMessage { (message) in
            if let newMessage = message.node?.fragments.messageApolloFragment {
                self.addMessage(newMessage: MessageItem(with: newMessage, isMine: receiverId == newMessage.sender.userId))
            }
        }
    }
    
    func addMessage(newMessage: MessageItem) {
        let indexes = self.chatModel.addMessage(newMessage: newMessage)
        self.tableView.beginUpdates()
        
        for index in indexes {
            switch index.1 {
            case -1:
                self.tableView.deleteRows(at: [index.0], with: .automatic)
            case 0:
                self.tableView.reloadRows(at: [index.0], with: .automatic)
            case 1:
                self.tableView.insertRows(at: [index.0], with: .automatic)
            default:
                break
            }
        }
        
        self.tableView.endUpdates()
        self.tableView.scrollToRow(at: indexes.last!.0, at: .bottom, animated: true)
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: self.chatModel.lastIndexPath, at: .bottom, animated: true)
    }
}

extension ChatVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch chatModel.getType(of: indexPath) {
        case .BLANK:
            return 30
        case .LCELL, .RCELL:
            return UITableViewAutomaticDimension
        case .STAMP:
            return 30
        }
    }
}




class ChatCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
}


class ChatRCell: ChatCell {    
    override func awakeFromNib() {
        bubbleView.layer.cornerRadius = 16
        bubbleView.clipsToBounds = true
    }
    
    func configure(viewItem: MessageViewItem) {
        if let message = viewItem.message {
            messageLabel.text = message.text
            timeLabel.text = message.timeStamp
            timeLabel.isHidden = !viewItem.isShowTime
            //            timeLabel.backgroundColor = viewItem.isShowTime ? .blue : .clear
        }
    }
}


class StampCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
}
