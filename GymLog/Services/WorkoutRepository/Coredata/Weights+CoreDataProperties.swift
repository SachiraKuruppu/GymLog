//
//  Weights+CoreDataProperties.swift
//  GymLog
//
//  Created by Sachira Kuruppu on 4/05/22.
//
//

import Foundation
import CoreData


extension Weights {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weights> {
        return NSFetchRequest<Weights>(entityName: "Weights")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var weight: NSDecimalNumber?
    @NSManaged public var exercise: Exercises?

}

extension Weights : Identifiable {

}
