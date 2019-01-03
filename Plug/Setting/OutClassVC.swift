//
//  OutClassVC.swift
//  Plug
//
//  Created by changmin lee on 03/01/2019.
//  Copyright © 2019 changmin. All rights reserved.
//

import UIKit

class OutClassVC: PlugViewController {
    let items = ["cell", "outcell"]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setColors()
        setNavibar(isHide: true)
        super.viewWillAppear(animated)
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            navigationController?.navigationBar.barTintColor = UIColor.plugBlue
            self.navigationController?.navigationBar.shadowImage = nil
            statusbarLight = true
            
        }
        
        super.willMove(toParentViewController: parent)
    }
    
    private func setColors() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
        statusbarLight = false
    }
}


extension OutClassVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section  = indexPath.section
        let cell = tableView.dequeueReusableCell(withIdentifier: items[section], for: indexPath)
        cell.separatorInset = .zero
        if section == 0 {
            cell.textLabel?.text = "이름"
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header =  UINib(nibName: "ClassHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ClassHeader
        header?.label.text = section == 0 ? "자녀 이름" : ""
        return header
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
}
