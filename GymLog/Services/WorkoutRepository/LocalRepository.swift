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
        WorkoutItem(name: "Push workout", restInSeconds: 120, exercises: []),
        WorkoutItem(name: "Pull workout", restInSeconds: 120, exercises: []),
        WorkoutItem(name: "Legs workout", restInSeconds: 120, exercises: [])
    ]
    
    func fetchWorkoutList() -> [WorkoutItem] {
        return workouts
    }
    
    func addWorkout(workout: WorkoutItem) {
        return
    }
    
    func save() {
        return
    }
}

final class LocalRepository: WorkoutRepositoryProtocol {
    let container = NSPersistentContainer(name: "WorkoutDB")
    
    init() {
        container.loadPersistentStores { description, error in
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
                    name: w.name ?? "unknown",
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
            exerciseItems.append(ExerciseItem(name: e.ex_name ?? "", reps: Int(e.reps), weight: e.weight))
        }
        
        return exerciseItems
    }
    
    func addWorkout(workout: WorkoutItem) {
        let w = Workouts(context: container.viewContext)
        w.name = workout.name
        w.rest_time_sec = NSDecimalNumber(value: workout.restInSeconds)
        
        for exercise in workout.exercises {
            let e = Exercises(context: container.viewContext)
            e.ex_name = exercise.name
            e.reps = Int16(exercise.reps)
            w.addToExercises(e)
        }
    }
    
    func removeWorkout(workoutName: String, completion: () -> Void) {
        // Remove the workout with the name from the coredata
    }
    
    func addExercise(exercise: ExerciseItem, completion: () -> Void) {
        // Add an exercise to the workout
    }
    
    func addWeight(exerciseName: String, weight: Float, completion: () -> Void) {
        // Add weight to the exercise
    }
    
    func save() {
        try? container.viewContext.save()
    }
}
