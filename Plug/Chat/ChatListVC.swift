//
//  ChatListVC.swift
//  Plug
//
//  Created by changmin lee on 14/10/2019.
//  Copyright © 2019 changmin. All rights reserved.
//

import UIKit

class ChatListVC: PlugViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var filterCollectionView: UICollectionView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = 18 // This is added to the default margin
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.paragraphStyle : style]
        
        self.tableView.register(UINib(nibName: "HomeHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HomeHeaderView")
//        navigationItem.searchController = UISearchController(searchResultsController: nil)
    }
}

extension ChatListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatListCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HomeHeaderView")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        
        let header = view as! HomeHeaderView
        
        if filterCollectionView == nil {
            filterCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 58), collectionViewLayout: layout)
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

extension ChatListVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeHeaderCell
        if row == 0 {
            cell.label.text = "    전체    "
        } else {
            cell.label.text = "    학교    "
        }
        
        cell.setSeleted(selected: indexPath.row == 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tableView.reloadData()
        collectionView.reloadData()
    }
}
