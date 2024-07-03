//
//  ViewController.swift
//  MyTasks
//
//  Created by Vishal Kashyap on 02/07/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var data = [TodoTask]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var models = [TaskItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View loaded.")
        // Do any additional setup after loading the view.
        self.title = "MyList"
        let nib = UINib(nibName: "TaskTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "TaskTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        data.append(TodoTask(title: "Task 1", description: "Description 1", dueDate: Date.now))
        data.append(TodoTask(title: "Task 2", description: "Description 2", dueDate: Date.now))
        data.append(TodoTask(title: "Task 3", description: "Description 3", dueDate: Date.now))
        
        getAllTasks()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func addTaskButtonTapped(_ sender: UIButton) {
        // Handle add task button tap
        print("Add new task button tapped.")
        let addTaskVC = AddTaskViewController()
        addTaskVC.delegate = self
        addTaskVC.modalPresentationStyle = .overFullScreen
        present(addTaskVC, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        cell.setup(with: model, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = models[indexPath.row]
            models.remove(at: indexPath.row)
            deleteTask(task: taskToDelete)
        }
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let taskDetailVC = TaskDetailViewController()
        taskDetailVC.indexPath = indexPath
        taskDetailVC.task = models[indexPath.row]
        taskDetailVC.taskList = data
        taskDetailVC.delegate = self
        navigationController?.pushViewController(taskDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Handle search text change
        getAllTasks(with: searchText)
    }
}

extension ViewController: TaskDelegate {
    func addTask(title: String, description: String, dueDate: Date) {
        createTask(title: title, description: description, dueDate: dueDate)
        tableView.reloadData()
    }
    
    func updateTask(_ task: TodoTask, indexPath: IndexPath?) {
        //        print("Update the task. \(task.title) \(indexPath)")
        guard let indexPath = indexPath else { return }
        var updatedTask = task
        updatedTask.lastEditDate = Date.now
        data[indexPath.item] = updatedTask
    }
    
    func updateTask(_ task: TaskItem, indexPath: IndexPath?) {
        //        print("Update the task. \(task.title) \(indexPath)")
        //        guard let indexPath = indexPath else { return }
        //        var updatedTask = task
        //        updatedTask.lastEditDate = Date.now
        //        data[indexPath.item] = updatedTask
        updateTask(task: task, newTask: task)
        
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: CORE DATA
extension ViewController {
    // Will lated change for search bar
    func getAllTasks(with: String? = nil) {
//        do {
//            models = try context.fetch(TaskItem.fetchRequest())
//            tableView.reloadData()
//        } catch {
//            
//        }
        
        let fetchRequest: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
        
        if let searchText = with, !searchText.isEmpty {
            let predicate = NSPredicate(format: "title CONTAINS[c] %@", searchText)
            fetchRequest.predicate = predicate
        }
        
        do {
            models = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Error while fetching task.")
        }
    }
    
    func createTask(title: String, description: String, dueDate: Date) {
        let newTask = TaskItem(context: context)
        newTask.title = title
        newTask.taskdescription = description
        newTask.dueDate = dueDate
        newTask.createdDate = Date.now

        do {
            try context.save()
            scheduleNotification(for: newTask)
            getAllTasks()
        } catch {
            print("Error while creating task.")
        }
    }

    func scheduleNotification(for task: TaskItem) {
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = "Task title: \(task.title ?? "")"
        content.sound = UNNotificationSound.default

        guard let dueDate = task.dueDate else { return }
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: task.objectID.uriRepresentation().absoluteString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error while scheduling notification with ::: \(error)")
            }
        }
    }
    func updateTask(task: TaskItem, newTask: TaskItem) {
        task.title = newTask.title
        task.taskdescription = newTask.taskdescription
        task.dueDate = newTask.dueDate

        do {
            try context.save()
            scheduleNotification(for: task)
            tableView.reloadData()
        } catch {
            print("Error while updating task.")
        }
    }

    func deleteTask(task: TaskItem) {
        context.delete(task)
        
        let requestIdentifier = task.objectID.uriRepresentation().absoluteString
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [requestIdentifier])

        do {
            try context.save()
            getAllTasks()
        } catch {
            print("Error while deleting task.")
        }
    }
}
