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
    @IBOutlet weak var container: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setSeleted(selected: Bool) {
        self.label.textColor = selected ? UIColor.filterBlue : UIColor.filterGray
    }
}
