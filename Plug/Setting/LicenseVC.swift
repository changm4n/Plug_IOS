
//
//  LicenseVC.swift
//  Plug
//
//  Created by changmin lee on 17/02/2019.
//  Copyright © 2019 changmin. All rights reserved.
//

import UIKit

class LicenseVC: UITableViewController {

    var items:[[String : String]] = [[:]]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        if let path = Bundle.main.path(forResource: "licenses", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [String : AnyObject] {
                    items = jsonResult["data"] as! [[String : String]]
                    tableView.reloadData()
                }
            } catch {
                // handle error
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]["title"]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "next", sender: items[indexPath.row]["content"])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! License2VC
        vc.content = sender as! String
    }
}

class License2VC :PlugViewController {
    @IBOutlet weak var textView: UITextView!
    var content: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = content
    }
}
