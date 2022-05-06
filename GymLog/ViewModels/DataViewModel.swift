//
//  DataViewModel.swift
//  GymLog
//
//  Created by Sachira Kuruppu on 6/05/22.
//

import Foundation

final class DataViewModel: ObservableObject {
    private var model: WorkoutModel?
    
    enum Tab {
        case EXERCISE_NAMES_TAB
        case CHART_TAB
    }
    
    @Published var exerciseNames: [String] = []
    @Published var currentTab: Tab = .EXERCISE_NAMES_TAB
    @Published var selectedExerciseIndex: Int = -1
    @Published var disableChartsTab: Bool = true
    
    @Published var selectedExerciseName: String = "Test Exercise"
    @Published var selectedExerciseWeights: [WeightItem] = []
    
    func setup(model: WorkoutModel) {
        self.model = model
    }
    
    func onAppear() {
        self.model?.getAllExerciseNames { exerciseNames in
            self.exerciseNames = exerciseNames
        }
    }
    
    func onExerciseSelected(index: Int) {
        selectedExerciseIndex = index
        selectedExerciseName = exerciseNames[selectedExerciseIndex]
        
        model?.getAllWeights(for: selectedExerciseName) { weights in
            self.selectedExerciseWeights = weights
        }
        
        if selectedExerciseIndex >= 0 && exerciseNames.count > 0 {
            disableChartsTab = false
        }
        else {
            disableChartsTab = true
        }
        
        currentTab = .CHART_TAB
    }
}
