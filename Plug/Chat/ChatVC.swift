//
//  ChatVC.swift
//  Plug
//
//  Created by changmin lee on 05/12/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit

class ChatVC: PlugViewController, UITextViewDelegate {
    
    @IBOutlet weak var textFieldBottomLayout: NSLayoutConstraint!
    @IBOutlet weak var inputViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bannerYOffset: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var inputField: UIView!
    @IBOutlet weak var banner: UILabel!
    
    let chatModel = MessageModel()
    var messageData: [MessageApolloFragment] = []
    
    var isLoading: Bool = false
    var isEnd: Bool = false
    var isPlugOn: Bool = true {
        didSet {
            setTitle()
        }
    }
    
    var receiver: UserApolloFragment? = nil
    var sender: UserApolloFragment? = nil
    var chatroom: ChatRoomSummaryApolloFragment? = nil

    var kOriginHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setKeyboardHide()

        kOriginHeight = self.view.frame.size.height
        sendButton.makeCircle()

        tableView.dataSource = chatModel
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        textView.layer.cornerRadius = 18
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(r: 215, g: 215, b: 215).cgColor
        textView.contentInset = UIEdgeInsets.zero
        
        textView.textContainerInset.left = 8
        textView.textContainerInset.right = 8
        
        setData()
        setUI()
        setTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setColors()
        super.viewWillAppear(animated)
        
        readMessage()
        
        guard
            let chatroomId = chatroom?.id,
            let senderid = sender?.userId else { return }
        
        let hash = "\(senderid)_\(chatroomId)"
        if let text = getUserDefaultStringValue(hash) {
            textView.text = text
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        
        saveTextViewText()
        readMessage()
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kMessageReceived), object: nil)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            statusbarLight = true
            
            if self.navigationController?.viewControllers.count ?? 0 == 3 {
                self.navigationController?.navigationBar.isTranslucent = false
            }
        }
        
        super.willMove(toParent: parent)
    }
    
    private func setColors() {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.isTranslucent = true
        statusbarLight = false
    }
    
    @IBAction func addSampleMessage(_ sender: Any) {
        
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard
            text.count > 0,
            let senderId = self.sender?.userId,
            let chatRoomId = self.chatroom?.id
            else { return }
        
        if isPlugOn {
            FBLogger.shared.log(id: "chatEach_sendBtn")
            self.resetTextView()
            self.sendMessage(text: text, chatroomID: chatRoomId, receiverId: senderId)
        } else {
            
            showAlertWithSelect("플러그 오프 안내", message: "선생님의 근무시간이 아닙니다.\n메시지를 확인하지 못할 수도 있습니다. ", sender: self, handler: { (action) in
                FBLogger.shared.log(id: "chatEach_PlugOffAlert_sendBtn")
                self.resetTextView()
                self.sendMessage(text: text, chatroomID: chatRoomId, receiverId: senderId)
            }, canceltype: .destructive) { (action) in
                FBLogger.shared.log(id: "chatEach_PlugOffAlert_cancelBtn")
            }
        }
    }
    
    func sendMessage(text: String, chatroomID: String, receiverId: String) {
        
        Networking.sendMessage(text: text, chatRoomId: chatroomID, receiverId: receiverId) { (newMessage) in
            
            guard let newMessage = newMessage else { return }
            self.addMessage(newMessage: MessageItem(with: newMessage, isMine: true))
            self.tableView.reloadData()
            self.setTableViewScrollBottom()
        }
    }
    
    @objc func receiveMessage(_ notification: NSNotification) {
        
        print(Session.me?.summaryData.reduce(0, { (result, message) -> Int in
            return result + message.unreadCount
        }))
        
        guard
            let chatroomId = chatroom?.id,
            let receiverId = receiver?.userId,
            let senderid = sender?.userId else { return }
        
        if let newMessage = notification.userInfo?["message"] as? MessageApolloFragment {
            guard  newMessage.receivers?.first?.userId == receiverId &&
                newMessage.sender.userId == senderid &&
            newMessage.chatRoom.id == chatroomId else {
                    return
            }
            self.addMessage(newMessage: MessageItem(with: newMessage, isMine: receiverId == newMessage.sender.userId))
            self.tableView.reloadData()
            self.setTableViewScrollBottom()
        }
    }

    @objc override func keyboardWillShow(notification: NSNotification) {
        isKeyboardShow = true
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
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
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0  {
                self.view.frame.origin.y = 0
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.tableView.scrollIndicatorInsets = self.tableView.contentInset
            }
        }
    }
    
    @objc override func keyboardChanged(notification: NSNotification) {
        guard isKeyboardShow else { return }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            self.view.frame.origin.y = -keyboardHeight
            self.tableView.contentInset = UIEdgeInsets(top: keyboardHeight, left: 0, bottom: 0, right: 0)
            self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        let fixedHeightOffset: [CGFloat] = [11.5, 14, 14, 14]
//        let fixedHeight: [CGFloat] = [48, 69, 89, 110]
        let maxHeight: CGFloat = 112
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        newSize.height += 14.5
        
        self.textView.isScrollEnabled = newSize.height >= maxHeight
        inputViewHeight.constant = min(newSize.height, maxHeight)
    }
    
    func resetTextView() {
        self.textView.text = ""
        self.inputViewHeight.constant = 50
    }
}

extension ChatVC {
    func setUI() {
        banner.layer.shadowColor = UIColor(r: 155, g: 156, b: 156, a: 0.5).cgColor
        banner.layer.shadowOffset = CGSize(width: 0, height: 2)
        banner.layer.shadowOpacity = 1
        banner.layer.masksToBounds = false
    }
    
    func setData() {
        guard let senderid = sender?.userId else { return }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.enterBackgound), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.receiveMessage(_:)), name: NSNotification.Name(rawValue: kMessageReceived), object: nil)
        
        PlugIndicator.shared.play()
        
        loadMessage {
            PlugIndicator.shared.stop()
        }
        

        
        if Session.me?.role == .PARENT {
            Networking.getOfficeTime(senderid) { (crontab) in
                if let crontab = crontab {
                    let schedule = Schedule(schedule: crontab)
                    self.isPlugOn = crontab == "" ? true : schedule.isPlugOn()
                }
            }
        }
    }
    
    
    func loadMessage(completion: (() -> Void)?) {
        guard
            let chatroomId = chatroom?.id,
            let receiverId = receiver?.userId,
            let senderid = sender?.userId else { return }
        
        Networking.getMeassages(chatroomId: chatroomId, userId: senderid, receiverId: receiverId, before: nil) { (messages) in
            self.messageData = messages
            self.title = "\(messages.count) 개 수신"
            self.chatModel.setItems(messages: messages.map({ MessageItem(with: $0, isMine: receiverId == $0.sender.userId)
            }))
            self.tableView.reloadData()
            self.setTableViewScrollBottom()
            completion?()
        }
    }
    
    @objc func enterForeground() {
        
        loadMessage(completion: nil)
    }
    
    @objc func enterBackgound() {
        
        readMessage()
        saveTextViewText()
    }
    
    func readMessage() {
        guard
            let chatroomId = chatroom?.id,
            let receiverId = receiver?.userId,
            let senderid = sender?.userId else { return }
        Session.me?.readChat(chatRoomId: chatroomId, senderId: senderid)
        Networking.readMessage(chatRoomId: chatroomId, receiverId: receiverId, senderId: senderid)
    }
    
    func saveTextViewText() {
        
        guard
            let chatroomId = chatroom?.id,
            let senderid = sender?.userId else { return }
        
        let hash = "\(senderid)_\(chatroomId)"
        setUserDefaultWithString(textView.text, forKey: hash)
    }
    
    func setTitle() {
        
        guard let senderName = sender?.name,
            let senderId = sender?.userId,
            let chatroomName = chatroom?.name,
            let chatroomId = chatroom?.id,
            let me = Session.me else { return }
        
        var topText: String
        var bottomText: String
        if me.role == .TEACHER,
            let kid = me.getKid(chatroomID: chatroomId, parentID: senderId) {
            topText = "\(kid.name) 부모님"
            bottomText = "\(chatroomName)"
        } else {
            topText = "\(senderName) 선생님"
            bottomText = "\(chatroomName) ･ \(isPlugOn ? "플러그 온" : "플러그 오프")"
        }
        
        let titleParameters = [NSAttributedString.Key.foregroundColor : UIColor.darkGrey,
                               NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)]
        let subtitleParameters = [NSAttributedString.Key.foregroundColor : UIColor.grey,
                                  NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12, weight: .regular)]
        
        let title:NSMutableAttributedString = NSMutableAttributedString(string: topText, attributes: titleParameters)
        let subtitle:NSAttributedString = NSAttributedString(string: bottomText, attributes: subtitleParameters)
        
        title.append(NSAttributedString(string: "\n"))
        title.append(subtitle)
        
        let size = title.size()
        let width = size.width
        
        guard let height = navigationController?.navigationBar.frame.size.height else {return}
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        titleLabel.attributedText = title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        navigationItem.titleView = titleLabel
        
        if !isPlugOn {
            banner.isHidden = false
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.bannerYOffset.constant = 0
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    func addMessage(newMessage: MessageItem) {
        self.chatModel.addMessage(newMessage: newMessage)
        self.tableView.reloadData()
    }
    
    func setTableViewScrollBottom(animated: Bool = false) {
        if self.chatModel.mViewModel.count > 0 {
            self.tableView.scrollToRow(at: self.chatModel.lastIndexPath, at: .bottom, animated: animated)
        }
    }
}

extension ChatVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            guard !self.isLoading,
                !self.isEnd,
                let chatroomId = chatroom?.id,
                let receiverId = receiver?.userId,
                let senderid = sender?.userId ,
            self.messageData.count != 0 else { return }
            self.isLoading = true
            let lastId = self.messageData[0].id
            PlugIndicator.shared.play()
            Networking.getMeassages(chatroomId: chatroomId, userId: senderid, receiverId: receiverId, before: lastId) { (messages) in
                PlugIndicator.shared.stop()
                if messages.count == 0 {
                    self.isEnd = true
                }
                self.messageData = messages + self.messageData
                self.title = "\(messages.count) 개 수신"
                let lastIndexPath = self.chatModel.addItemsFront(messages: messages.map({ MessageItem(with: $0, isMine: receiverId == $0.sender.userId)
                }))
                self.tableView.reloadData()
                self.tableView.scrollToRow(at: lastIndexPath, at: .top, animated: false)
                self.isLoading = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch chatModel.getType(of: indexPath) {
        case .BLANK:
            return 4
        case .LCELL, .RCELL:
            return UITableView.automaticDimension
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
    
    func setTimeStamp(date: Date) {
        let format = DateFormatter()
        format.dateFormat = "yyyy. MM. dd. (E)"
        format.locale = Locale(identifier: "ko_KR")
        timeLabel.text = format.string(from: date)
    }
}
