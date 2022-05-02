//
//  WorkoutModel.swift
//  GymLog
//
//  Created by Sachira Kuruppu on 1/05/22.
//

import Foundation

final class WorkoutModel: ObservableObject {
    let repository: WorkoutRepositoryProtocol
    
    @Published var workouts: [WorkoutItem] = []
    
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
    
    func add(newWorkout: WorkoutItem) {
        self.repository.addWorkout(workout: newWorkout)
        self.workouts.append(newWorkout)
    }
    
    func update(index: Int, newWorkoutItem: WorkoutItem) {
        
    }
    
    func moveWorkout(at: Int, to: Int) {
        let workout = self.workouts.remove(at: at)
        self.workouts.insert(workout, at: to)
    }
    
    func renameWorkout(at: Int, toName: String) {
        self.workouts[at].name = toName
    }
}
