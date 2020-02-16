//
//  DescViewController.swift
//  Plug
//
//  Created by changmin lee on 2020/02/17.
//  Copyright © 2020 changmin. All rights reserved.
//

import UIKit
import SnapKit
import WebKit

class DescViewController: PlugViewController {

    let webView: WKWebView = {
        let wv = WKWebView()
        return wv
    }()

    override func setViews() {
        self.view.addSubview(webView)
        setLayout()
    }
    
    override func setBinding() {
        setWebView()
    }
    
    func setWebView() {
        guard let url = URL(string: kUserDesc)  else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    func setLayout() {
        webView.snp.makeConstraints( {
            $0.edges.equalToSuperview()
        })
    }
}
