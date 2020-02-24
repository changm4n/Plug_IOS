//
//  ClassListVC.swift
//  Plug
//
//  Created by changmin lee on 2020/02/22.
//  Copyright © 2020 changmin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ClassListVC: PlugViewController {
    
    typealias ClassSectionModel = SectionModel<String, ChatRoomApolloFragment>
    typealias ClassDataSource = RxTableViewSectionedReloadDataSourceWithReloadSignal<ClassSectionModel>
    
    var classDataSource: ClassDataSource!
    
    var disposeBag = DisposeBag()
    let tableView: UITableView = {
        let tv = UITableView()
        tv.register(UINib(nibName: "PlugClassCell", bundle: nil), forCellReuseIdentifier: "cell")
        return tv
    }()
    
    var viewModel: ClassListViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Session.me?.reloadChatRoom()
    }
    
    override func setViews() {
        setTitle(title: "내 클래스")
        self.tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    override func setBinding() {
        guard let me = Session.me else { return }
        viewModel = ClassListViewModel(me: me)
        let configureCell: (TableViewSectionedDataSource<ClassSectionModel>, UITableView, IndexPath, ChatRoomApolloFragment) -> UITableViewCell = { datasource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlugClassCell
            cell.selectionStyle = .none
            cell.configure(item: item, isAdmin: indexPath.section == 0)
            return cell
        }
        
        self.classDataSource = ClassDataSource.init(configureCell: configureCell)
        viewModel?.output.asDriver(onErrorJustReturn: []).drive(tableView.rx.items(dataSource: classDataSource)).disposed(by: disposeBag)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension ClassListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        let row = indexPath.row
        
        let vc = ClassDetailVC()
        vc.item = classDataSource[0].items[row]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header =  UINib(nibName: "ClassHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ClassHeader
        let item = self.classDataSource[section]
        header?.label.text = item.identity
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}

class ClassListViewModel {
    var disposeBag = DisposeBag()
    
    var output: BehaviorSubject<[SectionModel<String, ChatRoomApolloFragment>]> = BehaviorSubject(value: [])
    
    init(me: Session) {
        Observable.combineLatest(me.adminClass, me.memberClass).map {
            [SectionModel<String, ChatRoomApolloFragment>(model: "관리중인 클래스", items: $0.0),
             SectionModel<String, ChatRoomApolloFragment>(model: "가입한 클래스", items: $0.1)]
            }.bind(to: output).disposed(by: disposeBag)
    }
}
