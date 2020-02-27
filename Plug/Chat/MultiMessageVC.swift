//
//  MultiMessageVC.swift
//  Plug
//
//  Created by changmin lee on 2020/02/28.
//  Copyright © 2020 changmin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MultiMessageVC: PlugViewControllerWithButton {
    
    var kSafeAreaInset: CGFloat = 0
    
    var disposeBag = DisposeBag()
    var viewModel: MultiMessageViewModel!
    var seletedKid: [KidItem] = []
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = UIColor.paleGrey2
        tv.register(UINib(nibName: "MultiSendCell", bundle: nil), forCellReuseIdentifier: "multi")
//        tv.keyboardDismissMode = .onDrag
        return tv
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 100)
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.paleGrey2
        cv.contentInset = UIEdgeInsets(top: 16, left: 4, bottom: 0, right: 4)
        cv.register(UINib(nibName: "MultiSelectedCell", bundle: nil), forCellWithReuseIdentifier: "multiselected")
        return cv
    }()
    
    let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .blue
        return v
    }()
    
    let messageTF: PlugTextField = {
        let tf = PlugTextField(type: .none)
        tf.title = ""
        tf.lineHeight = 0
        return tf
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        
        kSafeAreaInset = UIApplication.shared.windows[0].safeAreaInsets.bottom
        
    }
    
    override func setBinding() {
        self.viewModel = MultiMessageViewModel(selectedList: self.seletedKid)
        
        self.messageTF.rx.text.orEmpty.bind(to: viewModel.textinput).disposed(by: disposeBag)
        Observable.of(self.viewModel.selectedList).bind(to: self.collectionView.rx.items) {
            collectionView, row, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "multiselected", for: IndexPath(row: row, section: 0)) as! MultiSeletecCell
            cell.configure(kid: item)
            cell.clearImageView.isHidden = true
            cell.backgroundColor = .clear
            return cell
        }.disposed(by: disposeBag)
        
        Observable.just([1,2,3,4,5,6,7,8,9,1,2,3,4,5]).bind(to: self.tableView.rx.items) {
            tableView, row, item in
            let cell = UITableViewCell()
            cell.textLabel?.text = "\(item)"
            return cell
        }.disposed(by: disposeBag)
    }
    
    override func setViews() {
        self.view.backgroundColor = UIColor.white
            
        setTitle(title: "단체 메세지")
        
        self.view.addSubview(containerView)
        self.view.addSubview(collectionView)
        self.view.addSubview(tableView)
        
        self.containerView.addSubview(messageTF)
        setLayout()
    }
    
    func setLayout() {
        containerView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
//            $0.bottom.equalToSuperview()
            $0.height.equalTo(52)
        })
        
        collectionView.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(116)
        })
        
        tableView.snp.makeConstraints({
            $0.top.equalTo(collectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(containerView.snp.top)
        })
        
        messageTF.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(4)
        })
    }
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            containerView.snp.remakeConstraints({
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview().inset(keyboardHeight)
                $0.height.equalTo(52)
            })
            UIView.animate(withDuration: 1, animations: { [weak self] in
                           self?.view.layoutIfNeeded()
            })
//            var origin = self.tableView.contentOffset
//            origin.y += (keyboardHeight - kSafeAreaInset)
//            self.tableView.setContentOffset(origin, animated: true)
//            self.tableView.scrollIndicatorInsets = self.tableView.contentInset
//            if self.view.frame.origin.y == 0  {
//                self.view.frame.origin.y -= bottomOffset


//            }
        }
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        containerView.snp.remakeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaInsets)
            $0.height.equalTo(52)
        })
        UIView.animate(withDuration: 1, animations: { [weak self] in
               self?.view.layoutIfNeeded()
        })

//        isKeyboardShow = false
//        if let _ = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y != 0  {
//                self.view.frame.origin.y = 0
//                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//                self.tableView.scrollIndicatorInsets = self.tableView.contentInset
//            }
//        }
    }
    
    @objc override func keyboardChanged(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            containerView.snp.remakeConstraints({
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview().inset(keyboardHeight)
                $0.height.equalTo(52)
            })
            UIView.animate(withDuration: 1, animations: { [weak self] in
                           self?.view.layoutIfNeeded()
            })
            
//            self.tableView.contentInset = UIEdgeInsets(top: keyboardHeight, left: 0, bottom: 0, right: 0)
//            self.tableView.scrollIndicatorInsets = self.tableView.contentInset
        }
    }
}

extension MultiMessageVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}


class MultiMessageViewModel {
    let disposeBag = DisposeBag()
    //input
    var textinput: PublishSubject<String> = PublishSubject()
    
    //output
    var outputList: BehaviorRelay<[KidItem]> = BehaviorRelay(value: [])
    var selectedList: [KidItem]
    
    init(selectedList: [KidItem]) {
//        guard let me = Session.me else { return }
        self.selectedList = selectedList
    }
    
    func sendMessage(text: String) {
       
    }
}

