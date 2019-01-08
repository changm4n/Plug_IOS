//
//  HomeVC.swift
//  Plug
//
//  Created by changmin lee on 29/10/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit
import Kingfisher

class HomeVC: PlugViewController {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedFilter = -1
    
    var filterCollectionView: UICollectionView?
    
    var messageCount = 0
    
    let kLabelY: CGFloat = 85
    let maxOffset: CGFloat = 21
    
    var classData: [ChatRoomApolloFragment] = []
    var summaryData: [MessageSummaryApolloFragment] = []
    
    var filteredSet: Set<String> = Set<String>()
    var filteredList: [MessageSummaryApolloFragment] {
        let list = summaryData.filter({ filteredSet.contains($0.chatRoom.fragments.chatRoomSummaryApolloFragment.name) })
        return filteredSet.count == 0 ? summaryData : list
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "HomeHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HomeHeaderView")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
        self.statusbarLight = true
        setData()
    }
    
    func setData() {
        guard let userId = Session.me?.userId else { return }
        
        Networking.getMyClasses { (classData) in
            Session.me?.classData = classData
            self.classData = classData
            self.filterCollectionView?.reloadData()
        }
        
        Networking.getMessageSummary(userID: userId, start: 10, end: nil) { (summaries) in
            self.summaryData = summaries
            self.messageCount = summaries.count
            self.tableView.reloadData()
            self.setUI()
        }
    }
    
    func setUI() {
        guard let name = Session.me?.name else { return }
        
        let attributedString = NSMutableAttributedString(string: "\(name) 선생님, \n플러그 오프 시간에 \(messageCount)명이\n메시지를 보냈습니다.", attributes: [
            .font: UIFont.systemFont(ofSize: 22.0, weight: .regular),
            .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
            .kern: 0.0
            ])
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 22.0, weight: .bold), range: NSRange(location: 10, length: 6))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 22.0, weight: .bold), range: NSRange(location: 21, length: 2))
        mainLabel.attributedText = attributedString
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        Session.removeSavedUser()
        self.performSegue(withIdentifier: "out", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chat" {
            let vc = segue.destination as! ChatVC
            let data = sender as! MessageSummaryApolloFragment
            vc.receiver = data.receiver.fragments.userApolloFragment
            vc.sender = data.sender.fragments.userApolloFragment
            vc.chatroom = data.chatRoom.fragments.chatRoomSummaryApolloFragment
        }
    }
}
extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeHeaderCell
        cell.label.text = "    \(classData[indexPath.row].name)    "
        cell.setSeleted(selected: filteredSet.contains(classData[row].name))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return classData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        
        if filteredSet.contains(classData[row].name) {
            filteredSet.remove(classData[row].name)
        } else {
            filteredSet.insert(classData[row].name)
        }
        tableView.reloadData()
        collectionView.reloadData()
    }
}
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
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

    func configure(item: MessageSummaryApolloFragment) {
        let sender = item.sender.fragments.userApolloFragment
        nameLabel.text = sender.name
        newBadge.isHidden = item.unReadMessageCount != 0
        messageLabel.text = item.lastMessage?.fragments.messageApolloFragment.text
        classLabel.text = item.chatRoom.fragments.chatRoomSummaryApolloFragment.name
        if let url = sender.profileImageUrl, sender.profileImageUrl != ""{
            profileImage.kf.setImage(with: URL(string: url))
        }
    }
}
