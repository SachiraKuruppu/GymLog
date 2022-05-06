//
//  WorkoutModel.swift
//  GymLog
//
//  Created by Sachira Kuruppu on 1/05/22.
//

import Foundation

final class WorkoutModel: ObservableObject {
    let repository: WorkoutRepositoryProtocol
    
    //@Published
    var workouts: [WorkoutItem] = []
    
    init(repository: WorkoutRepositoryProtocol = LocalRepository()) {
        self.repository = repository
        getAllWorkouts { workouts in
            self.workouts = workouts
        }
    }
    
    func save() {
        self.repository.save()
    }
    
    func getAllWorkouts(completion: ([WorkoutItem]) -> Void) {
        self.workouts = self.repository.fetchWorkoutList()
        completion(self.workouts)
    }
    
    func getAllExerciseNames(completion: ([String]) -> Void) {
        let exerciseNames = self.repository.fetchAllExerciseNames()
        completion(exerciseNames)
    }
    
    func add(newWorkout: WorkoutItem) {
        self.repository.addWorkout(workout: newWorkout)
        self.workouts.append(newWorkout)
    }
    
    func update(index: Int, newWorkoutItem: WorkoutItem) {
        self.workouts[index] = newWorkoutItem
        self.repository.updateWorkout(workout: newWorkoutItem)
        self.save()
    }
    
    func moveWorkout(at: Int, to: Int) {
        let workout = self.workouts.remove(at: at)
        self.workouts.insert(workout, at: to)
    }
    
    func renameWorkout(at: Int, toName: String) {
        self.workouts[at].name = toName
    }
    
    func getAllWeights(for exerciseName: String, completion: ([WeightItem]) -> Void) {
        let weights = self.repository.fetchAllWeights(for: exerciseName)
        completion(weights)
    }
    
    func recordWeights(for workout: WorkoutItem) {
        let datetime = Date()
        
        let minWeightsOfExercises = workout.exercises.reduce(into: [String: WeightItem]()) { dict, exercise in
            guard exercise.completed == true else {
                return
            }
            
            guard let existingWeightItem = dict[exercise.name] else {
                dict[exercise.name] = WeightItem(
                    id: UUID().uuidString,
                    exerciseName: exercise.name,
                    datetime: datetime,
                    weight: exercise.weight
                )
                return
            }
            
            if existingWeightItem.weight > exercise.weight {
                dict[exercise.name]?.weight = exercise.weight
            }
        }
        
        for (_, weightItem) in minWeightsOfExercises {
            self.repository.addWeight(weightItem)
        }
        
        self.save()
    }
}
