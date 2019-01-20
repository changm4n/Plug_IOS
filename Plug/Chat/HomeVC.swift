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
    
    var filterCollectionView: UICollectionView?
    
    var selectedFilter = 0
    var messageCount = 0
    
    let kLabelY: CGFloat = 85
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
        titleView.frame.size = CGSize(width: SCREEN_WIDTH, height: Session.me?.role ?? .NONE == .TEACHER ? 135 : 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
        self.statusbarLight = true
        setData()
    }
    
    func setData() {
        guard let me = Session.me,
            let userId = Session.me?.userId else { return }
        self.classData = me.classData
        self.filterCollectionView?.reloadData()
        self.messageCount = summaryData.filter({ $0.unreadCount > 0 }).count
        self.tableView.reloadData()
        self.setUI()
    }
    
    func setUI() {
        guard let me = Session.me else { return }
        guard let name = me.name, me.role == .TEACHER else { return }
        
        let attributedString = NSMutableAttributedString(string: "\(name) 선생님, \n플러그 오프 시간에 \(messageCount)명이\n메시지를 보냈습니다.", attributes: [
            .font: UIFont.systemFont(ofSize: 22.0, weight: .regular),
            .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
            .kern: 0.0
            ])
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 22.0, weight: .bold), range: NSRange(location: name.count + 7, length: 6))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 22.0, weight: .bold), range: NSRange(location: 21, length: 2))
        mainLabel.attributedText = attributedString
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        let animationView = LOTAnimationView(name: "indicator")
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        animationView.center = view.center
        animationView.loopAnimation = true
        self.view.addSubview(animationView)
        animationView.play()
//        Session.removeSavedUser()
//        self.performSegue(withIdentifier: "out", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chat" {
            let vc = segue.destination as! ChatVC
            let data = sender as! MessageSummary
            vc.receiver = data.receiver
            vc.sender = data.sender
            vc.chatroom = data.chatroom
        }
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
        return Session.me?.role ?? .NONE == .TEACHER ? 60 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SummaryCell
        let summary = summaryData[indexPath.row]
        cell.configure(item: summary)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        
        nameLabel.text = item.kidName
        classLabel.text = chatroom.name
        
        if let url = sender.profileImageUrl, sender.profileImageUrl != ""{
            profileImage.kf.setImage(with: URL(string: url))
        }
        
        let messageItem = item.lastMessage
        messageLabel.text = messageItem.text
        timeLabel.text = messageItem.createAt.isToday() ? messageItem.timeStamp : messageItem.timeStampLong
        
        newBadge.isHidden = item.unreadCount == 0
    }
}
