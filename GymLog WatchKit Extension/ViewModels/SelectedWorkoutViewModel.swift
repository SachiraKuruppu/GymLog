//
//  SelectedWorkoutViewModel.swift
//  GymLog WatchKit Extension
//
//  Created by Sachira Kuruppu on 1/05/22.
//

import Foundation
import Combine

final class SelectedWorkoutViewModel: ObservableObject {
    private var cancellable: Set<AnyCancellable> = []
    
    enum Tab {
        case WORKOUT_VIEW
        case EXERCISE_VIEW
    }
    
    var startDate: Date = Date()
    
    @Published var isLoading: Bool = false
    @Published var selectedTab: Tab = Tab.WORKOUT_VIEW
    @Published var isRunning = false
    
    @Published var name: String = "Fake Workout"
    @Published var restInSeconds: Int = 60
    @Published var exercises: [ExerciseItem] = []
    @Published var showRestTimer: Bool = false
    
    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0
    
    @Published var selectedExerciseIndx: Int = 0
    @Published var weight: Float = 0
    @Published var reps: Int = 1
    
    init() {
        WorkoutService.shared.$isRunning
            .receive(on: DispatchQueue.main)
            .sink { newVal in
                self.isRunning = newVal
            }
            .store(in: &cancellable)
        
        WorkoutService.shared.$heartRate
            .receive(on: DispatchQueue.main)
            .sink { newVal in
                self.heartRate = newVal
            }
            .store(in: &cancellable)
        
        WorkoutService.shared.$activeEnergy
            .receive(on: DispatchQueue.main)
            .sink { newVal in
                self.activeEnergy = newVal
            }
            .store(in: &cancellable)
    }
    
    func requestDetails(workoutIndex: Int) {
        isLoading = true
        
        PhoneService.shared.requestWorkout(index: workoutIndex) { workout in
            DispatchQueue.main.async {
                self.name = workout.name
                self.restInSeconds = workout.restInSeconds
                self.exercises = workout.exercises
                self.isLoading = false
                
                WorkoutService.shared.startWorkout()
                self.startDate = WorkoutService.shared.getBuilderStart()
            }
        }
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
            showRestTimer = true
        }
        else {
            selectedTab = .WORKOUT_VIEW
        }
    }
    
    func getElapsedTime() -> Double {
        return WorkoutService.shared.getElapsedTime()
    }
    
    func onPausePressed() {
        if isRunning {
            WorkoutService.shared.pause()
        }
        else {
            WorkoutService.shared.resume()
        }
    }
    
    func onEndPressed(workoutIndex: Int) {
        isLoading = true
        WorkoutService.shared.endWorkout()
        
        PhoneService.shared.requestSaveWorkout(
            index: workoutIndex,
            workout: WorkoutItem(name: name, restInSeconds: restInSeconds, exercises: exercises)
        )
    }
}
