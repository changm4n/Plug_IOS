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


class SettingSwitchCell: SettingCell {
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var cellSwitch: UISwitch!
}

class SettingDescCell: UITableViewCell {
    
}
