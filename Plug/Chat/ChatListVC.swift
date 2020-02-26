//
//  ChatListVC.swift
//  Plug
//
//  Created by changmin lee on 14/10/2019.
//  Copyright © 2019 changmin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ChatListVC: PlugViewController {
    
    var disposeBag = DisposeBag()
    
    let filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 50), collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.register(UINib(nibName: "HomeHeaderCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        cv.showsHorizontalScrollIndicator = false
        cv.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return cv
    }()
    
    let selectedFilter: BehaviorRelay<String> = BehaviorRelay(value: "전체")
    let filteredList: BehaviorRelay<[MessageSummary]> = BehaviorRelay(value: [])
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var settingButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = 18 // This is added to the default margin
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.paragraphStyle : style]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.tableView.register(UINib(nibName: "HomeHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HomeHeaderView")
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.tableFooterView = UIView()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Session.me?.reloadChatRoom()
        Session.me?.refreshSummary()
    }
    
    func bindData() {
        guard let me = Session.me else { return }
        
        Observable.combineLatest(me.summaryData, selectedFilter)
            .map({
                let filter = $0.1
                return $0.0.filter({ ($0.chatroom.name == filter) || (filter == "전체")})
            }).bind(to: filteredList).disposed(by: disposeBag)
        
        
        self.filteredList.bind(to: self.tableView.rx.items) { tableView, row, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: IndexPath(row: row, section: 0)) as! ChatListCell
            
            cell.bind(item: item)
            return cell
            
        }.disposed(by: self.disposeBag)
        
        tableView.rx.modelSelected(MessageSummary.self).subscribe({ [weak self] item in
            guard let messageSummary = item.element else {
                return
            }
            self?.performSegue(withIdentifier: "chat", sender: messageSummary)
        }).disposed(by: self.disposeBag)
        
        settingButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.performSegue(withIdentifier: "setting", sender: nil)
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(me.adminClass, me.memberClass).map ({
            return ["전체"] + $0.0.map({ $0.name }) + $0.1.map({ $0.name })
        }).bind(to: self.filterCollectionView.rx.items) { [unowned self] collectionView, row, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: IndexPath(row: row, section: 0)) as! HomeHeaderCell
            if row == 0 {
                cell.label.text = "    전체    "
            } else {
                cell.label.text = "    \(item)    "
            }
            
            cell.setSeleted(selected: (item == self.selectedFilter.value))
            return cell
        }.disposed(by: disposeBag)
        
        filterCollectionView.rx.modelSelected(String.self)
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] (filter) in
                self.selectedFilter.accept(filter)
                self.filterCollectionView.reloadSections([0], animationStyle: .automatic)
            }).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chat" {
            guard let data = sender as? MessageSummary else { return }
            
            FBLogger.shared.log(id: "chatMain_userListItem")
            let vc = segue.destination as! ChatVC
            
            let sender = Identity(id: data.sender.userId, name: data.sender.name)
            let receiver = Identity(id: data.receiver.userId, name: data.receiver.name)
            let chatroom = Identity(id: data.chatroom.id, name: data.chatroom.name)
            
            let identity = ChatroomIdentity(sender: sender, receiver: receiver, chatroom: chatroom)
            
            vc.identity = identity
        }
    }
}

extension ChatListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let count = Session.me?.summaryData.value.count ?? 0
        return count >= 2 ? 50 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HomeHeaderView")
        let header = view as! HomeHeaderView
        header.addSubview(filterCollectionView)
        return header
    }
}
