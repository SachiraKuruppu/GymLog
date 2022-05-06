//
//  Exercises+CoreDataProperties.swift
//  GymLog
//
//  Created by Sachira Kuruppu on 7/05/22.
//
//

import Foundation
import CoreData


extension Exercises {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercises> {
        return NSFetchRequest<Exercises>(entityName: "Exercises")
    }

    @NSManaged public var ex_id: UUID?
    @NSManaged public var ex_name: String?
    @NSManaged public var reps: Int16
    @NSManaged public var weight: Float
    @NSManaged public var workout: Workouts?

}

extension Exercises : Identifiable {

}
