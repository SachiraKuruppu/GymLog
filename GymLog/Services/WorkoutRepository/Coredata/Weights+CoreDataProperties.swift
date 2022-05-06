//
//  Weights+CoreDataProperties.swift
//  GymLog
//
//  Created by Sachira Kuruppu on 7/05/22.
//
//

import Foundation
import CoreData


extension Weights {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weights> {
        return NSFetchRequest<Weights>(entityName: "Weights")
    }

    @NSManaged public var ex_name: String?
    @NSManaged public var datetime: Date?
    @NSManaged public var weight: Float

}

extension Weights : Identifiable {

}
