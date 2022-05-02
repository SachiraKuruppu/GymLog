//
//  Exercises+CoreDataProperties.swift
//  GymLog WatchKit Extension
//
//  Created by Sachira Kuruppu on 2/05/22.
//
//

import Foundation
import CoreData


extension Exercises {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercises> {
        return NSFetchRequest<Exercises>(entityName: "Exercises")
    }

    @NSManaged public var ex_name: String?
    @NSManaged public var reps: Int16
    @NSManaged public var weight: Float
    @NSManaged public var weights: NSOrderedSet?
    @NSManaged public var workout: Workouts?

}

// MARK: Generated accessors for weights
extension Exercises {

    @objc(insertObject:inWeightsAtIndex:)
    @NSManaged public func insertIntoWeights(_ value: Weights, at idx: Int)

    @objc(removeObjectFromWeightsAtIndex:)
    @NSManaged public func removeFromWeights(at idx: Int)

    @objc(insertWeights:atIndexes:)
    @NSManaged public func insertIntoWeights(_ values: [Weights], at indexes: NSIndexSet)

    @objc(removeWeightsAtIndexes:)
    @NSManaged public func removeFromWeights(at indexes: NSIndexSet)

    @objc(replaceObjectInWeightsAtIndex:withObject:)
    @NSManaged public func replaceWeights(at idx: Int, with value: Weights)

    @objc(replaceWeightsAtIndexes:withWeights:)
    @NSManaged public func replaceWeights(at indexes: NSIndexSet, with values: [Weights])

    @objc(addWeightsObject:)
    @NSManaged public func addToWeights(_ value: Weights)

    @objc(removeWeightsObject:)
    @NSManaged public func removeFromWeights(_ value: Weights)

    @objc(addWeights:)
    @NSManaged public func addToWeights(_ values: NSOrderedSet)

    @objc(removeWeights:)
    @NSManaged public func removeFromWeights(_ values: NSOrderedSet)

}

extension Exercises : Identifiable {

}
