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
    
    var disposeBag = DisposeBag()
    var viewModel: MultiMessageViewModel!
    var seletedKid: [KidItem] = []
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = UIColor.paleGrey2
        tv.register(UINib(nibName: "MultiMessageCell", bundle: nil), forCellReuseIdentifier: "cell")
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
        v.backgroundColor = UIColor.white
        return v
    }()
    
    let backView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    let messageTV: UITextView = {
        let tf = UITextView()
        tf.isEditable = true
        tf.isSelectable = true
        tf.font = UIFont.getRegular(withSize: 16)
        tf.textColor = UIColor.darkGreyText
        tf.contentInset = UIEdgeInsets.zero
        tf.textContainerInset.left = 8
        tf.textContainerInset.right = 8
        return tf
    }()
    
    let sendButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "send"), for: .normal)
        return bt
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    override func setBinding() {
        self.viewModel = MultiMessageViewModel(selectedList: self.seletedKid, target: self)
        
        self.messageTV.rx.text.orEmpty.bind(to: viewModel.textinput).disposed(by: disposeBag)
        
        self.sendButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.resetTextView()
            self?.viewModel.sendPressed.onNext(())
        }).disposed(by: disposeBag)
        
        Observable.of(self.viewModel.selectedList).bind(to: self.collectionView.rx.items) {
            collectionView, row, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "multiselected", for: IndexPath(row: row, section: 0)) as! MultiSeletecCell
            cell.configure(kid: item)
            cell.clearImageView.isHidden = true
            cell.backgroundColor = .clear
            return cell
        }.disposed(by: disposeBag)
        
        viewModel.messageList.bind(to: self.tableView.rx.items) {
            tableView, row, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: IndexPath(row: row, section: 0)) as! MultiMessageCell
            cell.configure(item: item)
            return cell
        }.disposed(by: disposeBag)
    }
    
    override func setViews() {
        self.view.backgroundColor = UIColor.paleGrey2
        self.messageTV.delegate = self
        setTitle(title: "단체 메세지")
        
        self.view.addSubview(backView)
        self.view.addSubview(containerView)
        self.view.addSubview(collectionView)
        self.view.addSubview(tableView)
        
        
        self.containerView.addSubview(messageTV)
        self.containerView.addSubview(sendButton)
        setLayout()
    }
    
    func resetTextView() {
        self.messageTV.text = ""
        containerView.snp.updateConstraints({
            $0.height.equalTo(54.5)
        })
    }
    func setLayout() {
        containerView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(54.5)
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
        
        messageTV.snp.makeConstraints({
            $0.leading.equalToSuperview().inset(4)
            $0.trailing.equalTo(sendButton.snp.leading).inset(4)
            $0.top.bottom.equalToSuperview().inset(4)
        })
        
        sendButton.snp.makeConstraints({
            $0.top.bottom.equalToSuperview().inset(2)
            $0.trailing.equalToSuperview().inset(12)
            $0.leading.equalTo(messageTV.snp.trailing).offset(4)
        })
        
        backView.snp.makeConstraints({
            $0.top.equalTo(tableView.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        })
    }
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            containerView.snp.remakeConstraints({
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview().inset(keyboardHeight)
                $0.height.equalTo(containerView.frame.height)
            })
            UIView.animate(withDuration: 1, animations: { [weak self] in
                           self?.view.layoutIfNeeded()
            })
        }
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        containerView.snp.remakeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaInsets)
            $0.height.equalTo(containerView.frame.height)
        })
        UIView.animate(withDuration: 1, animations: { [weak self] in
               self?.view.layoutIfNeeded()
        })
    }
    
    @objc override func keyboardChanged(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            containerView.snp.remakeConstraints({
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview().inset(keyboardHeight)
                $0.height.equalTo(containerView.frame.height)
            })
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            })
        }
    }
}

extension MultiMessageVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let maxHeight: CGFloat = 112
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        newSize.height += 14.5
        print(newSize)
        self.messageTV.isScrollEnabled = newSize.height >= maxHeight
        containerView.snp.updateConstraints({
            $0.height.equalTo(min(newSize.height, maxHeight))
        })
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
    var sendPressed: PublishSubject<Void> = PublishSubject()
    //output
//    var outputList: BehaviorRelay<[KidItem]> = BehaviorRelay(value: [])
    var selectedList: [KidItem]
    var messageList: BehaviorRelay<[MessageViewItem]> = BehaviorRelay(value: [])
    
    var target: UIViewController
    init(selectedList: [KidItem], target: UIViewController) {
//        guard let me = Session.me else { return }
        self.target = target
        self.selectedList = selectedList
        sendPressed.withLatestFrom(textinput).filter({ !$0.isEmpty })
            .subscribe(onNext: { [weak self] (text) in
                self?.sendMessage(text: text)
            }).disposed(by: disposeBag)
    }
    
    func sendMessage(text: String) {
        MessageAPI.sendMultiMessage(text: text, kids: selectedList).subscribe(onNext: { [unowned self] (arr) in
            var message = MessageItem()
            message.text = text
            
            let item = MessageViewItem(withMessage: message, type: .RCELL)
            
            var list = self.messageList.value
            list.append(item)
            self.messageList.accept(list)
        }, onError: { [unowned self] (error) in
            showErrorAlert(error: error, sender: self.target)
        }).disposed(by: disposeBag)
    }
}

