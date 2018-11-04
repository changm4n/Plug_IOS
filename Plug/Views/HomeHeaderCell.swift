//
//  HomeHeaderCell.swift
//  Plug
//
//  Created by changmin lee on 31/10/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit

class HomeHeaderCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        label.layer.cornerRadius = 14.5
        label.clipsToBounds = true
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.lightGray.cgColor
    }
}
