//
//  ToDoListItems+CoreDataProperties.swift
//  CoreDataExample
//
//  Created by Noor Mohammed Anik on 14/8/21.
//
//

import Foundation
import CoreData


extension ToDoListItems {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItems> {
        return NSFetchRequest<ToDoListItems>(entityName: "ToDoListItems")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?

}

extension ToDoListItems : Identifiable {

}
