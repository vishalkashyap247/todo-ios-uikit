//
//  TaskDetailViewController.swift
//  MyTasks
//
//  Created by Vishal Kashyap on 03/07/24.
//

import UIKit

class TaskDetailViewController: UIViewController {
    var task: TaskItem?
    var taskList: [TodoTask]?
    var indexPath: IndexPath?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var lastEditedDateLabel: UILabel!
    
    @IBOutlet weak var dueDate: UILabel!
    @IBOutlet weak var creationDate: UILabel!
    @IBOutlet weak var lastEdit: UILabel!
    
    var delegate: TaskDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Task Detail"
        
        
        refreshView()
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTask))
        navigationItem.rightBarButtonItem = editButton
    }
    
    private func refreshView() {
        if let task = task {
            titleLabel.text = task.title
            descriptionLabel.text = task.taskdescription
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy h:mma"
            if let dueDateText = task.dueDate {
                dueDateLabel.isHidden = false
                dueDate.isHidden = false
                dueDateLabel.text = dateFormatter.string(from: dueDateText)
            } else {
                dueDate.isHidden = true
                dueDateLabel.isHidden = true
            }
            
            if let createdDateText = task.createdDate {
                creationDate.isHidden = false
                creationDateLabel.isHidden = false
                creationDateLabel.text = dateFormatter.string(from: createdDateText)
            }
            
            
            if let lastEditDate = task.lastEdited {
                lastEditedDateLabel.isHidden = false
                lastEdit.isHidden = false
                lastEditedDateLabel.text = dateFormatter.string(from: lastEditDate)
            } else {
                lastEdit.isHidden = true
                lastEditedDateLabel.isHidden = true
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view did appear of detail")
        super.viewWillAppear(animated)
    }
    
    @objc func editTask() {
        // Handle edit task
        print("Edit button tapped.")
        // I am using same view controller for now.
        // TODO: Rename this view controller name.
        let addTaskVC = AddTaskViewController()
        addTaskVC.indexPath = self.indexPath
        addTaskVC.task = task
        addTaskVC.delegate = self
        addTaskVC.modalPresentationStyle = .overFullScreen
        present(addTaskVC, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TaskDetailViewController: TaskDelegate {
    func addTask(title: String, description: String, dueDate: Date) {
        print("Add task")
//        delegate?.updateTask(task, indexPath: indexPath)
        self.task?.title = title
        self.task?.taskdescription = description
        self.task?.dueDate = dueDate
        self.task?.lastEdited = Date.now
        
        refreshView()
    }
    
    func updateTask(_ task: TaskItem, indexPath: IndexPath?) {
        print("Update task")
        delegate?.updateTask(task, indexPath: indexPath)
        self.task = task
        self.task?.lastEdited = Date.now
        
        refreshView()
    }
    
//    func updateTask(_ task: TodoTask, indexPath: IndexPath?) {
//        delegate?.updateTask(task, indexPath: indexPath)
//        self.task = task
//        
//        refreshView()
//    }
}
