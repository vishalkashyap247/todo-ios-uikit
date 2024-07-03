//
//  TaskItem+CoreDataProperties.swift
//  MyTasks
//
//  Created by Vishal Kashyap on 03/07/24.
//
//

import Foundation
import CoreData


extension TaskItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskItem> {
        return NSFetchRequest<TaskItem>(entityName: "TaskItem")
    }

    @NSManaged public var title: String?
    @NSManaged public var taskdescription: String?
    @NSManaged public var dueDate: Date?
    @NSManaged public var createdDate: Date?
    @NSManaged public var lastEdited: Date?

}

extension TaskItem : Identifiable {

}
