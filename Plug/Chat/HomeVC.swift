//
//  HomeVC.swift
//  Plug
//
//  Created by changmin lee on 29/10/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit

class HomeVC: PlugViewController {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let kLabelY: CGFloat = 85
    let maxOffset: CGFloat = 21
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributedString = NSMutableAttributedString(string: "박태준 선생님, \n플러그 오프 시간에 4명이\n메시지를 보냈습니다.", attributes: [
            .font: UIFont.systemFont(ofSize: 22.0, weight: .regular),
            .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
            .kern: 0.0
            ])
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 22.0, weight: .bold), range: NSRange(location: 10, length: 6))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 22.0, weight: .bold), range: NSRange(location: 21, length: 2))
        mainLabel.attributedText = attributedString
        
        tableView.register(UINib(nibName: "HomeHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HomeHeaderView")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
        self.statusbarLight = true
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HomeHeaderView")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        let filterView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 60), collectionViewLayout: layout)
        filterView.backgroundColor = UIColor.white
        filterView.register(UINib(nibName: "HomeHeaderCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        filterView.dataSource = self
        filterView.delegate = self
        filterView.showsHorizontalScrollIndicator = false
        
        let header = view as! HomeHeaderView
        header.addSubview(filterView)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeHeaderCell
        cell.label.text = "전체"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
}

extension HomeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y / 3
        mainLabel.frame = CGRect(x: mainLabel.frame.origin.x, y: kLabelY - offset, width: mainLabel.frame.width, height: mainLabel.frame.height)
        mainLabel.alpha = 1 - offset / maxOffset
        
    }
}
