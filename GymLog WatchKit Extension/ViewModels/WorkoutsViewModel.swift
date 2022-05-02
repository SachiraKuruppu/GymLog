//
//  WorkoutsViewModel.swift
//  GymLog
//
//  Created by Sachira Kuruppu on 1/05/22.
//

import Foundation
import Combine

final class WorkoutsViewModel: ObservableObject {
    private var cancellable: AnyCancellable?
    
    @Published var reachabilityText: String = "Not Reachable"
    @Published var workouts: [String] = []
    @Published var isLoading: Bool = false
    
    init() {
        cancellable = PhoneService.shared.$status
            .receive(on: DispatchQueue.main)
            .sink { receiveValue in
                self.reachabilityText = receiveValue
            }
    }
    
    func refreshWorkoutsList() {
        isLoading = true
        
        PhoneService.shared.requestWorkoutsList { workoutNames in
            DispatchQueue.main.async {
                self.workouts = workoutNames
                self.isLoading = false
            }
        }
    }
}
