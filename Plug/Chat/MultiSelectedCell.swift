//
//  MultiSelectedCell.swift
//  Plug
//
//  Created by changmin lee on 2020/02/28.
//  Copyright © 2020 changmin. All rights reserved.
//

import Foundation
import UIKit

class MultiSeletecCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var clearImageView: UIImageView!
    
    override func awakeFromNib() {
        self.imageView.layer.cornerRadius = 24
    }
    func configure(kid: KidItem) {
        imageView.setImageWithURL(urlString: kid.kid.profileURL)
        nameLabel.text = "\(kid.kid.name) 부모님"
    }
}
