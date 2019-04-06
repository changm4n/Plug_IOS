//
//  JoinRoomVC2.swift
//  Plug
//
//  Created by changmin lee on 13/01/2019.
//  Copyright © 2019 changmin. All rights reserved.
//

import UIKit

class JoinRoomVC2: JoinRoomVC {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        FBLogger.log(id: "myclassInputInvitCode_nextBtn_toMyClassInputChildname")
        let vc = segue.destination as! KidVC2
        vc.classData = sender as? ChatRoomApolloFragment
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setColors()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            statusbarLight = true
        }
        super.willMove(toParent: parent)
    }
    
    private func setColors() {
        statusbarLight = false
    }
}
