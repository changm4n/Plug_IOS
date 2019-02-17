//
//  ViewController+Extensions.swift
//  Plug
//
//  Created by changmin lee on 2018. 10. 21..
//  Copyright © 2018년 changmin. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

class PlugViewController: UIViewController {
    
    var bottomButton : UIButton? = nil {
        didSet {
             bottomButton?.addTarget(self, action: #selector(PlugViewController.bottomButtonPressed), for: .touchUpInside)
        }
    }
    var bottomAction: (() -> Void)?
    var keyboardHeight: CGFloat = 0
    var isKeyboardShow: Bool = false
    var statusbarLight: Bool = true {
        didSet {
            UIApplication.shared.statusBarStyle = statusbarLight ? .lightContent : .default
        }
    }
    
    @IBAction func back(segue: UIStoryboardSegue) {}
    
    func hideNavigationBar() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(PlugViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PlugViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
      
    }
    
    @objc func bottomButtonPressed() {
        bottomAction?()
    }
    
    func setKeyboardHide() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PlugViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let bottomButton = bottomButton else { return }
        let offset = view.frame.size.height - bottomButton.frame.size.height
        bottomButton.frame.origin.y = isKeyboardShow ? offset - keyboardHeight : offset
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        isKeyboardShow = true
        guard let bottomButton = bottomButton else { return }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            if bottomButton.frame.origin.y == view.frame.size.height - bottomButton.frame.size.height {
                bottomButton.frame.origin.y = view.frame.size.height - bottomButton.frame.size.height - keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        isKeyboardShow = false
        guard let bottomButton = bottomButton else { return }
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if bottomButton.frame.origin.y != view.frame.size.height - bottomButton.frame.size.height {
                bottomButton.frame.origin.y = view.frame.size.height - bottomButton.frame.size.height
            }
        }
    }
    
    func play() {
        PlugIndicator.shared.play()
        self.view.isUserInteractionEnabled = false
    }
    
    func stop() {
        PlugIndicator.shared.stop()
        self.view.isUserInteractionEnabled = true
    }
}


extension UIViewController {
    func setStatusBar(isWhite: Bool) {
        UIApplication.shared.statusBarStyle = isWhite ? .lightContent : .default
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setNavibar(isBlue: Bool) {
        self.navigationController?.navigationBar.barTintColor = isBlue ? UIColor.plugBlue : UIColor.white
        self.navigationController?.navigationBar.tintColor = isBlue ? UIColor.white : UIColor.black
    }
    
    func setNavibar(isHide: Bool) {
        if isHide {
//            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
        } else {
            self.navigationController?.navigationBar.shadowImage = nil
        }
    }
    
    func resetNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = true
    }
}
