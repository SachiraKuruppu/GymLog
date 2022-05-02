//
//  EditWorkoutViewModel.swift
//  GymLog
//
//  Created by Sachira Kuruppu on 1/05/22.
//

import Foundation

final class EditWorkoutViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var restInSeconds: String = "0"
    @Published var exercises: [ExerciseItem] = []
    
    private var model: WorkoutModel?
    private var index: Int?
    
    func setup(model: WorkoutModel, index: Int?) {
        self.model = model
        self.index = index
    }
    
    func onAppear() {
        if let index = self.index, let model = self.model {
            name = model.workouts[index].name
            restInSeconds = "\(model.workouts[index].restInSeconds)"
            exercises = model.workouts[index].exercises
        }
    }
    
    func onSave() {
        guard let model = self.model, let restInt = Int(restInSeconds) else {
            return
        }
        
        // Add new workout
        let w = WorkoutItem(name: name, restInSeconds: restInt, exercises: exercises)
        model.add(newWorkout: w)
        model.save()
    }
    
    func onAdd(name: String, reps: Int) {
        if (name == "" || reps == 0) {
            return
        }
        
        exercises.append(ExerciseItem(name: name, reps: reps, weight: 0))
    }
}
