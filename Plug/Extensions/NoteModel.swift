//
//  NoteModel.swift
//  Plug
//
//  Created by changmin lee on 17/11/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import Foundation


enum NoteType: String {
    case plain = "plain", attatch = "attatch", image = "image"
}


struct Note {
    var type: NoteType
    var title: String
    var className: String
    var teacherName: String
    var textContent: String?
    
    init(title: String, cname: String, tname: String, type: NoteType) {
        self.title = title
        self.className = cname
        self.teacherName = tname
        self.type = type
    }
}
