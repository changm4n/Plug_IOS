//
//  ViewController+Extensions.swift
//  Plug
//
//  Created by changmin lee on 2018. 10. 21..
//  Copyright © 2018년 changmin. All rights reserved.
//

import Foundation
import UIKit

class PlugViewController: UIViewController {
    
    var bottomButton : UIButton? = nil {
        didSet {
             bottomButton?.addTarget(self, action: #selector(PlugViewController.bottomButtonPressed), for: .touchUpInside)
        }
    }
    var bottomAction: (() -> Void)?
    func hideNavigationBar() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(PlugViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PlugViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PlugViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
    }
    
    @objc func bottomButtonPressed() {
        bottomAction?()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let bottomButton = bottomButton else { return }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if bottomButton.frame.origin.y == SCREEN_HEIGHT - bottomButton.frame.size.height {
                bottomButton.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let bottomButton = bottomButton else { return }
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if bottomButton.frame.origin.y != SCREEN_HEIGHT - bottomButton.frame.size.height {
                bottomButton.frame.origin.y = SCREEN_HEIGHT - bottomButton.frame.size.height
            }
        }
    }
}

