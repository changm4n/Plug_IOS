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
    @IBOutlet weak var descLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        let recog = UITapGestureRecognizer(target: self, action: #selector(ViewController.descPressed))
        descLabel.addGestureRecognizer(recog)
    }
    
    @objc func descPressed() {
        performSegue(withIdentifier: "web", sender: "http://www.plugapp.me/privateTerm/")
    }
    
    func setUI() {
        titleLabel.attributedText = kLaunchTitleString
        descLabel.attributedText = kLaunchDescString
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
                    if let email = me?.account?.email,
                        let id = me?.id {
                        let user = Session()
                        user.id = id
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "web" {
            let nvc = segue.destination as! UINavigationController
            let vc = nvc.viewControllers[0] as! WebVC
            vc.urlStr = sender as? String
            vc.title = "이용약관 및 개인정보 처리방침"
        }
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
    
    @IBAction func kakaoLoginPressed(_ sender: Any) {
        KOSession.shared()?.close()
        
        KOSession.shared()?.open(completionHandler: { (error) in
            if KOSession.shared()?.isOpen() ?? false {
                KOSessionTask.userMeTask(completion: { (error, me) in
                    if let id = me?.id {
                        let user = Session()
                        user.id = id
                        user.userType = .KAKAO
                        user.password = "KAKAO"
                        Session.me = user
                        
                        Networking.kakaoSignIn(userId: id, completion: { (token, message, error) in
                            if let token = token {
                                let tmp = Session()
                                Session.me = tmp
                                tmp.token = token
                                tmp.save()
                                Networking.getMe(completion: { (me) in
                                    if let me = me {
                                        let user = Session(withUser: me)
                                        user.token = token
                                        Session.me = user
                                        user.save()
                                        Networking.getUserInfoinStart(completion: { (classData, crontab, summary) in
                                            Session.me?.classData = classData
                                            if let crontab = crontab {
                                                Session.me?.schedule = Schedule(schedule: crontab)
                                            }
                                            PlugIndicator.shared.stop()
                                            self.performSegue(withIdentifier: "kakao", sender: nil)
                                        })
                                    } else {
                                        showNetworkError(sender: self)
                                    }
                                })
                            } else {
                                showNetworkError(message: message, sender: self)
                            }
                        })
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
