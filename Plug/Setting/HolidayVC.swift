//
//  HolidayVC.swift
//  Plug
//
//  Created by changmin lee on 01/01/2019.
//  Copyright © 2019 changmin. All rights reserved.
//

import Foundation
import UIKit

class HolidayVC: PlugViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var selectedDay: [Bool] = [false, false, false, false, false, false, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        guard let me = Session.me else {
            return
        }
        
        for dayStr in me.schedule.days.split(separator: ",") {
            if let day = Int(dayStr) {
                selectedDay[day - 1] = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FBLogger.log(id: "edit_on_day")
        setColors()
        super.viewWillAppear(animated)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.saveSchedule()
    }
    
    func saveSchedule() {
        guard let me = Session.me else { return }
        var off: [Int] = []
        for (index, day) in selectedDay.enumerated() {
            if day { off.append(index + 1) }
        }
        
        me.schedule.setDaysby(arr: off)
    }
}

extension HolidayVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        selectedDay[row] = !selectedDay[row]
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(kDays[row])요일"
        cell.accessoryType = selectedDay[row] ? .checkmark : .none
        
        if row == kDays.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
      
        return cell
    }
}
