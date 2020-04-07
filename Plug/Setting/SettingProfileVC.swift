//
//  SettingProfileVC.swift
//  Plug
//
//  Created by changmin lee on 2020/02/22.
//  Copyright © 2020 changmin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingProfileVC: PlugViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    var imagePicker = ImagePicker()
    let photoSelector = PhotoSelector()
    
    let checkIndicator = CheckIndicator()
    
    let nameTF: PlugTextField = {
        let tf = PlugTextField(type: .name)
        tf.placeholder = "이름"
        tf.placeholderColor = .black
        tf.titleColor = .textBlue
        tf.lineHeight = 1
        tf.selectedLineColor = .plugBlue
        tf.errorColor = .plugRed
        return tf
    }()
    
    let disposeBag = DisposeBag()
    
    let headers = ["플러그 계정 설정", "로그아웃 및 계정관리"]
    let emailCells: [[(String, String)]] = [[("플러그 계정","subtitle"), ("비밀번호 변경", "cell")],[("로그아웃","cell"), ("계정 삭제","cell")]]
    
    let kakaoCells: [[(String, String)]] = [[("플러그 계정","subtitle")],[("로그아웃","cell"), ("계정 삭제","cell")]]
    
    var cells: [[(String, String)]] {
        if let type = Session.me?.userType {
            return type == .KAKAO ? kakaoCells : emailCells
        } else {
            return emailCells
        }
    }
    
    var needToUpdate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.tableView.register(UINib(nibName: "DefaultCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            guard let myName = Session.me?.name.value, var name = nameTF.text else {
                return
            }
            if name != myName {
                needToUpdate = true
            }
            if name == "" {
                name = myName
            }
            if needToUpdate {
                Session.me?.updateProfile(name: name, image: self.photoSelector.photoView.image)
            }
        }
    }
    
    override func setBinding() {
        self.photoSelector.setImage(url: Session.me?.profileImageUrl)
        self.imagePicker.presentationController = self
        
        self.imagePicker.selectedImage.do(onNext: { [weak self] (_) in
            self?.needToUpdate = true
        }).bind(to: self.photoSelector.rx.selectedImage)
            .disposed(by: disposeBag)
        
        photoSelector.rx.tap.asDriver().drive(onNext: { [unowned self] (_) in
            self.imagePicker.present(from: self.photoSelector)
        }).disposed(by: disposeBag)
        
        nameTF.text = Session.me?.name.value
    }
    
    override func setViews() {
        setTitle(title: "계정 설정")
        self.tableView.tableFooterView = UIView()
        
        self.headerView.addSubview(photoSelector)
        self.headerView.addSubview(checkIndicator)
        self.headerView.addSubview(nameTF)
        self.setLayout()
    }
    
    func setLayout() {
        photoSelector.snp.makeConstraints({
            $0.top.equalToSuperview().offset(30)
            $0.width.height.equalTo(96)
            $0.centerX.equalToSuperview()
        })
        
        checkIndicator.snp.makeConstraints({
            $0.width.height.equalTo(32)
            $0.centerX.equalTo(photoSelector.snp.right).offset(-10)
            $0.centerY.equalTo(photoSelector.snp.bottom).offset(-10)
        })
        
        nameTF.snp.makeConstraints({
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(52)
            $0.bottom.equalToSuperview().inset(8)
        })
    }
}

extension SettingProfileVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let item = cells[section][row]
//        let value = item.0
        let id = item.1
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DefaultCell
        cell.titleLabel.text = item.0
        
        if id == "subtitle" {
            let subtitle = Session.me?.userType == SessionType.KAKAO ? "카카오톡 아이디 연동" : Session.me?.userId
            cell.setContentText(text: subtitle ?? "")
        } else {
            cell.indicator.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
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
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        let item = cells[section][row]
        let value = item.0
        
        if value == "로그아웃" {
            showAlertWithSelect("로그아웃", message: "로그아웃 하시겠습니까?", sender: self, handler: { [unowned self] (action) in
                UserAPI.logOut().subscribe().disposed(by: self.disposeBag)
                Session.removeSavedUser()
                let VC = MainVC()
                let NVC = UINavigationController(rootViewController: VC)
                NVC.modalPresentationStyle = .fullScreen
                self.present(NVC, animated: false, completion: nil)
            }, canceltype: .default, confirmtype: .destructive)
        } else if value == "계정 삭제" {
            showAlertWithSelect("계정 삭제", message: "계정을 삭제하시겠습니까?", sender: self, handler: { (_) in
                guard let userId = Session.me?.userId else { return }
                UserAPI.withDraw(userId: userId).subscribe(onSuccess: { [unowned self] (_) in
                    Session.removeSavedUser()
                    let VC = MainVC()
                    let NVC = UINavigationController(rootViewController: VC)
                    NVC.modalPresentationStyle = .fullScreen
                    self.present(NVC, animated: false, completion: nil)
                }).disposed(by: self.disposeBag)
            }, canceltype: .cancel, confirmtype: .destructive)
        } else if value == "비밀번호 변경" {
            let vc = ChangePWVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

class CheckIndicator: UIView {
    
    let largeCircle: UIView = {
        let iv = UIView()
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor.textBlue
        iv.isUserInteractionEnabled = false
        return iv
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "edit"))
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("not implement!")
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.clear
        self.addSubview(largeCircle)
        self.addSubview(imageView)
        
        setLayout()
    }
    
    func setLayout() {
        largeCircle.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        imageView.snp.makeConstraints({
            $0.edges.equalToSuperview().inset(4)
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        largeCircle.layer.cornerRadius = self.frame.width / 2
        largeCircle.layer.borderWidth = 2
        largeCircle.layer.borderColor = UIColor.white.cgColor
    }
}
