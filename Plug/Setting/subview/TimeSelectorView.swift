//
//  TimeSelectorView.swift
//  Plug
//
//  Created by changmin lee on 2020/03/08.
//  Copyright © 2020 changmin. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class TimeSelectorView: UIView {
    
    let disposeBag = DisposeBag()
    
    let blockView: UIView = {
        let v = UIView(frame: CGRect.zero)
        v.backgroundColor = UIColor(white: 0, alpha: 0.0)
        v.isHidden = true
        return v
    }()
    
    let selector = TimeSelector()
    
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
    
    func setTitle(title: String) {
        self.selector.label.text = title
    }
    
    func setLayout() {
        blockView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        selector.snp.makeConstraints({
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalTo(self.snp.bottom)
            $0.height.equalTo(399)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        self.isHidden = false
        blockView.isHidden = false
        self.selector.snp.updateConstraints {
            $0.top.equalTo(self.snp.bottom).offset(-399)
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

extension TimeSelector: UIPickerViewDelegate {
    
//    @available(iOS 2.0, *)
//    optional func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat
//
//    @available(iOS 2.0, *)
//    optional func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat

//    optional func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?

//    @available(iOS 6.0, *)
//    optional func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? // attributed title is favored if both methods are implemented

    
//    @available(iOS 2.0, *)
//    optional func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
//
}

class TimeSelector: UIView {
    
    let picker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.minuteInterval = 10
        return picker
    }()
    
    let label: UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.font = UIFont.getBold(withSize: 17)
        lb.textColor = UIColor.charcoalGreyTwo
        return lb
    }()
    
    var selectedDate = Date() {
        willSet {
            self.selectedHandler?(newValue)
        }
    }
    
    var selectedHandler: ((Date) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        self.addSubview(label)
        self.addSubview(picker)
        
        picker.addTarget(self, action: #selector(changed(sender:)), for: .valueChanged)

        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        
        setLayout()
    }
    
    func setLayout() {
        label.snp.makeConstraints({
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(25)
        })
        
        picker.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(label.snp.bottom).offset(16)
            $0.height.equalTo(215)
        })
    }
    
    @objc func changed(sender: UIDatePicker) {
        self.selectedDate = sender.date
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

