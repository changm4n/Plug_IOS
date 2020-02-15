//
//  SetProfileViewController.swift
//  Plug
//
//  Created by changmin lee on 2020/02/16.
//  Copyright © 2020 changmin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SetProfileViewController: PlugViewControllerWithButton {
    
    let disposeBag = DisposeBag()
    
    var imagePicker = ImagePicker()
    
    let photoSelector = PhotoSelector()
    
    let nameTF: PlugTextField = {
        let tf = PlugTextField(type: .name)
        tf.placeholder = "이름"
        tf.placeholderColor = .black
        tf.titleColor = .textBlue
        tf.lineHeight = 1
        tf.selectedLineColor = .plugBlue
        tf.errorColor = .plugRed
        return tf
    }()
    
    let confirmButton: PlugButton = {
        let btn = PlugButton(theme: ButtonTheme.BLUE, isShadow: true, enable: false)
        btn.setTitle("다음", for: .normal)
        return btn
    }()
    
    override func setBinding() {
        self.imagePicker.presentationController = self
        self.imagePicker.selectedImage
            .bind(to: self.photoSelector.rx.selectedImage)
            .disposed(by: disposeBag)
        
        photoSelector.rx.tap.asDriver().drive(onNext: { [unowned self] (_) in
            self.imagePicker.present(from: self.photoSelector)
        }).disposed(by: disposeBag)
        
        nameTF.validation
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        //        confirmButton.rx.tap.debounce(.seconds(1), scheduler: MainScheduler.instance)
        //            .withLatestFrom(nameTF.rx.text).bind(to: viewModel.loginPressed).disposed(by: disposeBag)
        
        //        viewModel.loginSuccess.subscribe(onNext: { (result) in
        //            let storyboard = UIStoryboard(name: "Chat", bundle: nil)
        //            let controller = storyboard.instantiateViewController(withIdentifier: "MainNVC")
        //            controller.modalPresentationStyle = .fullScreen
        //            self.navigationController?.present(controller, animated: true, completion: nil)
        //
        //        }).disposed(by: disposeBag)
        //
        //        viewModel.loginError.asDriver(onErrorJustReturn: "오류")
        //            .drive(onNext: { (errorMessage) in
        //                print(errorMessage)
        //            }).disposed(by: disposeBag)
    }
    
    override func setViews() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(photoSelector)
        self.view.addSubview(nameTF)
        self.view.addSubview(confirmButton)
        
        self.bottomButton = confirmButton
        setLayout()
    }
    
    func setLayout() {
        photoSelector.snp.makeConstraints({
            $0.top.equalToSuperview().offset(140)
            $0.width.height.equalTo(110)
            $0.centerX.equalTo(self.view)
        })
        
        nameTF.snp.makeConstraints({
            $0.left.equalToSuperview().offset(28)
            $0.top.equalTo(photoSelector.snp.bottom).offset(42)
            $0.right.equalToSuperview().offset(-28)
            $0.height.equalTo(52)
        })
    }
}
