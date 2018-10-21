//
//  Strings.swift
//  Plug
//
//  Created by changmin lee on 2018. 10. 21..
//  Copyright © 2018년 changmin. All rights reserved.
//

import Foundation
import UIKit

let kP01Str: NSMutableAttributedString = {
    () -> NSMutableAttributedString in
    let k = NSMutableAttributedString(string: "학부모와 선생님의\n올바른 소통, 플러그", attributes: [
    .font: UIFont.systemFont(ofSize: 20.0, weight: .bold),
    .foregroundColor: UIColor.darkGray,
    .kern: 0.38
    ])
    k.addAttribute(.foregroundColor, value: UIColor.plugBlue, range: NSRange(location: 10, length: 6))
    return k
}()
