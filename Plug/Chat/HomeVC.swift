//
//  HomeVC.swift
//  Plug
//
//  Created by changmin lee on 29/10/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit
import Kingfisher
import Lottie

class HomeVC: PlugViewController {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var coldView: UIView!
    @IBOutlet weak var topView: UIView!
    
    var filterCollectionView: UICollectionView?
    
    var selectedFilter = 0
    var messageCount = 0
    
    let kLabelY: CGFloat = 21
    let maxOffset: CGFloat = 21
    
    var classData: [ChatRoomApolloFragment] = []
    var summaryData: [MessageSummary] = []
    var filteredList: [MessageSummary] {
        if selectedFilter == 0 {
            return summaryData
        } else {
            return summaryData.filter({ $0.chatroom.name == classData[selectedFilter - 1].name })
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.register(UINib(nibName: "HomeHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HomeHeaderView")
        
        Networking.subscribeMessage { (message) in
            if let newMessage = message.node?.fragments.messageApolloFragment {
                guard  newMessage.receivers?.first?.userId == Session.me?.userId else {
                        return
                }
                self.setData()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kMessageReceived), object: nil, userInfo: ["message" : newMessage])
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
        self.statusbarLight = true
        setData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "newMessage"), object: nil)
    }
   
    @IBAction func searchButtonPressed(_ sender: Any) {
        showAlertWithString("알림", message: "검색 기능은 개발 중 입니다.", sender: self)
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "share", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "chat" {
            
            FBLogger.shared.log(id: "chatMain_userListItem")
            let vc = segue.destination as! ChatVC
            let data = sender as! MessageSummary
            vc.receiver = data.receiver
            vc.sender = data.sender
            vc.chatroom = data.chatroom
        } else if segue.identifier == "share" {
            
            FBLogger.shared.log(id: "chatMain_invitIntro_to")
            let nvc = segue.destination as! UINavigationController
            let vc = nvc.viewControllers[0] as! WebVC
            vc.urlStr = kUserTip
            vc.title = "초대 방법"
        }
    }
}
extension HomeVC {
    
    func setData() {
        
        guard let me = Session.me else { return }
        me.refreshRoom(completion: { (classData) in
            self.classData = me.classData
            Session.me?.refreshSummary(completion: { (summary) in
                self.summaryData = summary
                self.setTableViewData()
                self.setUI()
            })
            self.filterCollectionView?.reloadData()
        })
    }
    
    func setTableViewData() {
        
        guard let me = Session.me else { return }
        self.messageCount = summaryData.filter({ $0.unreadCount > 0 }).count
        if me.role == .TEACHER {
            
            for c in classData {
                for user in c.users ?? [] {
                    if user.fragments.userApolloFragment.userId == me.userId {
                        continue
                    }
                    
                    if summaryData.filter({$0.sender.name == user.fragments.userApolloFragment.name}).count == 0 {
                        summaryData.append(MessageSummary(with: user.fragments.userApolloFragment, classData: c, myType: .TEACHER))
                    }
                }
            }
        } else {
            
            for c in classData {
                if summaryData.filter({$0.chatroom.name == c.name}).count == 0 {
                    let admin = c.admins!.first!.fragments.userApolloFragment
                    summaryData.append(MessageSummary(with: admin, classData: c, myType: .PARENT))
                }
            }
        }
        self.tableView.reloadData()
        self.tableView.isScrollEnabled = summaryData.count > 1
    }
    
    func setUI() {
        
        guard let me = Session.me else { return }
        guard let name = me.name else { return }
        
        coldView.isHidden = true
        if me.role == .TEACHER {
            if classData.filter({$0.kids?.count ?? 0 > 0}).count == 0 {
                
                let attributedString = classData.count > 0 ? NSMutableAttributedString(string: "\(name) 선생님, \n\(classData[0].name) 클래스 학부모님들의\n가입을 기다리고있습니다.", attributes: [
                    .font: UIFont.systemFont(ofSize: 22.0, weight: .regular),
                    .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
                    .kern: 0.0
                    ]) :
                    NSMutableAttributedString(string: "\(name) 선생님, \n클래스를 생성해주세요.", attributes: [
                        .font: UIFont.systemFont(ofSize: 22.0, weight: .regular),
                        .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
                        .kern: 0.0
                        ])
                coldView.isHidden = classData.count == 0
                codeLabel.text = classData.count > 0 ? classData[0].inviteCode : ""
                mainLabel.attributedText = attributedString
                topView.backgroundColor = .plugBlue2
                
                updateTitleViewHeight(height: 135)
            } else {
                
                let attributedString = NSMutableAttributedString(string: "\(name) 선생님, \n", attributes: [
                    .font: UIFont.systemFont(ofSize: 22.0, weight: .regular),
                    .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
                    .kern: 0.0
                    ])
                
                let attributedString1 = NSMutableAttributedString(string: "\(messageCount)명", attributes: [
                    .font: UIFont.systemFont(ofSize: 22.0, weight: .bold),
                    .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
                    .kern: 0.0
                    ])
                
                let attributedString2 = NSMutableAttributedString(string: "이 메시지를 보냈습니다.", attributes: [
                    .font: UIFont.systemFont(ofSize: 22.0, weight: .regular),
                    .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
                    .kern: 0.0
                    ])
                
                attributedString.append(attributedString1)
                attributedString.append(attributedString2)
                mainLabel.attributedText = messageCount > 0 ? attributedString : NSMutableAttributedString()
                self.topView.backgroundColor = self.messageCount > 0 ? .plugBlue2 : .white
                
                updateTitleViewHeight(height: messageCount > 0 ? 135 : 0)
            }
        } else {
            
            let sumOfunreadCount = summaryData.map({$0.unreadCount}).reduce(0){$0 + $1}
            let attributedString1 = NSMutableAttributedString(string: "\(name) 학부모님,\n", attributes: [
                .font: UIFont.systemFont(ofSize: 22.0, weight: .regular),
                .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
                .kern: 0.0
                ])
            let attributedString2 = NSMutableAttributedString(string: "\(sumOfunreadCount)개", attributes: [
                .font: UIFont.systemFont(ofSize: 22.0, weight: .bold),
                .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
                .kern: 0.0
                ])
            let attributedString3 = NSMutableAttributedString(string: "의 메시지를 받았습니다.", attributes: [
                .font: UIFont.systemFont(ofSize: 22.0, weight: .regular),
                .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
                .kern: 0.0
                ])
            let attr = NSMutableAttributedString()
            attr.append(attributedString1)
            attr.append(attributedString2)
            attr.append(attributedString3)
            
            mainLabel.attributedText = sumOfunreadCount == 0 ? NSMutableAttributedString() : attr
            self.topView.backgroundColor = sumOfunreadCount > 0 ? .plugBlue2 : .white
            
            updateTitleViewHeight(height: sumOfunreadCount > 0 ? 135 : 0)
        }
    }
    
    func updateTitleViewHeight(height: CGFloat) {
        self.titleView.frame.size = CGSize(width: SCREEN_WIDTH, height: height)
    }
    
}
extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let row = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeHeaderCell
        if row == 0 {
            cell.label.text = "    전체    "
        } else {
            cell.label.text = "    \(classData[row - 1].name)    "
        }
        
        cell.setSeleted(selected: selectedFilter == row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return classData.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedFilter = indexPath.row
        
        tableView.reloadData()
        collectionView.reloadData()
    }
}
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if Session.me?.role ?? .NONE == .TEACHER {
            return classData.count < 2 ? 0 : 60
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SummaryCell
        let summary = summaryData[indexPath.row]
        cell.configure(item: summary)
        if indexPath.row == summaryData.count - 1 {
            cell.addBottomLine()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.applicationIconBadgeNumber -= summaryData[indexPath.row].unreadCount
        performSegue(withIdentifier: "chat", sender: summaryData[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard Session.me?.role ?? .NONE == .TEACHER else { return nil }
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HomeHeaderView")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        
        let header = view as! HomeHeaderView
        
        if filterCollectionView == nil {
            filterCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 60), collectionViewLayout: layout)
            filterCollectionView?.backgroundColor = UIColor.white
            filterCollectionView?.register(UINib(nibName: "HomeHeaderCell", bundle: nil), forCellWithReuseIdentifier: "cell")
            
            filterCollectionView?.dataSource = self
            filterCollectionView?.delegate = self
            filterCollectionView?.showsHorizontalScrollIndicator = false
            filterCollectionView?.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            header.addSubview(filterCollectionView!)
        }
        
        return header
    }
}

extension HomeVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y / 3
        if offset < 0 {
            return
        }
        mainLabel.frame = CGRect(x: mainLabel.frame.origin.x, y: kLabelY - offset, width: mainLabel.frame.width, height: mainLabel.frame.height)
        mainLabel.alpha = 1 - offset / maxOffset
        
    }
}

class SummaryCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var newBadge: UIImageView!
    
    override func awakeFromNib() {
        profileImage.makeCircle()
    }

    func configure(item: MessageSummary) {
        
        let sender = item.sender
        let chatroom = item.chatroom
        
        nameLabel.text = item.displayName
        classLabel.text = chatroom.name
        
        if let url = sender.profileImageUrl, sender.profileImageUrl != "" {
            profileImage.kf.setImage(with: URL(string: url))
        }
        
        let messageItem = item.lastMessage
        messageLabel.text = messageItem.text
        timeLabel.text = messageItem.createAt.isToday() ? messageItem.timeStamp : messageItem.timeStampLong
        if messageItem.id == "default" {
            timeLabel.text = ""
        }
        
        newBadge.isHidden = item.unreadCount == 0
    }
}
