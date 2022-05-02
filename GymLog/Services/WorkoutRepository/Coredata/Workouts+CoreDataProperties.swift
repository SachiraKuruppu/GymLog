//
//  Workouts+CoreDataProperties.swift
//  GymLog WatchKit Extension
//
//  Created by Sachira Kuruppu on 2/05/22.
//
//

import Foundation
import CoreData


extension Workouts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workouts> {
        return NSFetchRequest<Workouts>(entityName: "Workouts")
    }

    @NSManaged public var name: String?
    @NSManaged public var rest_time_sec: NSDecimalNumber?
    @NSManaged public var exercises: NSOrderedSet?

}

// MARK: Generated accessors for exercises
extension Workouts {

    @objc(insertObject:inExercisesAtIndex:)
    @NSManaged public func insertIntoExercises(_ value: Exercises, at idx: Int)

    @objc(removeObjectFromExercisesAtIndex:)
    @NSManaged public func removeFromExercises(at idx: Int)

    @objc(insertExercises:atIndexes:)
    @NSManaged public func insertIntoExercises(_ values: [Exercises], at indexes: NSIndexSet)

    @objc(removeExercisesAtIndexes:)
    @NSManaged public func removeFromExercises(at indexes: NSIndexSet)

    @objc(replaceObjectInExercisesAtIndex:withObject:)
    @NSManaged public func replaceExercises(at idx: Int, with value: Exercises)

    @objc(replaceExercisesAtIndexes:withExercises:)
    @NSManaged public func replaceExercises(at indexes: NSIndexSet, with values: [Exercises])

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: Exercises)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: Exercises)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSOrderedSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSOrderedSet)

}

extension Workouts : Identifiable {

}
