//
//  NotePlainCell.swift
//  Plug
//
//  Created by changmin lee on 18/11/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit

class NotePlainCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextViewFixed!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
