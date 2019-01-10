//
//  EditImageVC.swift
//  Plug
//
//  Created by changmin lee on 10/01/2019.
//  Copyright © 2019 changmin. All rights reserved.
//

import UIKit

class EditImageVC: PlugViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!

    var handler: ((UIImage?) -> Void)?
    
    var originalImage: UIImage!
    var fillLayer = CAShapeLayer()
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        fillLayer.opacity = 0
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!.cgImage!
        UIGraphicsEndImageContext()
        let positionX = (SCREEN_WIDTH - 300) / 2
        let positionY = containerView.frame.origin.y + (containerView.bounds.size.height - 300) / 2
        let cropFrame = CGRect(x: positionX, y: positionY, width: 300, height: 300)
        let new = image.cropping(to: cropFrame)

        handler?(UIImage(cgImage: new!))
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
//        imageView.image = originalImage
        
        scrollView.maximumZoomScale = 6.0
        scrollView.minimumZoomScale = 1.0
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: containerView.bounds.size.width, height: containerView.bounds.size.height), cornerRadius: 0)
        let circlePath = UIBezierPath(roundedRect: CGRect(x: (SCREEN_WIDTH - 300) / 2, y: (containerView.frame.size.height - 300) / 2, width: 2 * 150, height: 2 * 150), cornerRadius: 150)
        path.append(circlePath)
        path.usesEvenOddFillRule = true
        
        
        fillLayer.path = path.cgPath
        fillLayer.fillRule = kCAFillRuleEvenOdd
        fillLayer.fillColor = UIColor(r: 4, g: 4, b: 15, a: 1).cgColor
        fillLayer.opacity = 0.4
        
        containerView.layer.addSublayer(fillLayer)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}

