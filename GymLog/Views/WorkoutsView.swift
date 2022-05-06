//
//  WorkoutsView.swift
//  GymLog
//
//  Created by Sachira Kuruppu on 1/05/22.
//

import SwiftUI

struct WorkoutsView: View {
    @EnvironmentObject var model: WorkoutModel
    @StateObject private var viewModel: WorkoutsViewModel = WorkoutsViewModel()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10.0) {
                Text("Workouts")
                    .font(.largeTitle)
                    .padding()
                
                List {
                    ForEach(0..<viewModel.workouts.count, id:\.self) { i in
                        NavigationLink(destination: EditWorkoutView(index: i)){
                            Text(viewModel.workouts[i].name)
                        }
                    }
                }
                
                HStack {
                    NavigationLink(destination: DataView()){
                        Text("Weights")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    
                    NavigationLink(destination: EditWorkoutView()){
                        Text("Add New Workout")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
            }
            .onAppear{
                viewModel.setup(model: model)
                viewModel.onAppear()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct WorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView()
            .environmentObject(WorkoutModel(repository: FakeRepository()))
    }
}
