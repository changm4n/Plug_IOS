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

class ColdView: UIView {
    
    let titleLabel: UILabel = {
       let lb = UILabel()
        lb.text = "소속한 클래스가 없습니다"
        lb.font = UIFont.getBold(withSize: 20)
        lb.textColor = UIColor.charcoalGrey
        return lb
    }()
    
    let subtitleLabel: UILabel = {
       let lb = UILabel()
        lb.text = "클래스에 가입하거나 클래스를 만들어주세요"
        lb.font = UIFont.getRegular(withSize: 14)
        lb.textColor = UIColor.blueGrey
        return lb
    }()
    
    let joinButton: PlugButton = {
        let btn = PlugButton(theme: .WHITE, isShadow: true, enable: true)
        btn.setTitle("클래스 가입하기", for: .normal)
        btn.setTitleColor(UIColor.textBlue, for: .normal)
        btn.titleLabel?.font = UIFont.getBold(withSize: 16)
        return btn
    }()
    
    let createButton: PlugButton = {
        let btn = PlugButton(theme: .WHITE, isShadow: true, enable: true)
        btn.setTitle("클래스 만들기", for: .normal)
        btn.setTitleColor(UIColor.textBlue, for: .normal)
        btn.titleLabel?.font = UIFont.getBold(withSize: 16)
        return btn
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor.paleGrey2
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        self.addSubview(joinButton)
        self.addSubview(createButton)
        
        setLayout()
    }
    
    func setLayout() {
        titleLabel.snp.makeConstraints({
            $0.top.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(29)
        })
        
        subtitleLabel.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(3)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(20)
        })
        
        joinButton.snp.makeConstraints({
            $0.left.equalToSuperview().inset(24)
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(36)
            $0.width.equalTo(createButton.snp.width)
            $0.height.equalTo(56)
        })

        createButton.snp.makeConstraints({
            $0.right.equalToSuperview().inset(24)
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(36)
            $0.left.equalTo(joinButton.snp.right).offset(14)
            $0.height.equalTo(56)
        })
    }
}

class SearchView: UIView {
    
    private var shadowLayer: CAShapeLayer? = nil
    private var fillColor: CGColor = UIColor.white.cgColor
    private var disposebag = DisposeBag()
    
    let image: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "search"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let label: UILabel = {
        let lb = UILabel()
        lb.text = "학급 또는 이름 검색"
        lb.font = UIFont.getRegular(withSize: 16)
        lb.textColor = UIColor.filterGray
        return lb
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        shadowLayer?.fillColor = UIColor.white.cgColor
        fillColor = UIColor.white.cgColor
        self.addSubview(image)
        self.addSubview(label)
        
        setLayout()
    }
    
    func setLayout() {
        image.snp.makeConstraints({
            $0.width.height.equalTo(25)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
        })
        
        label.snp.makeConstraints({
            $0.leading.equalTo(image.snp.trailing).offset(12)
            $0.height.equalTo(21)
            $0.centerY.equalTo(image)
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard shadowLayer == nil else { return }
        
        shadowLayer = CAShapeLayer()
        shadowLayer?.path = UIBezierPath(roundedRect: bounds, cornerRadius: 8).cgPath
        shadowLayer?.fillColor = fillColor
        shadowLayer?.shadowColor = UIColor(r: 0/255.0, g: 0/255.0, b: 0/255.0, a: 0.08).cgColor
        let dx: CGFloat = 0
        let rect = bounds.insetBy(dx: dx, dy: dx)
        shadowLayer?.shadowPath = UIBezierPath(rect: rect).cgPath
        shadowLayer?.shadowOffset = CGSize(width: 0.0, height: 0.5)
        shadowLayer?.shadowOpacity = 1
        shadowLayer?.shadowRadius = 3
        
        layer.insertSublayer(shadowLayer!, at: 0)
    }
}

class ChatListVC: PlugViewController {
    
    var disposeBag = DisposeBag()
    
    let searchContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let searchTF: UIView = SearchView()
    let coldView = ColdView()
    
    let filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.register(UINib(nibName: "HomeHeaderCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return cv
    }()
    
    let selectedFilter: BehaviorRelay<String> = BehaviorRelay(value: "전체")
    let filteredList: BehaviorRelay<[MessageSummary]> = BehaviorRelay(value: [])
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var settingButton: UIBarButtonItem!
    @IBOutlet weak var writeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = .black
        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = 8 // This is added to the default margin
        self.navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.paragraphStyle : style,
             NSAttributedString.Key.font : UIFont.getBold(withSize: 24)   ]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.tableView.register(UINib(nibName: "HomeHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "HomeHeaderView")
        
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.tableFooterView = UIView()
        bindData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Session.me?.reload().subscribe().disposed(by: disposeBag)
    }
    
    override func setViews() {
        super.setViews()
        coldView.isHidden = true
        self.view.addSubview(coldView)
        
        coldView.snp.makeConstraints({
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(232)
        })
        
    }
    
    func isShowColdView(show: Bool) {
        coldView.isHidden = !show
    }
    
    func bindData() {
        guard let me = Session.me else { return }
        
        searchContainer.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] (_) in
            let vc = SearchVC()
            vc.modalPresentationStyle = .fullScreen
            vc.parentVC = self
            self?.present(vc, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
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
        
        writeButton.rx.tap.subscribe(onNext: { [weak self] in
            let vc = MultiSendVC()
            self?.navigationController?.pushViewController(vc, animated: true)
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
        
        //cold view bind
        me.allClass.map({ $0.count != 0 }).bind(to: coldView.rx.isHidden).disposed(by: disposeBag)
        
        coldView.joinButton.rx.tap.subscribe(onNext: { (_) in
            let vc = JoinClassVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
        coldView.createButton.rx.tap.subscribe(onNext: { (_) in
            let vc = CreateClassVC()
            self.navigationController?.pushViewController(vc, animated: true)
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
        return count >= 2 ? 120 : 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HomeHeaderView")
        let header = view as! HomeHeaderView
        header.addSubview(filterCollectionView)
        header.addSubview(searchContainer)
        searchContainer.addSubview(searchTF)
        
        searchContainer.snp.makeConstraints({
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(70)
        })
        
        searchTF.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(48)
        })
        
        filterCollectionView.snp.makeConstraints({
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(50)
        })
        return header
    }
}
