//
//  NoteMainVC.swift
//  Plug
//
//  Created by changmin lee on 17/11/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit

class NoteMainVC: PlugViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var arr: [Note] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        arr.append(Note(title: "titel", cname: "cname", tname: "tname", type: .plain))
        arr.append(Note(title: "titel", cname: "cname", tname: "tname", type: .attatch))
        arr.append(Note(title: "titel", cname: "cname", tname: "tname", type: .plain))
        arr.append(Note(title: "titel", cname: "cname", tname: "tname", type: .attatch))
        arr.append(Note(title: "titel", cname: "cname", tname: "tname", type: .plain))
        arr.append(Note(title: "titel", cname: "cname", tname: "tname", type: .attatch))
//        arr.append(Note(title: "titel", cname: "cname", tname: "tname", type: .attatch))
//        arr.append(Note(title: "titel", cname: "cname", tname: "tname", type: .image))
        
        tableView.register(UINib(nibName: "HomeHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HomeHeaderView")
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}

extension NoteMainVC: UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = arr[indexPath.row].type
        if type == .plain {
            let cell = tableView.dequeueReusableCell(withIdentifier: type.rawValue, for: indexPath) as! NotePlainCell
            cell.contentTextView.text = """
            1. 다음주 월요일에 수학 2,3단원 오답노트 해서내기
            2. 다음주 월요일 4교시 단축수업
            3. 사전생활지도 종이에 부모님 싸인 받기
            4. 재환이 타코 먹기
            """
            return cell
        } else if type == .attatch {
            let cell = tableView.dequeueReusableCell(withIdentifier: type.rawValue, for: indexPath) as! NotePlainCell
            cell.contentTextView.text = """
            1. 다음주 월요일에 수학 2,3단원 오답노트 해서내기
            """
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: type.rawValue, for: indexPath)
            return cell
        }
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



