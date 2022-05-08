//
//  WorkoutsView.swift
//  GymLog WatchKit Extension
//
//  Created by Sachira Kuruppu on 1/05/22.
//

import SwiftUI

struct WorkoutsView: View {
    @StateObject private var viewModel = WorkoutsViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Text(viewModel.reachabilityText)
                    .font(.footnote)
                Spacer()
                List {
                    
                    if viewModel.workouts.count > 0 {
                        ForEach(0..<viewModel.workouts.count, id:\.self) { i in
                            NavigationLink(destination: SelectedWorkoutView(workoutIndex: i)) {
                                Text(viewModel.workouts[i])
                            }
                        }
                    }
                    else {
                        Text("No workouts found")
                    }
                    
                    Button("Refresh") {
                        viewModel.refreshWorkoutsList()
                    }
                }
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .background(.black)
            }
        }
        .onAppear {
            viewModel.refreshWorkoutsList()
            WorkoutService.shared.requestHealthKitAccess()
        }
    }
}

struct WorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView()
    }
}
