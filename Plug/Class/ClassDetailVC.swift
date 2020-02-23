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
    
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let cellAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setViews() {
        setTitle(title: item.name)
        
        self.tableView.register(UINib(nibName: "DefaultCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.register(UINib(nibName: "MemberCell", bundle: nil), forCellReuseIdentifier: "member")
        
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(tableView)
        
        
        tableView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        let more = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(morePressed))
        self.navigationItem.rightBarButtonItem = more
        alertController.addAction(UIAlertAction(title: "클래스 편집", style: .default) { [unowned self] _ in
            
        })
        
        alertController.addAction(UIAlertAction(title: "클래스 삭제", style: .destructive) { [unowned self] _ in
            
        })
        
        alertController.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
        
        cellAlertController.addAction(UIAlertAction(title: "대화하기", style: .default) { [unowned self] _ in
            
        })
        
        cellAlertController.addAction(UIAlertAction(title: "구성원 제외", style: .destructive) { [unowned self] _ in
            
        })
        cellAlertController.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
    }
    
    @objc func morePressed() {
        self.present(alertController, animated: true, completion: nil)
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "member", for: indexPath) as! MemberCell
            let kidName = kids[row].fragments.kidApolloFragment.name
            let parent = kids[row].fragments.kidApolloFragment.parents?.first?.fragments.userApolloFragment
            cell.configure(name: "\(kidName) 부모님", urlString: parent?.profileImageUrl)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        if section == 0 {
            
        } else {
            self.present(cellAlertController, animated: true, completion: nil)
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
        if section == 1 {
            header?.subLabel.text = "\(kids.count)"
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 52 : 72
    }
}
