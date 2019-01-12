//
//  StartVC.swift
//  Plug
//
//  Created by changmin lee on 18/11/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit

class StartVC: PlugViewController {
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(StartVC.appDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(StartVC.didLogout), name: NSNotification.Name(rawValue: kDidLogoutNotification), object: nil)
        
    }
    
    @objc func appDidBecomeActive() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        self.show()
    }
    
    @objc func didLogout() {
        self.show()
    }
    
    fileprivate func show() {
        if Session.fetchToken() != nil {
            print("[token] \(Session.me?.token ?? "")")
            Session.me?.refreshMe(completion: { (user) in
                Networking.getUserInfo(completion: { (classData, crontab) in
                    Session.me?.classData = classData
                    if let crontab = crontab {
                        Session.me?.schedule = Schedule(schedule: crontab)
                        
                    }
                    self.animateSegue("Main", sender: nil)
                })
            })
        } else {
            self.animateSegue("Login", sender: nil)
        }
    }
    
    func animateSegue(_ identifier:String,sender:AnyObject?) {
        UIView.animate(withDuration: 0.3, animations: {
            self.logoImage.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (completion) in
            UIView.animate(withDuration: 0.3, animations: {
                self.logoImage.transform = CGAffineTransform.identity
            }) { (completion) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.logoImage.alpha = 0
                    self.titleImage.alpha = 0
                }) { (completion) in
                    
                    
                    self.performSegue(withIdentifier: identifier, sender: sender)
                }
            }
        }
    }
}
