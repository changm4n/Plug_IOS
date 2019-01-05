//
//  ChatVC.swift
//  Plug
//
//  Created by changmin lee on 05/12/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit

class ChatVC: PlugViewController, UITextViewDelegate {
    
    let chatModel = MessageModel()
    
    @IBOutlet weak var textFieldBottomLayout: NSLayoutConstraint!
//    @IBOutlet weak var tableViewBottomLayout: NSLayoutConstraint!
//    @IBOutlet weak var tableViewTopLayout: NSLayoutConstraint!
    
    @IBOutlet weak var inputViewHeight: NSLayoutConstraint!
    
    var messageData: [MessageApolloFragment] = []
    
    var receiverId: String? = nil
    var senderId: String? = nil
    var chatroomId: String? = nil
    
    var kOriginHeight: CGFloat = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setKeyboardHide()

        self.tableView.dataSource = chatModel
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        kOriginHeight = self.view.frame.size.height
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func addSampleMessage(_ sender: Any) {
        self.tableView.reloadData()
        return
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard
            text.count > 0,
            let senderId = self.senderId,
            let chatRoomId = self.chatroomId
            else { return }
        self.resetTextView()
        Networking.sendMessage(text: text, chatRoomId: chatRoomId, receiverId: senderId) { [weak self] (result) in
            if let message = result {
//                self?.addMessage(newMessage: MessageItem(with: message, isMine: true))
            }
        }
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
            self.tableView.reloadData()
            self.setTableViewScrollBottom()
        }
        
        Networking.subscribeMessage { (message) in
            if let newMessage = message.node?.fragments.messageApolloFragment {
                self.addMessage(newMessage: MessageItem(with: newMessage, isMine: receiverId == newMessage.sender.userId))
            }
        }
    }
    
    func addMessage(newMessage: MessageItem) {
        self.chatModel.addMessage(newMessage: newMessage)
        self.tableView.reloadData()
    }
    
    func setTableViewScrollBottom(animated: Bool = false) {
        self.tableView.scrollToRow(at: self.chatModel.lastIndexPath, at: .bottom, animated: animated)
    }
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        isKeyboardShow = true
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            
            if self.view.frame.origin.y == 0  {
                self.view.frame.origin.y -= keyboardHeight
                self.tableView.contentInset = UIEdgeInsets(top: keyboardHeight, left: 0, bottom: 0, right: 0)
                self.tableView.scrollIndicatorInsets = self.tableView.contentInset
            }
        }
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        isKeyboardShow = false
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0  {
                self.view.frame.origin.y = 0
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.tableView.scrollIndicatorInsets = self.tableView.contentInset
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        newSize.height += 15
        self.textView.isScrollEnabled = newSize.height >= 67 + 15
        inputViewHeight.constant = min(newSize.height, 67 + 15)
    }
    
    func resetTextView() {
        self.textView.text = ""
        self.inputViewHeight.constant = 50
    }
    
}

extension ChatVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch chatModel.getType(of: indexPath) {
        case .BLANK:
            return 4
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
