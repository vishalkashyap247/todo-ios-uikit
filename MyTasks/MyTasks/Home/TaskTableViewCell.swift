//
//  TaskTableViewCell.swift
//  MyTasks
//
//  Created by Vishal Kashyap on 03/07/24.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var des: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setup(with task: TodoTask, indexPath: IndexPath) {
        self.indexPath = indexPath
        title.text = task.title
        des.text = task.description
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy h:mma"
        if let dueDateText = task.dueDate {
            dueDate.text = "Due date: \(dateFormatter.string(from: dueDateText))"
        } else {
            dueDate.text = "Created date: \(dateFormatter.string(from: task.createdDate))"
        }
    }
    
    func setup(with task: TaskItem, indexPath: IndexPath) {
        self.indexPath = indexPath
        title.text = task.title
        des.text = task.taskdescription
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy h:mma"
        if let dueDateText = task.dueDate {
            dueDate.text = "Due date: \(dateFormatter.string(from: dueDateText))"
        } else if let createdDate = task.createdDate {
            dueDate.text = "Created date: \(dateFormatter.string(from: createdDate))"
        }
    }
}
