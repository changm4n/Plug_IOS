//
//  PlugViewControllerWithButton.swift
//  Plug
//
//  Created by changmin lee on 2020/02/06.
//  Copyright © 2020 changmin. All rights reserved.
//

import Foundation
import UIKit

class PlugViewControllerWithButton: PlugViewController {
    var isKeyboardShow: Bool = false
    var bottomButton : UIButton? = nil {
        didSet {
            bottomButton?.snp.makeConstraints({
                $0.left.equalToSuperview().offset(28)
                $0.right.equalToSuperview().offset(-28)
                $0.height.equalTo(56)
                $0.bottom.equalToSuperview().offset(-24)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(PlugViewControllerWithButton.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PlugViewControllerWithButton.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PlugViewControllerWithButton.keyboardChanged), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        setKeyboardHide()
    }
    
    @objc func keyboardChanged(notification: NSNotification) {
        guard isKeyboardShow else { return }
        guard let bottomButton = bottomButton else { return }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            bottomButton.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(-24 - keyboardHeight)
            }
            UIView.animate(withDuration: 1, animations: { [weak self] in
                           self?.view.layoutIfNeeded()
            })
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        isKeyboardShow = false
        guard let bottomButton = bottomButton else { return }
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            bottomButton.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(-24)
            }
            UIView.animate(withDuration: 1, animations: { [weak self] in
                           self?.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        isKeyboardShow = true
        guard let bottomButton = bottomButton else { return }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            bottomButton.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(-24 - keyboardHeight)
            }
            UIView.animate(withDuration: 1, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            })
        }
    }
}
