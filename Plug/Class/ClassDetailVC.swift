//
//  ClassDetailVC.swift
//  Plug
//
//  Created by changmin lee on 2020/02/22.
//  Copyright © 2020 changmin. All rights reserved.
//

import UIKit
import RxSwift

class ClassDetailVC: PlugViewController {
    
    let disposeBag = DisposeBag()
    
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
            let vc = EditClassVC()
            vc.item = self.item
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        alertController.addAction(UIAlertAction(title: "클래스 삭제", style: .destructive) { [unowned self] _ in
            self.deleteChatroom()
        })
        
        alertController.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
    }
    
    @objc func morePressed() {
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteChatroom() {
        showAlertWithSelect("", message: "\(item.name) 클래스를 삭제하시겠어요?\n소속된 모든 학부모님들이 클래스를\n나가게 됩니다.", sender: self, handler: { (_) in
            ChatroomAPI.deleteChatroom(id: self.item.id)
                .subscribe(onSuccess: { [unowned self]  (id) in
                self.navigationController?.popViewController(animated: true)
            }, onError: { [unowned self] (error) in
                var message: String? = nil
                switch error {
                case let ApolloError.gqlErrors(errors):
                    message = errors.first?.message
                default:
                    message = nil
                }
                showAlertWithString("오류", message: message ?? "클래스 삭제 중 오류가 발생하였습니다.", sender: self)
            }).disposed(by: self.disposeBag)
        }, confirmtype: .destructive)
    }
    
    func startChat(row: Int) {
        guard let sender = kids[row].fragments.kidApolloFragment.parent,
            let userId = Session.me?.userId,
            let name = Session.me?.name.value else {
            return
        }
        
        let senderI = Identity(id: sender.userId, name: "\(kids[row].fragments.kidApolloFragment.name) 부모님")
        let receiverI = Identity(id: userId, name: name)
        let chatroom = Identity(id: self.item.id, name: self.item.name)
        
        let identity = ChatroomIdentity(sender: senderI, receiver: receiverI, chatroom: chatroom)
        
        let storyboard = UIStoryboard(name: "Chat", bundle: nil)

        let vc = storyboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.identity = identity
        vc.role = .TEACHER
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func withdrawKid(row: Int) {
        let kid = kids[row].fragments.kidApolloFragment
        guard let parentID = kid.parentUserID else {
            return
        }
        
        showAlertWithSelect("", message: "\(kid.name) 회원을 구성원에서 제외합니다.", sender: self, handler: { [unowned self] (_) in
            ChatroomAPI.withdrawKid(id: self.item.id, userId: parentID, kidName: kid.name)
                .subscribe(onSuccess: { [unowned self]  (id) in
                    self.item.kids?.remove(at: row)
                    self.tableView.reloadData()
            }, onError: { [unowned self] (error) in
                var message: String? = nil
                switch error {
                case let ApolloError.gqlErrors(errors):
                    message = errors.first?.message
                default:
                    message = nil
                }
                showAlertWithString("오류", message: message ?? "구성원 제외 중 오류가 발생하였습니다.", sender: self)
            }).disposed(by: self.disposeBag)
        }, confirmtype: .destructive)
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
            let kid = kids[row].fragments.kidApolloFragment
            cell.configure(name: "\(kid.name) 부모님", urlString: kid.profileURL)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            if row == 0 {
                
            } else {
                let vc = DescViewController()
                vc.type = .usage
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            self.selectMember(row: indexPath.row)
        }
    }
    
    //TODO : Rx
    func selectMember(row: Int) {
        let cellAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        cellAlertController.addAction(UIAlertAction(title: "대화하기", style: .default) { [unowned self] _ in
            self.startChat(row: row)
        })
        
        cellAlertController.addAction(UIAlertAction(title: "구성원 제외", style: .destructive) { [unowned self] _ in
            self.withdrawKid(row: row)
        })
        
        cellAlertController.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
        self.present(cellAlertController, animated: true, completion: nil)
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
