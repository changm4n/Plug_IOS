//
//  ChatVC.swift
//  Plug
//
//  Created by changmin lee on 05/12/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import UIKit

class ChatVC: PlugViewController {

    let data = ["asdfasdf","asdfasdfasdfasdfasdfasdf","asdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdf","asdf\nasdfasdf\n"]
    var messageData: [MessageApolloFragment] = []
    
    var receiverId: String? = nil
    var senderId: String? = nil
    var chatroomId: String? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setData()
    }
    
    func setData() {
        guard
            let chatroomId = chatroomId,
            let receiverId = receiverId,
            let senderid = senderId else { return }
        
        Networking.getMeassages(chatroomId: chatroomId, userId: senderid, receiverId: receiverId, start: 100, end: nil) { (messages) in
            self.messageData = messages
            self.tableView.reloadData()
        }
        
        Networking.subscribeMessage { (message) in
            if let newMessage = message.node?.fragments.messageApolloFragment {
                self.messageData.append(newMessage)
                self.tableView.reloadData()
            }
        }
    }
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rcell", for: indexPath) as! ChatRCell
        let message = messageData[indexPath.row]
        cell.messageLabel.text = message.text ?? "no text"
        return cell
    }
}




class ChatCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
}


class ChatRCell: ChatCell {    
    override func awakeFromNib() {
        bubbleView.layer.cornerRadius = 16
        bubbleView.clipsToBounds = true
    }
}
