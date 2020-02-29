//
//  EditClassVC.swift
//  Plug
//
//  Created by changmin lee on 2020/02/29.
//  Copyright © 2020 changmin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EditClassVC: CreateClassVC {
    var item: ChatRoomApolloFragment!

    var editViewModel: EditClassViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    

    override func bindForm() {
        
        nameTF.text = item.name
        yearTF.text = item.createdAt.substr(to: 3)
        confirmButton.isEnabled = true
        
        editViewModel = EditClassViewModel(id: item.id)
        editViewModel.target = self
        let createForm = Observable.combineLatest(nameTF.rx.text.orEmpty, yearTF.rx.text.orEmpty) { (email, year) in
            return (email, year)
        }
        
        confirmButton.rx.tap.debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(createForm).bind(to: editViewModel.editPressed).disposed(by: disposeBag)
        
        editViewModel.editSuccess.subscribe(onNext: { [unowned self] (result) in
            if let _ = result {
                self.navigationController?.popViewController(animated: true)
            } else {
                showAlertWithString("클래스 편집", message: "클래스 편집에 실패하였습니다.", sender: self, handler: nil)
            }}).disposed(by: disposeBag)
    }
}

class EditClassViewModel {
    let disposeBag = DisposeBag()
    var target: UIViewController?
    //input
    var id: String
    var editPressed: PublishSubject<(String, String)> = PublishSubject()

    //output
    var editSuccess: PublishSubject<String?> = PublishSubject()

    init(id: String) {
        self.id = id
        editPressed.subscribe(onNext: { [unowned self] (name, year) in
            self.edit(id: id, name: name, year: year)
        }).disposed(by: disposeBag)
    }
    
    func edit(id: String, name: String, year: String) {
        ChatroomAPI.updateChatroom(id: id, name: name, year: year)
            .subscribe(onSuccess: { [weak self] (id) in
                self?.editSuccess.onNext(id)
                }, onError: { [weak self] (error) in
                    showErrorAlert(error: error, sender: self?.target)
            }).disposed(by: disposeBag)
    }
}

