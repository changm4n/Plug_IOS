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
