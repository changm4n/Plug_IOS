//
//  ClassDetailVC.swift
//  Plug
//
//  Created by changmin lee on 2020/02/22.
//  Copyright © 2020 changmin. All rights reserved.
//

import UIKit

class ClassDetailVC: PlugViewController {
    
    var item: ChatRoomApolloFragment!
    var kids: [ChatRoomApolloFragment.Kid]  {
        return item.kids ?? []
    }
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        return tv
    }()
    
    let headers = ["클래스 초대", "클래스 구성원"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setViews() {
        setTitle(title: item.name)
        
        self.tableView.register(UINib(nibName: "DefaultCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
}

extension ClassDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : kids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DefaultCell
            cell.hideSeparator(hide: true)
            if row == 0 {
                cell.titleLabel.text = "초대 코드"
                cell.setContentText(text: item.inviteCode)
            } else {
                cell.titleLabel.text = "초대방법 자세히 보기"
            }
            return cell
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = kids[row].fragments.kidApolloFragment.name
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header =  UINib(nibName: "ClassHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ClassHeader
        header?.label.text = headers[section]
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 52 : 72
    }
}
