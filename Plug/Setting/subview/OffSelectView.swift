//
//  OffSelectView.swift
//  Plug
//
//  Created by changmin lee on 2020/03/08.
//  Copyright © 2020 changmin. All rights reserved.
//
import Foundation
import UIKit
import RxSwift

class OffSelectorView: UIView {
    
    let disposeBag = DisposeBag()
    
    let blockView: UIView = {
        let v = UIView(frame: CGRect.zero)
        v.backgroundColor = UIColor(white: 0, alpha: 0.0)
        v.isHidden = true
        return v
    }()
    
    let selector = OffSelector()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.isHidden = true
        self.addSubview(blockView)
        self.addSubview(selector)
        
        blockView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            self?.hide()
        }).disposed(by: disposeBag)
        
        setLayout()
    }
    
    func setLayout() {
        blockView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        selector.snp.makeConstraints({
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalTo(self.snp.bottom)
            $0.height.equalTo(491)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        self.isHidden = false
        blockView.isHidden = false
        self.selector.snp.updateConstraints {
            $0.top.equalTo(self.snp.bottom).offset(-491)
        }
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.blockView.backgroundColor = UIColor(white: 0, alpha: 0.4)
            self?.layoutIfNeeded()
        })
    }
    
    func hide() {
        self.selector.snp.updateConstraints {
            $0.top.equalTo(self.snp.bottom)
        }
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.blockView.backgroundColor = UIColor(white: 0, alpha: 0.0)
            self?.layoutIfNeeded()
            }, completion: { [weak self] _ in
                self?.blockView.isHidden = true
                self?.isHidden = true
        })
    }
}

extension OffSelector: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "offcell", for: indexPath) as! OffSelectCell
        cell.configure(title: kDays[row], selected: selectedDay.contains(row + 1))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kDays.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row + 1
        if selectedDay.contains(row) {
            selectedDay.remove(row)
        } else {
            selectedDay.insert(row)
        }
    }
}

class OffSelector: UIView {
       
       let tableView: UITableView = {
           let tv = UITableView()
           tv.isScrollEnabled = false
           tv.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
           tv.register(UINib(nibName: "OffSelectCell", bundle: nil), forCellReuseIdentifier: "offcell")
           return tv
       }()
       
       let label: UILabel = {
           let lb = UILabel()
           lb.text = "휴일 설정"
           lb.font = UIFont.getBold(withSize: 17)
           lb.textColor = UIColor.charcoalGreyTwo
           return lb
       }()
       
       var selectedDay = Set<Int>() {
           willSet {
               self.selectedHandler?(Array(newValue).sorted())
           }
           didSet {
               self.tableView.reloadData()
           }
       }
       
       var selectedHandler: (([Int]) -> Void)?
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           self.backgroundColor = UIColor.white
           
           self.addSubview(label)
           self.addSubview(tableView)
           
           
           self.layer.cornerRadius = 12
           self.layer.masksToBounds = true
           
           setLayout()
           tableView.delegate = self
           tableView.dataSource = self
       }
       
       func setLayout() {
           label.snp.makeConstraints({
               $0.top.equalToSuperview().offset(32)
               $0.leading.equalToSuperview().offset(24)
               $0.height.equalTo(25)
           })
           
           tableView.snp.makeConstraints({
               $0.leading.trailing.bottom.equalToSuperview()
               $0.top.equalTo(label.snp.bottom).offset(16)
           })
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
}
