//
//  ChatVC.swift
//  Plug
//
//  Created by changmin lee on 05/12/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit
import RealmSwift
import RxRealm
import RxCocoa
import RxSwift
import RxDataSources

class ChatVC: PlugViewControllerWithButton, UITextViewDelegate {
    
    @IBOutlet weak var textFieldBottomLayout: NSLayoutConstraint!
    @IBOutlet weak var inputViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bannerYOffset: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomInset: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var inputField: UIView!
    @IBOutlet weak var banner: UILabel!
    
    var disposeBag = DisposeBag()
    var viewModel: ChatroomViewModel!
    
    var isLoading: Bool = false
    var isEnd: Bool = false
    var isPlugOn: Bool = true {
        didSet {
            setTitle()
        }
    }
    
    var identity: ChatroomIdentity!
    
    var sender: Identity {
        identity.sender
    }
    
    var receiver: Identity {
        identity.receiver
    }
    
    var chatroom: Identity {
        identity.chatroom
    }
    
    var chatroomHashKey: Int {
        identity.hashKey
    }
    
    var role: SessionRole!
    var kOriginHeight: CGFloat = 0
    var kSafeAreaInset: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setKeyboardHide()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        kOriginHeight = self.view.frame.size.height
        
        if #available(iOS 11.0, *) {
            kSafeAreaInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        }
        
        sendButton.makeCircle()
        
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = UITableView.automaticDimension
//        textView.layer.cornerRadius = 18
//        textView.layer.borderWidth = 1
//        textView.layer.borderColor = UIColor(r: 215, g: 215, b: 215).cgColor
        textView.contentInset = UIEdgeInsets.zero
        
        textView.textContainerInset.left = 8
        textView.textContainerInset.right = 8
        setVM()
        setData()
        setUI()
        setTitle()
    }
    
    typealias ChatSectionModel = SectionModel<String, MessageViewItem>
    typealias ChatDataSource = RxTableViewSectionedReloadDataSourceWithReloadSignal<ChatSectionModel>
    
    var chatDataSource: ChatDataSource!
    
    func setVM() {
        let configureCell: (TableViewSectionedDataSource<ChatSectionModel>, UITableView, IndexPath, MessageViewItem) -> UITableViewCell = { datasource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: item.messageType.rawValue, for: indexPath) as! Configurable
            cell.configure(item: item)
            return cell
        }
        
        self.chatDataSource = ChatDataSource.init(configureCell: configureCell)
        self.viewModel = ChatroomViewModel(identity: identity)
        viewModel.output.asDriver(onErrorJustReturn: []).drive(tableView.rx.items(dataSource: chatDataSource)).disposed(by: disposeBag)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        sendButton.rx.tap.withLatestFrom(textView.rx.text.orEmpty)
            .filter({ $0 != nil && $0?.isEmpty == false })
            .subscribe(onNext: { [unowned self] (text) in
                
                if self.isPlugOn {
                    FBLogger.shared.log(id: "chatEach_sendBtn")
                    let message = MessageItem(text: text, chatroom: self.chatroom.id, receiver: self.sender.id)
                    self.viewModel.sendMessage(message: message)
                    self.resetTextView()
                } else {
                    showAlertWithSelect("플러그 오프 안내", message: "선생님의 근무시간이 아닙니다.\n메시지를 확인하지 못할 수도 있습니다. ", sender: self, handler: { [unowned self] (action) in
                        FBLogger.shared.log(id: "chatEach_PlugOffAlert_sendBtn")
                        let message = MessageItem(text: text, chatroom: self.chatroom.id, receiver: self.sender.id)
                                       self.viewModel.sendMessage(message: message)
                                       self.resetTextView()
                    }, canceltype: .destructive) { (action) in
                        FBLogger.shared.log(id: "chatEach_PlugOffAlert_cancelBtn")
                    }
                }
            }).disposed(by: disposeBag)
        
        viewModel.output.subscribe(onNext: { (arr) in
            if let indexPath = self.viewModel.getTopIndexPath() {
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            } else {
                self.tableView.scrollToBottom(animated: false)
            }
        }).disposed(by: disposeBag)
        
        if role == SessionRole.PARENT {
            ChatroomAPI.getOffice(userId: sender.id).subscribe(onSuccess: { [unowned self] (crontab) in
                if let crontab = crontab {
                    let schedule = Schedule(schedule: crontab)
                    if !schedule.isPlugOn() {
                        self.isPlugOn = false
                    }
                }
            }).disposed(by: disposeBag)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNaviBarAttr()
        super.viewWillAppear(animated)
        readMessage()
        
        let hash = "\(sender.id)_\(chatroom.id)"
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
            self.navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor.clear
        }
        
        super.willMove(toParent: parent)
    }
    
    private func setNaviBarAttr() {
        self.navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor.paleGrey2
    }
    
    @IBAction func addSampleMessage(_ userinfo: Any) {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard
            text.count > 0 else { return }
        
        if isPlugOn {
            FBLogger.shared.log(id: "chatEach_sendBtn")
            self.resetTextView()
            self.sendMessage(text: text)
        } else {
            
            showAlertWithSelect("플러그 오프 안내", message: "선생님의 근무시간이 아닙니다.\n메시지를 확인하지 못할 수도 있습니다. ", sender: self, handler: { [unowned self] (action) in
                FBLogger.shared.log(id: "chatEach_PlugOffAlert_sendBtn")
                self.resetTextView()
                self.sendMessage(text: text)
            }, canceltype: .destructive) { (action) in
                FBLogger.shared.log(id: "chatEach_PlugOffAlert_cancelBtn")
            }
        }
    }
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        isKeyboardShow = true
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            let bottomOffset = keyboardHeight - kSafeAreaInset
            
            if self.view.frame.origin.y == 0  {
                self.view.frame.origin.y -= bottomOffset
                self.tableView.contentInset = UIEdgeInsets(top: bottomOffset, left: 0, bottom: 0, right: 0)
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
            let keyboardHeight = keyboardSize.height
            self.view.frame.origin.y = -keyboardHeight
            self.tableView.contentInset = UIEdgeInsets(top: keyboardHeight, left: 0, bottom: 0, right: 0)
            self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
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
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.enterBackgound), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.receiveMessage(_:)), name: NSNotification.Name(rawValue: kMessageReceived), object: nil)
        
        viewModel.load()
    }
    
    func sendMessage(text: String) {
//        Networking.sendMessage(text: text, chatRoomId: chatroom.id, receiverId: sender.id) { (newMessage) in
//            guard let newMessage = newMessage else { return }
//            self.addMessage(newMessage: MessageItem(with: newMessage, isMine: true))
////            self.saveMessage(messages: [ChatLog(newMessage)])
//            self.tableView.reloadData()
//        }
    }
    
    @objc func receiveMessage(_ notification: NSNotification) {
        if let newMessage = notification.userInfo?["message"] as? MessageApolloFragment {
            guard  newMessage.receivers?.first?.userId == receiver.id &&
                newMessage.sender.userId == sender.id &&
                newMessage.chatRoom.id == chatroom.id else {
                    return
            }
            let item = MessageItem(with: newMessage, isMine: receiver.id == newMessage.sender.userId)
            self.viewModel.addMessage(message: item)
            self.readMessage()
        }
    }
   
    @objc func enterForeground() {
        viewModel.load()
    }
    
    @objc func enterBackgound() {
//        readMessage()
        saveTextViewText()
    }
    
    func readMessage() {
        Session.me?.readChat(chatRoomId: chatroom.id, senderId: sender.id)
        MessageAPI.readMessage(identity: identity).subscribe().disposed(by: disposeBag)
    }
    
    func saveTextViewText() {
        let hash = "\(sender.id)_\(chatroom.id)"
        setUserDefaultWithString(textView.text, forKey: hash)
    }
    
    func setTitle() {
        super.setTitle(title: sender.name, subtitle: chatroom.name)
        
        if !isPlugOn {
            banner.isHidden = false
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.bannerYOffset.constant = 0
                self?.view.layoutIfNeeded()
            }
        }
    }
}

extension ChatVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
//            self.viewModel.loadPrev()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset < -10 {
            self.viewModel.loadPrev()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.chatDataSource[indexPath]
        switch item.messageType {
        case .BLANK:
            return 4
        case .LCELL, .RCELL:
            return UITableView.automaticDimension
        case .STAMP:
            return 30
        }
    }
}
