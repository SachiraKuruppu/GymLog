//
//  WorkoutsViewModel.swift
//  GymLog
//
//  Created by Sachira Kuruppu on 1/05/22.
//

import Foundation

final class WorkoutsViewModel: ObservableObject {
    private var model: WorkoutModel?
    
    @Published var workouts: [WorkoutItem] = []
    
    func setup(model: WorkoutModel) {
        self.model = model
    }
    
    func onAppear() {
        self.model?.getAllWorkouts { workouts in
            self.workouts = workouts
        }
    }
}
