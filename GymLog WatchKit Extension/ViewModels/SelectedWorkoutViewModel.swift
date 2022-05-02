//
//  SelectedWorkoutViewModel.swift
//  GymLog WatchKit Extension
//
//  Created by Sachira Kuruppu on 1/05/22.
//

import Foundation
import Combine

final class SelectedWorkoutViewModel: ObservableObject {
    private var cancellable: AnyCancellable?
    
    enum Tab {
        case WORKOUT_VIEW
        case EXERCISE_VIEW
    }
    
    @Published var selectedTab: Tab = Tab.WORKOUT_VIEW
    
    @Published var name: String = "Fake Workout"
    @Published var restInSeconds: Int = 60
    @Published var exercises: [ExerciseItem] = []
    
    @Published var selectedExerciseIndx: Int = 0
    @Published var weight: Float = 0
    @Published var reps: Int = 1
    
    init() {
        cancellable = PhoneService.shared.$workout
            .receive(on: DispatchQueue.main)
            .sink { receiveValue in
                guard let workout: WorkoutItem = receiveValue else {
                    return
                }
                
                self.name = workout.name
                self.restInSeconds = workout.restInSeconds
                self.exercises = workout.exercises
            }
    }
    
    func requestDetails(workoutIndex: Int) {
        PhoneService.shared.requestWorkout(index: workoutIndex)
    }
    
    func selectExercise(index: Int) {
        selectedExerciseIndx = index
        reps = exercises[selectedExerciseIndx].reps
        weight = exercises[selectedExerciseIndx].weight
    }
    
    func markDone() {
        exercises[selectedExerciseIndx].reps = reps
        exercises[selectedExerciseIndx].weight = weight
        exercises[selectedExerciseIndx].completed = true
        
        if (selectedExerciseIndx + 1) < exercises.count {
            selectExercise(index: selectedExerciseIndx + 1)
        }
    }
}
