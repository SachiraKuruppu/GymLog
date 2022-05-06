//
//  Types.swift
//  GymLog
//
//  Created by Sachira Kuruppu on 1/05/22.
//

import Foundation

struct WeightItem: Identifiable {
    let id: String
    
    var exerciseName: String
    var datetime: Date
    var weight: Float
}

struct ExerciseItem: Identifiable {
    let id: String
    
    var name: String
    var reps: Int
    var weight: Float
    
    var completed: Bool = false
    
    func encode() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "reps": reps,
            "weight": weight,
            "completed": completed
        ]
    }
    
    static func decode(encodedExercise: [String: Any]) -> ExerciseItem {
        guard
            let id = encodedExercise["id"] as? String,
            let name = encodedExercise["name"] as? String,
            let reps = encodedExercise["reps"] as? Int,
            let weight = encodedExercise["weight"] as? Float,
            let completed = encodedExercise["completed"] as? Bool
        else {
            fatalError("Unable to decode exercise")
        }
        
        return ExerciseItem(id: id, name: name, reps: reps, weight: weight, completed: completed)
    }
}

struct WorkoutItem: Identifiable {
    let id: String
    
    var name: String
    var restInSeconds: Int
    var exercises: [ExerciseItem]
    
    func encode() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "restInSeconds": restInSeconds,
            "exercises": exercises.map { $0.encode() }
        ]
    }
    
    static func decode(encodedWorkout: [String: Any]) -> WorkoutItem {
        guard
            let id = encodedWorkout["id"] as? String,
            let name = encodedWorkout["name"] as? String,
            let restInSeconds = encodedWorkout["restInSeconds"] as? Int,
            let encodedExercises = encodedWorkout["exercises"] as? [[String: Any]]
        else {
            fatalError("Unable to decode workout")
        }
        
        let exercises = encodedExercises.map{ encodedEx in
            ExerciseItem.decode(encodedExercise: encodedEx)
        }
        
        return WorkoutItem(id: id, name: name, restInSeconds: restInSeconds, exercises: exercises)
    }
}

protocol WorkoutRepositoryProtocol {
    func fetchWorkoutList() -> [WorkoutItem]
    func addWorkout(workout: WorkoutItem) -> Void
    func updateWorkout(workout: WorkoutItem) -> Void
    func save() -> Void
    
    func fetchAllExerciseNames() -> [String]
    func fetchAllWeights(for exerciseName: String) -> [WeightItem]
    func addWeight(_ weight: WeightItem) -> Void
//    func removeWorkout(workoutName: String) -> Void
//    func addWeight(workoutName: String, exerciseName: String, weight: Float) -> Void
}
