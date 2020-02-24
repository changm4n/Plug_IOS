//
//  PhotoSelector.swift
//  Plug
//
//  Created by changmin lee on 2020/02/16.
//  Copyright © 2020 changmin. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base: PhotoSelector {
    var selectedImage: Binder<UIImage?> {
        return Binder(self.base) { (view, image) in
            view.photoView.image = image
            view.setTitle(image != nil ? "" : "+", for: .normal)
        }
    }
}

class PhotoSelector: UIButton {
    
    private var disposebag = DisposeBag()
    
    let photoView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor.clear
        iv.isUserInteractionEnabled = false
        return iv
        }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("not implement!")
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white
        self.addSubview(photoView)
        
        self.setTitleColor(UIColor.plugBlue, for: .normal)
        self.setTitle("+", for: .normal)
        self.titleLabel?.font =  UIFont.getBold(withSize: 25)
        
        let pressDownTransform = rx.controlEvent([.touchDown, .touchDragEnter])
            .map({ CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95) })

        let pressUpTransform = rx.controlEvent([.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
            .map({ CGAffineTransform.identity })

        Observable.merge(pressDownTransform, pressUpTransform)
            .distinctUntilChanged()
            .subscribe(onNext: animate(_:))
            .disposed(by: disposebag)
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
    
    public func setImage(url: String?) {
        self.photoView.setImageWithURL(urlString: url, showDefault: false)
        self.setTitle(url != nil ? "" : "+", for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.photoView.layer.cornerRadius = self.frame.height / 2
        self.photoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 3
        self.layer.shadowColor = UIColor(r: 26/255.0, g: 56/255.0, b: 127/255.0, a: 0.35).cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 0.35
        self.layer.shadowRadius = 11
    }
}

open class ImagePicker: NSObject {

    private let pickerController: UIImagePickerController
    weak var presentationController: UIViewController?

    public var selectedImage = PublishRelay<UIImage?>()
    
    public override init() {
        self.pickerController = UIImagePickerController()

        super.init()

//        self.presentationController = presentationController

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    public func present(from sourceView: UIView) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }
        
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { (action) in
            self.selectedImage.accept(nil)
        }
        alertController.addAction(removeAction)
        

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        self.selectedImage.accept(image)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension ImagePicker: UINavigationControllerDelegate {

}
