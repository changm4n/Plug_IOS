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
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor.clear
        navBarAppearance.backgroundImage = UIImage()
        navBarAppearance.shadowColor = UIColor.clear
        
        UINavigationBar.appearance().tintColor = UIColor.black
        
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
//        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backBtn = UIImage(named: "backBtn")
        self.navigationController?.navigationBar.standardAppearance.setBackIndicatorImage(backBtn, transitionMaskImage: backBtn)
//        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", r
        setViews()
        setBinding()
    }
    
    func setViews() {
         
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
    
    func setTitle(title: String, subtitle: String? = nil) {
        let titleParameters = [NSAttributedString.Key.foregroundColor : UIColor.charcoalGrey,
                               NSAttributedString.Key.font : UIFont.getBold(withSize: 20)]
        
        let title:NSMutableAttributedString = NSMutableAttributedString(string: title, attributes: titleParameters)
        
        if let subtitle = subtitle {
            let subtitleParameters = [NSAttributedString.Key.foregroundColor : UIColor.grey,
                                      NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12, weight: .regular)]
            let subtitle:NSAttributedString = NSAttributedString(string: subtitle, attributes: subtitleParameters)
            
            title.append(NSAttributedString(string: " "))
            title.append(subtitle)
        }
        
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
    func setImageWithURL(urlString: String?, showDefault: Bool = true) {
        guard let urlString = urlString else {
            self.image = showDefault ? UIImage(named: "profileDefault") : nil
            return
        }
        guard let url = URL(string: urlString) else {
            self.image = showDefault ? UIImage(named: "profileDefault") : nil
            return
            
        }
        self.kf.setImage(with: url)
    }
}

extension UIImage {
    static func getDefaultProfile() -> UIImage? {
        return UIImage(named: "profileDefault") ?? nil
    }
}
