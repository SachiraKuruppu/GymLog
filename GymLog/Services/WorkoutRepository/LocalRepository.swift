//
//  WorkoutRepository.swift
//  GymLog
//
//  Created by Sachira Kuruppu on 1/05/22.
//

import Foundation
import CoreData
import SwiftUI

final class FakeRepository: WorkoutRepositoryProtocol {
    let workouts: [WorkoutItem] = [
        WorkoutItem(id: "0", name: "Push workout", restInSeconds: 120, exercises: []),
        WorkoutItem(id: "1", name: "Pull workout", restInSeconds: 120, exercises: []),
        WorkoutItem(id: "2", name: "Legs workout", restInSeconds: 120, exercises: [])
    ]
    
    func fetchWorkoutList() -> [WorkoutItem] {
        return workouts
    }
    
    func addWorkout(workout: WorkoutItem) {
        return
    }
    
    func updateWorkout(workout: WorkoutItem) {
        return
    }
    
    func save() {
        return
    }
    
    func fetchAllExerciseNames() -> [String] {
        return ["Bench Press", "Squats", "Leg Press", "Tricep Extensions"]
    }
    
    func fetchAllWeights(for exerciseName: String) -> [WeightItem] {
        let timeDiff: TimeInterval = 24 * 60 * 60
        
        return [
            WeightItem(id: UUID().uuidString, exerciseName: "Bench Press", datetime: Date() - timeDiff * 5, weight: 10),
            WeightItem(id: UUID().uuidString, exerciseName: "Bench Press", datetime: Date() - timeDiff * 4, weight: 20),
            WeightItem(id: UUID().uuidString, exerciseName: "Bench Press", datetime: Date() - timeDiff * 3, weight: 30),
            WeightItem(id: UUID().uuidString, exerciseName: "Bench Press", datetime: Date() - timeDiff * 2, weight: 40),
            WeightItem(id: UUID().uuidString, exerciseName: "Bench Press", datetime: Date() - timeDiff * 1, weight: 50)
        ]
    }
    
    func addWeight(_ weight: WeightItem) -> Void {
        return
    }
}

final class LocalRepository: WorkoutRepositoryProtocol {
    let container = NSPersistentContainer(name: "WorkoutDB")
    
    init() {
        container.loadPersistentStores { description, error in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            if let error = error {
                fatalError("Core data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchWorkoutList() -> [WorkoutItem] {
        let request: NSFetchRequest<Workouts> = Workouts.fetchRequest()
        do {
            let workouts: [Workouts] = try container.viewContext.fetch(request)
            let workoutItems = workouts.map { w in
                WorkoutItem(
                    id: w.id!.uuidString,
                    name: w.name!,
                    restInSeconds: w.rest_time_sec as! Int,
                    exercises: fetchExercises(workout: w)
                )
            }
            return workoutItems
        } catch {
            print("Error fetching the workouts")
        }
        
        return []
    }
    
    func fetchExercises(workout: Workouts) -> [ExerciseItem] {
        var exerciseItems: [ExerciseItem] = []
        
        guard let exercises = workout.exercises else {
            return exerciseItems
        }
        
        for e in exercises.array as! [Exercises] {
            guard
                let ex_id = e.ex_id,
                let ex_name = e.ex_name
            else {
                continue
            }
            
            exerciseItems.append(ExerciseItem(id: ex_id.uuidString, name: ex_name, reps: Int(e.reps), weight: e.weight))
        }
        
        return exerciseItems
    }
    
    func addWorkout(workout: WorkoutItem) {
        let w = Workouts(context: container.viewContext)
        w.id = UUID(uuidString: workout.id)
        w.name = workout.name
        w.rest_time_sec = NSDecimalNumber(value: workout.restInSeconds)
        
        for exercise in workout.exercises {
            let e = Exercises(context: container.viewContext)
            e.ex_id = UUID(uuidString: exercise.id)
            e.ex_name = exercise.name
            e.reps = Int16(exercise.reps)
            e.weight = exercise.weight
            w.addToExercises(e)
        }
    }
    
    func updateWorkout(workout: WorkoutItem) {
        self.addWorkout(workout: workout)
    }
    
    func removeWorkout(workoutName: String, completion: () -> Void) {
        // Remove the workout with the name from the coredata
    }
    
    func save() {
        try! container.viewContext.save()
    }
    
    func fetchAllExerciseNames() -> [String] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercises")
        request.propertiesToFetch = ["ex_name"]
        request.propertiesToGroupBy = ["ex_name"]
        request.sortDescriptors = [NSSortDescriptor(key: "ex_name", ascending: true)]
        request.resultType = .dictionaryResultType
        
        do {
            let results = try container.viewContext.fetch(request) as! [[String: String]]
            return results.map { $0["ex_name"]! }
        } catch {
            print("Error fetching the exercise names")
        }
        
        return []
    }
    
    func fetchAllWeights(for exerciseName: String) -> [WeightItem] {
        let request: NSFetchRequest<Weights> = Weights.fetchRequest()
        request.predicate = NSPredicate(format: "ex_name = %@", exerciseName)
        request.sortDescriptors = [NSSortDescriptor(key: "datetime", ascending: true)]
        
        do {
            let weights: [Weights] = try container.viewContext.fetch(request)
            let weightItems = weights.map { w in
                WeightItem(
                    id: exerciseName + w.datetime!.formatted(),
                    exerciseName: exerciseName,
                    datetime: w.datetime!,
                    weight: w.weight
                )
            }
            return weightItems
        } catch {
            print("Error fetching the weights")
        }
        
        return []
    }
    
    func addWeight(_ weight: WeightItem) -> Void {
        let w = Weights(context: container.viewContext)
        w.ex_name = weight.exerciseName
        w.datetime = weight.datetime
        w.weight = weight.weight
    }
}
