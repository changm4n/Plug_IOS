//
//  ViewController.swift
//  Plug
//
//  Created by changmin lee on 2018. 10. 20..
//  Copyright © 2018년 changmin. All rights reserved.
//

import UIKit

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
