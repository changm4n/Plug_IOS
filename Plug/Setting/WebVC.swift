//
//  WebVC.swift
//  Plug
//
//  Created by changmin lee on 10/02/2019.
//  Copyright © 2019 changmin. All rights reserved.
//

import UIKit
import WebKit

class WebVC: PlugViewController, WKUIDelegate, WKNavigationDelegate{

    var webView: WKWebView?
    var urlStr: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        webView = WKWebView(frame: self.view.frame)
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        self.view.addSubview(webView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let urlString = urlStr,
            let url = URL(string: urlString) {
            webView?.load(URLRequest(url: url))
        }
    }
}
