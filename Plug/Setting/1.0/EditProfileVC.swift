
//
//  EditProfileVC.swift
//  Plug
//
//  Created by changmin lee on 01/01/2019.
//  Copyright © 2019 changmin. All rights reserved.
//

import UIKit

class EditProfileVC: PlugViewController {
    
    let itemsOn: [[(String, String)]] = [[("이름","textfieldCell")], [("플러그 계정","cell2"), ("비밀번호 변경","cell")],[("카카오톡 아이디로 가입","cell")]]
    let itemsOffs: [[(String, String)]] = [[("이름","textfieldCell")], [("플러그 계정","cell2"), ("desc","desc")],[("카카오톡 아이디로 가입","cell")]]
    let headers = ["이름","플러그 계정 설정","소셜로그인"]
    var currentItems: [[(String, String)]] {
        return isOn ? itemsOn : itemsOffs
    }
    
    var isOn: Bool = false
    var selectedRow = 0 {
        didSet {
            selectedURL = selectedRow == 0 ? "" : profileUrls[selectedRow - 1]
        }
    }
    var profileImage: UIImage?
    
    var selectedURL = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.tableView.register(UINib(nibName: "PlugClassCell", bundle: nil), forCellReuseIdentifier: "cell2")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setColors()
        collectionView.reloadData()
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let newField = tableView.cellForRow(at: IndexPath(item: 0, section: 0))?.viewWithTag(1) as? UITextField,
            let newName = newField.text,
        let me = Session.me{
            if me.name != newName || me.profileImageUrl != selectedURL {
                Session.me?.profileImageUrl = self.selectedURL
                Session.me?.name = newName
                Networking.updateUser(user: me, name: newName, url: selectedURL) { (name, error) in}
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit",
            let image = profileImage {
            let vc = segue.destination as! EditImageVC
            vc.originalImage = image
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
                                self.tableView.reloadData()
                            }
                    })
                    
                }
            }
        }
    }
    
    func setData() {
        guard let me = Session.me else { return }
        isOn = me.userId != nil
        for (index, url) in profileUrls.enumerated() {
            if url == me.profileImageUrl {
                selectedRow = index + 1
            }
        }
        collectionView.reloadData()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            navigationController?.navigationBar.barTintColor = UIColor.plugBlue
            statusbarLight = true
        }
        super.willMove(toParent: parent)
    }
    
    private func setColors() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
        statusbarLight = false
    }
}

extension EditProfileVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return currentItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentItems[section].count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        let item = currentItems[section][row]
        
        switch item.0 {
        case "플러그 계정":
            performSegue(withIdentifier: isOn ? "changeID" : "register", sender: nil)
        case "비밀번호 변경":
            performSegue(withIdentifier: "changePW", sender: nil)
        default:
            break
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let item = currentItems[section][row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: item.1, for: indexPath)
        
        if row == currentItems[section].count - 1 {
            cell.addBottomLine()
        }
        
        switch item.0 {
        case "이름":
            if let textfield = cell.viewWithTag(1) as? UITextField {
                textfield.text = Session.me?.name ?? "error"
                textfield.delegate = self
            }
            
        case "플러그 계정":
            let cell2 = cell as! PlugClassCell
            cell2.accessoryType = .disclosureIndicator
            cell2.configure(title: item.0, info: Session.me?.userId ?? "미등록")
            
        case "비밀번호 변경":
            cell.textLabel?.text = item.0
            cell.accessoryType = .disclosureIndicator
        case "desc":
            cell.textLabel?.text = ""
        case "카카오톡 아이디로 가입":
            cell.textLabel?.text = Session.me?.userType == .KAKAO ? "카카오톡 아이디로 가입" : "이메일로 가입"
            cell.textLabel?.textColor = UIColor.grey
        default:
            break
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header =  UINib(nibName: "ClassHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ClassHeader
        header?.label.text = headers[section]
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        let item = currentItems[section][row]
        switch  item.1 {
        case "cell", "textfieldCell":
            return 45
        case "cell2":
            return 60
        case "desc":
            return 64
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
}

extension EditProfileVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}


extension EditProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        
//        cell.imageView.image = Session.me?.profileImage
        cell.configure(row: indexPath.row, isSelected: indexPath.row == selectedRow)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let firstAction: UIAlertAction = UIAlertAction(title: "사진 찍기", style: .default) { action -> Void in
                let imagePicker = UIImagePickerController()
                if UIImagePickerController.isSourceTypeAvailable(.camera){
                    
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera
                    imagePicker.allowsEditing = false
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
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