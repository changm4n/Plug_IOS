//
//  OffSelectCell.swift
//  Plug
//
//  Created by changmin lee on 2020/03/08.
//  Copyright © 2020 changmin. All rights reserved.
//

import Foundation
import UIKit
import BEMCheckBox

class OffSelectCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkBox: BEMCheckBox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkBox.boxType = .square
    }
    
    func configure(title: String, selected: Bool) {
        titleLabel.text = title
        checkBox.on = selected
    }
}
