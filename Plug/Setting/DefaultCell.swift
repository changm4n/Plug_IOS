//
//  DefaultCell.swift
//  Plug
//
//  Created by changmin lee on 2020/02/22.
//  Copyright © 2020 changmin. All rights reserved.
//

import Foundation
import UIKit

class DefaultCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var indicator: UIImageView!
    @IBOutlet weak var separator: UIView!
    
    func setContentText(text: String) {
        contentLabel.text = text
        indicator.isHidden = true
    }
    
    func hideSeparator(hide: Bool) {
        separator.isHidden = hide
    }
}
