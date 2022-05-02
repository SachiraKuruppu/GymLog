//
//  GymLogApp.swift
//  GymLog
//
//  Created by Sachira Kuruppu on 1/05/22.
//

import SwiftUI

@main
struct GymLogApp: App {
    @ObservedObject var model = WorkoutModel()
    
    init() {
        WatchService.shared.setModel(model)
    }
    
    var body: some Scene {
        WindowGroup {
            WorkoutsView()
                .environmentObject(model)
        }
    }
}
