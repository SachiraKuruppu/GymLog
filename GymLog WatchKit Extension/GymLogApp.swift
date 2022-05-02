//
//  GymLogApp.swift
//  GymLog WatchKit Extension
//
//  Created by Sachira Kuruppu on 1/05/22.
//

import SwiftUI

@main
struct GymLogApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                WorkoutsView()
            }
        }
    }
}
