//
//  WideButton.swift
//  Plug
//
//  Created by changmin lee on 2018. 10. 22..
//  Copyright © 2018년 changmin. All rights reserved.
//

import Foundation
import UIKit

class WideButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = isEnabled ? UIColor.plugBlue : UIColor.disableGray
            setTitleColor(isEnabled ? UIColor.white : UIColor.lightGray, for: .normal)
            if self.image(for: .normal) != nil {
//                setImage(isEnabled ? UIImage(named: "btnChevronWhite") : UIImage(named: "btnChevronDisabled"), for: .normal)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.plugBlue
        self.titleLabel?.font = UIFont.headline17PtNormalCenter
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        setTitleColor(UIColor.white, for: .normal)
        setTitleColor(UIColor.lightGray, for: .highlighted)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.backgroundColor = UIColor.plugDeepBlue
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.backgroundColor = UIColor.plugBlue
    }
}
