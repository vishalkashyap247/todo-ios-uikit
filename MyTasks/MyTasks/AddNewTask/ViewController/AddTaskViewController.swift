//
//  AddTaskViewController.swift
//  MyTasks
//
//  Created by Vishal Kashyap on 02/07/24.
//

import UIKit

protocol TaskDelegate: AnyObject {
    func addTask(title: String, description: String, dueDate: Date)
    func updateTask(_ task: TaskItem, indexPath: IndexPath?)
}

class AddTaskViewController: UIViewController {
    var task: TaskItem?
    var indexPath: IndexPath?
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var taskDescription: UITextView!
    
    @IBOutlet weak var button: UIButton!
    var delegate: TaskDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupview()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if let task = task {
            task.title = taskTitle.text ?? ""
            task.taskdescription = taskDescription.text ?? ""
            task.dueDate = datePicker.date
            delegate?.updateTask(task, indexPath: indexPath)
            self.dismiss(animated: true)
        } else {
            delegate?.addTask(title: taskTitle.text ?? "", description: taskDescription.text ?? "", dueDate: datePicker.date)
            self.dismiss(animated: true)
        }
        
//        dismiss(animated: true, completion: nil)
//        guard let title = taskTitle.text, !title.isEmpty else { return }
//        let description = taskDescription.text
//        print("date pcker date = \(datePicker.date)")
//        let newTask = TodoTask(title: title, description: description, dueDate: datePicker.date)
//        
//        delegate?.addTask(newTask)
//        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupview() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.containerView.layer.cornerRadius = 10
        self.containerView.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.backgroundView.addGestureRecognizer(tapGesture)
        
        taskTitle.layer.borderColor = UIColor.lightGray.cgColor
        taskTitle.layer.borderWidth = 1.0
        taskTitle.layer.cornerRadius = 8.0
        
        taskDescription.layer.borderColor = UIColor.lightGray.cgColor
        taskDescription.layer.borderWidth = 1.0
        taskDescription.layer.cornerRadius = 8.0
        
        if let task = task {
            taskTitle.text = task.title
            taskDescription.text = task.taskdescription
            if let date = task.dueDate {
                datePicker.date = date
            }
            button.setTitle("Update task", for: .normal)
        } else {
            button.setTitle("Add new task", for: .normal)
        }
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @objc func handleTap() {
        self.dismiss(animated: true)
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
