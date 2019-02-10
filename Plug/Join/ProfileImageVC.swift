//
//  ProfileImageVC.swift
//  Plug
//
//  Created by changmin lee on 2018. 10. 23..
//  Copyright © 2018년 changmin. All rights reserved.
//

import UIKit
import TOCropViewController
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
    var profileImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setKeyboardHide()
        self.setTextFields()
        bottomButton = bottomBtn
        bottomBtn.isEnabled = false
        self.bottomAction = {
            //TODO : image
            let url = self.selectedRow == 0 ? "" : profileUrls[self.selectedRow - 1]
            guard let name = self.nameTextField.text,
                let me = Session.me,
                let userId = Session.me?.userId,
                let pw = Session.me?.password else { return }
            me.name = name
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
                                    if let me = me {
                                        let user = Session(withUser: me)
                                        user.token = token
                                        Session.me = user
                                        user.save()
                                        if Session.me?.role == .PARENT {
                                            self.performSegue(withIdentifier: "join", sender: nil)
                                        } else {
                                            self.performSegue(withIdentifier: "next", sender: nil)
                                        }
                                    }
                                })
                            } else {
                                showAlertWithString("오류", message: "회원가입 중 오류가 발생하였습니다.", sender: self)
                            }
                        })
                    } else {
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
                                        Networking.updateUser(user: user, name: name, url: url, completion: { (name, error) in
                                            if name != nil {
                                                Session.me?.name = name
                                                Session.me?.profileImageUrl = url
                                                if Session.me?.role == .PARENT {
                                                    self.performSegue(withIdentifier: "join", sender: nil)
                                                } else {
                                                    self.performSegue(withIdentifier: "next", sender: nil)
                                                }
                                            }
                                        })
                                    } else {
                                        showNetworkError(sender: self)
                                    }
                                })
                            } else {
                                showNetworkError(message: message, sender: self)
                            }
                        })
                    } else {
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
            vc.handler = { result in
                Session.me?.profileImage = result
                self.collectionView.reloadData()
            }
        }
    }
}

extension ProfileImageVC: UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {
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
            collectionView.reloadData()
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        profileImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true) {
            //            let vc = TOCropViewController(croppingStyle: .circular, image: self.profileImage!)
            //            vc.delegate = self
            //            self.present(vc, animated: true, completion: nil)
            self.performSegue(withIdentifier: "edit", sender: nil)
        }
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropToCircleImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        let ima = UIImageView(frame: CGRect(x: 100, y: 100, width: 200, height: 200 ))
        ima.image = image
        view.addSubview(ima)
    }
}
