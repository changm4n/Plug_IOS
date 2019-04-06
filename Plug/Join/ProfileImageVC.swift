//
//  ProfileImageVC.swift
//  Plug
//
//  Created by changmin lee on 2018. 10. 23..
//  Copyright © 2018년 changmin. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!
    
    func configure(row: Int, isSelected: Bool = false) {
        if row == 0 {
            if isSelected {
                imageView.image = Session.me?.profileImage
            } else {
                imageView.image = UIImage(named: "avatar\(row)")
            }
        } else {
            imageView.image = UIImage(named: "avatar\(row)")
        }
        
        imageView.layer.cornerRadius = 36
        imageView.layer.borderColor = UIColor.plugDarkBlue.cgColor
        imageView.layer.borderWidth = isSelected ? 3 : 0
        checkImageView.isHidden = !isSelected
    }
}

class ProfileImageVC: PlugViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomBtn: WideButton!
    @IBOutlet weak var nameTextField: PlugTextField!
    
    var selectedRow = 1
    var selectedURL = profileUrls[0]
    var profileImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setKeyboardHide()
        self.setTextFields()
        bottomButton = bottomBtn
        bottomBtn.isEnabled = false
        self.bottomAction = {
            //TODO : image
            if Session.me?.password == nil {//선생님이 클래스 입력하다 뒤로 -> 다시 가입 시
                showAlertWithString("오류", message: "이미 사용자가 존재합니다.", sender: self)
            }
            
            guard let name = self.nameTextField.text,
                let me = Session.me,
                let userId = Session.me?.userId,
                let pw = Session.me?.password else { return }
            
            FBLogger.log(id: "signUpUsername_userNameInput", param: ["data" : "name"])
            
            self.play()
            me.name = name
            me.profileImageUrl = self.selectedURL
            
            if me.userType == .EMAIL {
                Networking.signUp(user: me, completion: { (name, error) in
                    if name != nil {
                        Networking.login(userId, password: pw, completion: { (token) in
                            if let token = token {
                                let tmp = Session()
                                Session.me = tmp
                                tmp.token = token
                                tmp.save()
                                Networking.getMe(completion: { (me) in
                                    self.stop()
                                    if let me = me {
                                        let user = Session(withUser: me)
                                        user.token = token
                                        Session.me = user
                                        user.save()
                                        if Session.me?.role == .PARENT {
                                            FBLogger.log(id: "signUpUsername_nextBtn_toSignUpInputInvitCode")
                                            self.performSegue(withIdentifier: "join", sender: nil)
                                        } else {
                                            FBLogger.log(id: "signUpUsername_nextBtn_toSignUpClassname")
                                            self.performSegue(withIdentifier: "next", sender: nil)
                                        }
                                    }
                                })
                            } else {
                                self.stop()
                                showAlertWithString("오류", message: "회원가입 중 오류가 발생하였습니다.", sender: self)
                            }
                        })
                    } else {
                        self.stop()
                        showAlertWithString("오류", message: "회원가입 중 오류가 발생하였습니다.", sender: self)
                    }
                })
            } else {
                guard let id = me.id else { return }
                Networking.kakaoSignUp(userId: id, sessionRole: me.role, completion: { (errors, error) in
                    if errors == nil {
                        Networking.kakaoSignIn(userId: id, completion: { (token, message, error) in
                            if let token = token {
                                let tmp = Session()
                                Session.me = tmp
                                tmp.token = token
                                tmp.save()
                                Networking.getMe(completion: { (me) in
                                    if let me = me {
                                        let user = Session(withUser: me)
                                        user.token = token
                                        Session.me = user
                                        user.save()
                                        Networking.updateUser(user: user, name: name, url: self.selectedURL, completion: { (name, error) in
                                            if name != nil {
                                                self.stop()
                                                Session.me?.name = name
                                                Session.me?.profileImageUrl = self.selectedURL
                                                if Session.me?.role == .PARENT {
                                                    FBLogger.log(id: "signUpUsername_nextBtn_toSignUpInputInvitCode")
                                                    self.performSegue(withIdentifier: "join", sender: nil)
                                                } else {
                                                    FBLogger.log(id: "signUpUsername_nextBtn_toSignUpClassname")
                                                    self.performSegue(withIdentifier: "next", sender: nil)
                                                }
                                            }
                                        })
                                    } else {
                                        showNetworkError(sender: self)
                                        self.stop()
                                    }
                                })
                            } else {
                                self.stop()
                                showNetworkError(message: message, sender: self)
                            }
                        })
                    } else {
                        self.stop()
                        if let message = errors?.first?.message {
                            showAlertWithString("오류", message: message, sender: self)
                        } else {
                            showNetworkError(sender: self)
                        }
                    }
                })
            }
        }
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: collectionView) == true {
            return false
        }
        
        return true
    }
    
    func setTextFields() {
        nameTextField.type = .name
        nameTextField.changeHandler = { [weak self] text, check in
            self?.bottomButton?.isEnabled = check
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit" {
            let vc = segue.destination as! EditImageVC
            vc.originalImage = profileImage!
            vc.handler = { image in
                if let image = image {
                    Networking.uploadImage(image: image
                        , completion: { (url) in
                            if let url = url {
                                print(url)
                                Session.me?.profileImage = image
                                self.selectedRow = 0
                                self.selectedURL = url
                                self.collectionView.reloadData()
                            }
                    })
                }
            }
        }
    }
}

extension ProfileImageVC: UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        cell.configure(row: indexPath.row, isSelected: indexPath.row == selectedRow)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let firstAction: UIAlertAction = UIAlertAction(title: "사진 찍기", style: .default) { action -> Void in
            }
            let secondAction: UIAlertAction = UIAlertAction(title: "사진 선택", style: .default) { action -> Void in
                let imagePicker = UIImagePickerController()
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                    
                    imagePicker.delegate = self
                    imagePicker.sourceType = .photoLibrary;
                    imagePicker.allowsEditing = false
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
            let cancelAction: UIAlertAction = UIAlertAction(title: "닫기", style: .cancel) { action -> Void in }
            actionSheetController.addAction(firstAction)
            actionSheetController.addAction(secondAction)
            actionSheetController.addAction(cancelAction)
            present(actionSheetController, animated: true, completion: nil)
            collectionView.reloadData()
        } else {
            selectedRow = indexPath.row
            selectedURL = profileUrls[indexPath.row - 1]
            collectionView.reloadData()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        profileImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        self.dismiss(animated: true) {
            self.performSegue(withIdentifier: "edit", sender: nil)
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
