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


extension Date {
    func isSameDay(rhs: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: rhs)
    }
    
    func isSameMin(rhs: Date) -> Bool {
        let cal = Calendar.current
        return cal.component(.minute, from: self) == cal.component(.minute, from: rhs)
    }
    
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension UINavigationController {
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.filter({$0.isKind(of: ofClass)}).last {
            popToViewController(vc, animated: animated)
        }
    }
    
    func popViewControllers(viewsToPop: Int, animated: Bool = true) {
        if viewControllers.count > viewsToPop {
            let vc = viewControllers[viewControllers.count - viewsToPop - 1]
            popToViewController(vc, animated: animated)
        }
    }
    
}


extension UITableViewCell {
    func addBottomLine() {
        let line: UIView = UIView(frame: CGRect(x: 0, y: self.frame.size.height - 0.5, width: SCREEN_WIDTH, height: 0.5))
        line.backgroundColor = UIColor.separatorGray
        self.addSubview(line)
    }
}


func PlugLog(string: String) {
    print("[LOG] \(string)")
}
