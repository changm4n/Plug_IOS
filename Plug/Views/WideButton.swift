//
//  WideButton.swift
//  Plug
//
//  Created by changmin lee on 2018. 10. 22..
//  Copyright © 2018년 changmin. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class WideButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = isEnabled ? UIColor.plugBlue : UIColor.disableGray
            setTitleColor(isEnabled ? UIColor.white : UIColor.lightGray, for: .normal)
            if self.image(for: .normal) != nil {
                setImage(isEnabled ? UIImage(named: "btnChevronWhite") : UIImage(named: "btnChevronDisabled"), for: .normal)
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

enum ButtonTheme {
    case BLUE
    case WHITE
}

class PlugButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            shadowLayer?.fillColor = isEnabled ? fillColor : disableColor
        }
    }
    
    private var shadowLayer: CAShapeLayer? = nil
    private var fillColor: CGColor = UIColor.white.cgColor
    private var disableColor = UIColor.plugBlueDisable.cgColor
    private var isShadow: Bool = false
    private var disposebag = DisposeBag()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("not implement!")
    }
    
    init(theme: ButtonTheme, isShadow: Bool, enable: Bool = true) {
        super.init(frame: CGRect.zero)
        
        if theme == .BLUE {
            fillColor = UIColor.plugBlue.cgColor
            setTitleColor(UIColor.white, for: .normal)
        } else {
            fillColor = UIColor.white.cgColor
            setTitleColor(UIColor.plugBlue, for: .normal)
        }
        
        self.isShadow = isShadow
        
        self.titleLabel?.font =  UIFont.getBold(withSize: 16)
        
        let pressDownTransform = rx.controlEvent([.touchDown, .touchDragEnter])
            .map({ CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95) })
        
        let pressUpTransform = rx.controlEvent([.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
            .map({ CGAffineTransform.identity })
        
        Observable.merge(pressDownTransform, pressUpTransform)
            .distinctUntilChanged()
            .subscribe(onNext: animate(_:))
            .disposed(by: disposebag)
        self.isEnabled = enable
    }
    
    private func animate(_ transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: {
                        self.transform = transform
        }, completion: nil)
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard shadowLayer == nil else { return }
        
        shadowLayer = CAShapeLayer()
        shadowLayer?.path = UIBezierPath(roundedRect: bounds, cornerRadius: 8).cgPath
        shadowLayer?.fillColor = isEnabled ? fillColor : disableColor
        
        if isShadow {
            shadowLayer?.shadowColor = UIColor(r: 26/255.0, g: 56/255.0, b: 127/255.0, a: 0.15).cgColor
            
            let dx: CGFloat = 12
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowLayer?.shadowPath = UIBezierPath(rect: rect).cgPath
            shadowLayer?.shadowOffset = CGSize(width: 0.0, height: 18.0)
            shadowLayer?.shadowOpacity = 1
            shadowLayer?.shadowRadius = 20
            
            layer.insertSublayer(shadowLayer!, at: 0)
        }
    }
}

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.15,
        x: CGFloat = 0,
        y: CGFloat = 18,
        blur: CGFloat = 40,
        spread: CGFloat = -12)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
