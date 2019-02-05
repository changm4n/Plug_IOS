//
//  ViewController.swift
//  Plug
//
//  Created by changmin lee on 2018. 10. 20..
//  Copyright © 2018년 changmin. All rights reserved.
//

import UIKit
import KakaoOpenSDK

class ViewController: PlugViewController {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var kakaoBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        titleLabel.attributedText = kP01Str
        kakaoBtn.setPlugBlue()
        emailBtn.setPlugWhite()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        self.setStatusBar(isWhite: false)
    }
    @IBAction func kakaoButtonPressed(_ sender: Any) {
        KOSession.shared()?.close()
        
        KOSession.shared()?.open(completionHandler: { (error) in
            if KOSession.shared()?.isOpen() ?? false {
                print("kakao : \(KOSession.shared()!.token.accessToken)")
                KOSessionTask.userMeTask(completion: { (error, me) in
                    if let email = me?.account?.email {
                        let user = Session()
                        user.userId = email
                        user.userType = .KAKAO
                        user.password = "KAKAO"
                        Session.me = user
                        self.performSegue(withIdentifier: "kakao", sender: nil)
                    } else {
                        showAlertWithString("오류", message: "카카오 로그인 중 오류가 발생하였습니다.", sender: self)
                    }
                })
            } else {
                showAlertWithString("오류", message: "카카오 로그인 중 오류가 발생하였습니다.", sender: self)
            }
        }, authTypes: [NSNumber(value: KOAuthType.talk.rawValue)])
    }
}

class LoginSelectVC: PlugViewController {
    @IBOutlet weak var kakaoBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.tintColor = UIColor.black
    
        kakaoBtn.setPlugBlue()
        emailBtn.setPlugWhite()
    } 
}
