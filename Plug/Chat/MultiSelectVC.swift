//
//  MultiSelectVC.swift
//  Plug
//
//  Created by changmin lee on 2020/02/27.
//  Copyright © 2020 changmin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct KidItem: Equatable {
    static func == (lhs: KidItem, rhs: KidItem) -> Bool {
        lhs.kid.id == rhs.kid.id
    }
    
    var kid: KidApolloFragment
    var chatroom: ChatRoomApolloFragment
    
    var id: String {
        kid.id
    }
}

class MultiSendVC: PlugViewController {
    
    var seletedList: [KidItem] = []
    var disposeBag = DisposeBag()
    let viewModel = MultiSendViewModel()
    
    let sendButton = UIBarButtonItem(image: UIImage(named: "send"), style: .plain, target: self, action: nil)
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.register(UINib(nibName: "MultiSendCell", bundle: nil), forCellReuseIdentifier: "multi")
        tv.keyboardDismissMode = .onDrag
        return tv
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 100)
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .white
        cv.contentInset = UIEdgeInsets(top: 16, left: 4, bottom: 0, right: 4)
        cv.register(UINib(nibName: "MultiSelectedCell", bundle: nil), forCellWithReuseIdentifier: "multiselected")
        return cv
    }()
    
    let searchTF: PlugTextField = {
        let tf = PlugTextField(type: .none)
        tf.placeholder = "학급 또는 이름 검색"
        tf.titleColor = .textBlue
        tf.title = ""
        tf.lineHeight = 1
        tf.selectedLineColor = .plugBlue
        return tf
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    override func setBinding() {
        self.searchTF.rx.text.orEmpty.bind(to: viewModel.textinput).disposed(by: disposeBag)
        
        viewModel.outputList.bind(to: tableView.rx.items) { [unowned self] tableView, row, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "multi", for: IndexPath(row: row, section: 0)) as! MultiSendCell
            cell.configure(name: "\(item.kid.name) 부모님", desc: item.chatroom.name, urlString: item.kid.parents?.first?.fragments.userApolloFragment.profileImageUrl)
            
            let isSelected = self.viewModel.outputSelectedList.value.contains(item)
            cell.accessoryType = isSelected ? .checkmark : .none
            return cell
        }.disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(KidItem.self))
        .bind { [unowned self] indexPath, model in
            self.viewModel.selectKid(kid: model)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(KidItem.self).subscribe(onNext: { [weak self] (kid) in
            self?.viewModel.selectKid(kid: kid)
            self?.tableView.reloadSections([0], animationStyle: .automatic)
        }).disposed(by: disposeBag)
        
        viewModel.outputSelectedList.bind(to: collectionView.rx.items) { collectionView, row, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "multiselected", for: IndexPath(row: row, section: 0)) as! MultiSeletecCell
            cell.configure(kid: item)
            return cell
        }.disposed(by: disposeBag)
        
        viewModel.outputSelectedList.map({$0.count}).skip(1).subscribe(onNext: { [unowned self] (count) in
            self.collectionView.snp.updateConstraints({
                $0.height.equalTo(count == 0 ? 8 : 116)
            })
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            })
        }).disposed(by: disposeBag)
        
        sendButton.rx.tap.subscribe(onNext: { [unowned self] (_) in
            let vc = MultiMessageVC()
            vc.seletedKid = self.viewModel.outputSelectedList.value
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }
    
    override func setViews() {
        self.view.backgroundColor = .white
        setTitle(title: "단체 메세지")
        
        
        self.navigationItem.rightBarButtonItem = sendButton
        self.view.addSubview(searchTF)
        self.view.addSubview(collectionView)
        
        self.tableView.register(UINib(nibName: "MemberCell", bundle: nil), forCellReuseIdentifier: "member")
        self.tableView.tableFooterView = UIView()
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.view.addSubview(tableView)
        
        setLayout()
    }
    
    func setLayout() {
        searchTF.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50)
        })
        
        collectionView.snp.makeConstraints({
            $0.top.equalTo(searchTF.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(8)
        })
        
        tableView.snp.makeConstraints({
            $0.top.equalTo(collectionView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        })
    }
}

extension MultiSendVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}

class MultiSendViewModel {
    let disposeBag = DisposeBag()
    //input
    var textinput: PublishSubject<String> = PublishSubject()
    
    //output
    var outputList: BehaviorRelay<[KidItem]> = BehaviorRelay(value: [])
    var outputSelectedList: BehaviorRelay<[KidItem]> = BehaviorRelay(value: [])
    
    init() {
        guard let me = Session.me else { return }
        Observable.combineLatest(me.kids, textinput) { (kids, query) in
            return kids.filter({ kid in
                (kid.chatroom.name.contains(query) || kid.kid.name.contains(query) || query.isEmpty)
            }).map({ $0 })
        }.bind(to: outputList).disposed(by: disposeBag)
    }
    
    func selectKid(kid: KidItem) {
        var list = outputSelectedList.value
        if let index = list.firstIndex(of: kid) {
            list.remove(at: index)
        } else {
            list.insert(kid, at: 0)
        }
        outputSelectedList.accept(list)
    }
}
