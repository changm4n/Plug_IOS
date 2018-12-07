//
//  UIViewExtensions.swift
//  Plug
//
//  Created by changmin lee on 07/12/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func makeCircle() {
        guard frame.size.width == frame.size.height else { return }
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}
