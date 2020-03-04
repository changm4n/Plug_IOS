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

enum WEB_TYPE {
    case privacy
    case usage
}

class DescViewController: PlugViewController {

    let webView: WKWebView = {
        let wv = WKWebView()
        return wv
    }()

    var type: WEB_TYPE!
    
    var urlString: String {
        switch type {
        case .privacy:
            return kUserDesc
        case .usage:
            return kUserTip
        case .none:
            return ""
        }
    }
    
    var titleString: String {
        switch type {
        case .privacy:
            return "약관 및 개인정보 처리방침"
        case .usage:
            return "초대방법"
        case .none:
            return ""
        }
    }
    
    override func setViews() {
        setTitle(title: titleString)
        self.view.addSubview(webView)
        setLayout()
    }
    
    override func setBinding() {
        setWebView()
    }
    
    func setWebView() {
        guard let url = URL(string: urlString)  else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    func setLayout() {
        webView.snp.makeConstraints( {
            $0.edges.equalToSuperview()
        })
    }
}
