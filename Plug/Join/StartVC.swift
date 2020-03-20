//
//  StartVC.swift
//  Plug
//
//  Created by changmin lee on 18/11/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit
import RxSwift

class StartVC: PlugViewController {
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleImage: UIImageView!
    
    var summary: [MessageSummary] = []
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(StartVC.appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(StartVC.didLogout), name: NSNotification.Name(rawValue: kDidLogoutNotification), object: nil)
        
    }
    
    @objc func appDidBecomeActive() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        self.show()
    }
    
    @objc func didLogout() {
        self.show()
    }
    
    fileprivate func show() {
        
        if Session.fetchToken() != nil {
            UserAPI.getMe().flatMap({ _ in
                return UserAPI.getUserInfo()
            }).flatMap({ _ in
                return Session.me!.reload()
            })
                .subscribe(
                    onSuccess: { [weak self] (_) in
                        SubscriptionManager.shared.start()
                        self?.animateSegue("Main", sender: nil)
                    },
                    onError: { [weak self] (_) in
                        self?.animateSegue("Login", sender: nil)
                })
                .disposed(by: disposeBag)
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
                    
                    if identifier == "Login" {
                        let VC = MainVC()
                        let NVC = UINavigationController(rootViewController: VC)
                        NVC.modalPresentationStyle = .fullScreen
                        NVC.navigationBar.isTranslucent = false
                        self.present(NVC, animated: false, completion: nil)
                        
                    } else {
                        let storyboard = UIStoryboard(name: "Chat", bundle: nil)

                        let vc = storyboard.instantiateViewController(withIdentifier: "ChatListVC")
                        vc.modalPresentationStyle = .fullScreen
                        let nvc = UINavigationController(rootViewController: vc)
                        nvc.navigationBar.prefersLargeTitles = true
                        nvc.modalPresentationStyle = .fullScreen
                        self.present(nvc, animated: false, completion: nil)
                    }
                }
            }
        }
    }
}
