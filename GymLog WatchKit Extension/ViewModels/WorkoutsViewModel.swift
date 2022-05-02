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
    private var cancellable_2: AnyCancellable?
    
    @Published var reachabilityText: String = "Not Reachable"
    @Published var workouts: [String] = []
    
    init() {
        cancellable = PhoneService.shared.$status
            .receive(on: DispatchQueue.main)
            .sink { receiveValue in
                self.reachabilityText = receiveValue
            }
        
        cancellable_2 = PhoneService.shared.$workoutNames
            .receive(on: DispatchQueue.main)
            .sink { receivedValue in
                self.workouts = receivedValue
            }
    }
    
    func refreshWorkoutsList() {
        PhoneService.shared.requestWorkoutsList()
    }
}
