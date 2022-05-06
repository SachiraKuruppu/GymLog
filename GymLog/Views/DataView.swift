//
//  ExercisesView.swift
//  GymLog
//
//  Created by Sachira Kuruppu on 6/05/22.
//

import SwiftUI

struct DataView: View {
    @EnvironmentObject var model: WorkoutModel
    @StateObject private var viewModel: DataViewModel = DataViewModel()
    
    var body: some View {
        TabView(selection: $viewModel.currentTab) {
            
            VStack {
                Text("Exercises")
                    .font(.title)
                List {
                    
                    ForEach(0..<viewModel.exerciseNames.count, id:\.self) { i in
                        Button {
                            viewModel.onExerciseSelected(index: i)
                        } label: {
                            if viewModel.selectedExerciseIndex == i {
                                Label(viewModel.exerciseNames[i], systemImage: "checkmark.circle.fill")
                            }
                            else {
                                Label(viewModel.exerciseNames[i], systemImage: "")
                            }
                        }
                    }
                }
            }
            .tabItem { Text("Exercises") }
            .tag(DataViewModel.Tab.EXERCISE_NAMES_TAB)
            
            VStack {
                Text(viewModel.selectedExerciseName)
                    .font(.title)
                
                List {
                    
                    ForEach(0..<viewModel.selectedExerciseWeights.count, id:\.self) { i in
                        HStack {
                            Text("\(viewModel.selectedExerciseWeights[i].weight, specifier: "%g") kg")
                            Spacer()
                            Text(viewModel.selectedExerciseWeights[i].datetime.formatted())
                                .font(.caption)
                        }
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 0,
                            maxHeight: .infinity,
                            alignment: .leading
                        )
                    }
                }
            }
            .tabItem { Text("Charts") }
            .tag(DataViewModel.Tab.CHART_TAB)
        }
        .onAppear() {
            viewModel.setup(model: model)
            viewModel.onAppear()
        }
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView()
            .environmentObject(WorkoutModel(repository: FakeRepository()))
    }
}
