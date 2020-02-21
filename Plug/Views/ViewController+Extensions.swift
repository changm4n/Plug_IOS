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


class PlugViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //    var statusbarLight: Bool = false {
    //        didSet {
    //            UIApplication.shared.statusBarStyle = statusbarLight ? .lightContent : .default
    //        }
    //    }
    
    @IBAction func back(segue: UIStoryboardSegue) {}
    
    func hideNavigationBar() {
        //        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        setBinding()
    }
    
    func setViews() {
        let yourBackImage = UIImage(named: "backBtn")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.navigationItem.leftItemsSupplementBackButton = true    
    }
    
    func setBinding() { }
    
    func setKeyboardHide() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PlugViewController.dismissKeyboard))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func play() {
        PlugIndicator.shared.play()
        self.view.isUserInteractionEnabled = false
    }
    
    func stop() {
        PlugIndicator.shared.stop()
        self.view.isUserInteractionEnabled = true
    }
    
    func setTitle(title: String) {
        guard let me = Session.me else { return }
        
        let titleParameters = [NSAttributedString.Key.foregroundColor : UIColor.charcoalGrey,
                               NSAttributedString.Key.font : UIFont.getBold(withSize: 20)]
        
        let title:NSMutableAttributedString = NSMutableAttributedString(string: title, attributes: titleParameters)
        
        
        let size = title.size()
        let width = SCREEN_WIDTH - 120
        
        guard let height = navigationController?.navigationBar.frame.size.height else { return }
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        titleLabel.attributedText = title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        
        navigationItem.titleView = titleLabel
    }
}


extension UIViewController {
    //    func setStatusBar(isWhite: Bool) {
    //        UIApplication.shared.statusBarStyle = isWhite ? .lightContent : .default
    //    }
    
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

class PlugBarbuttonItem: UIBarButtonItem {
    
    override init() {
        super.init()
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)], for: .normal)
    }
}

extension UIImageView {
    func setImageWithURL(urlString: String?) {
        guard let urlString = urlString else { return }
        guard let url = URL(string: urlString) else { return }
        self.kf.setImage(with: url)
    }
}
