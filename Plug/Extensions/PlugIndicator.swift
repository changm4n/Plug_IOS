//
//  PlugIndicator.swift
//  Plug
//
//  Created by changmin lee on 03/02/2019.
//  Copyright © 2019 changmin. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class PlugIndicator: NSObject {
    public static let shared = PlugIndicator()
    
    var animationView = AnimationView(name: "indicator")
    override init() {
        animationView.frame.size = CGSize(width: 100, height: 100)
        animationView.center = UIApplication.shared.keyWindow?.center ?? CGPoint.zero
        animationView.loopMode = .loop
    }
    
    func play() {
        UIApplication.shared.keyWindow?.addSubview(animationView)
        animationView.play()
    }
    
    func stop() {
        animationView.stop()
        animationView.removeFromSuperview()
    }
}
