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

        label.layer.cornerRadius = 14.5
        label.clipsToBounds = true
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor(red: 201/255.0, green: 201/255.0, blue: 201/255.0, alpha: 1).cgColor
    }
    
    func setSeleted(selected: Bool) {
        self.label.backgroundColor = selected ? UIColor.plugBlue : UIColor.white
        self.label.textColor = selected ? UIColor.white : UIColor.darkGrey
        
    }
}
