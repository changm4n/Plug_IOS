//
//  SettingCells.swift
//  Plug
//
//  Created by changmin lee on 2020/02/20.
//  Copyright © 2020 changmin. All rights reserved.
//

import Foundation
import UIKit


class SettingCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}

class SettingDefaultCell: SettingCell {
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var indicator: UIImageView!
    
    func setContentText(text: String) {
        contentLabel.text = text
        indicator.isHidden = true
    }
}

class SettingSwitchCell: SettingCell {
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var cellSwitch: UISwitch!
}

class SettingDescCell: UITableViewCell {
    
}
