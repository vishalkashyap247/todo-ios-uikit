//
//  TodoTask.swift
//  MyTasks
//
//  Created by Vishal Kashyap on 02/07/24.
//

import Foundation

final class TodoTask {
    var title: String
    var description: String?
    var dueDate: Date?
    var createdDate: Date
    var lastEditDate: Date?
    
    init(title: String, description: String?, dueDate: Date?, lastEditDate: Date? = nil) {
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.createdDate = Date.now
        self.lastEditDate = lastEditDate
    }
}
