//
//  SelectedWorkoutView.swift
//  GymLog WatchKit Extension
//
//  Created by Sachira Kuruppu on 1/05/22.
//

import SwiftUI

struct SelectedWorkoutView: View {
    var workoutIndex: Int?
    
    @StateObject private var viewModel: SelectedWorkoutViewModel = SelectedWorkoutViewModel()
    @FocusState private var weightFocused: Bool
    @FocusState private var repsFocused: Bool
    
    var body: some View {
        ZStack {
            TabView(selection: $viewModel.selectedTab) {
                // Tab 1: Exercise list view
                ScrollView {
                    Text(viewModel.name)
                    Text("(rest \(viewModel.restInSeconds) s)")
                        .font(.footnote)
                    Spacer()
                    
                    ForEach(0..<viewModel.exercises.count, id:\.self) { i in
                        Button {
                            viewModel.selectExercise(index: i)
                            viewModel.selectedTab = .EXERCISE_VIEW
                        } label: {
                            viewModel.exercises[i].completed ?
                            Label(viewModel.exercises[i].name, systemImage: "checkmark.circle.fill") :
                            Label(viewModel.exercises[i].name, systemImage: "circle")
                        }
                        .background(viewModel.selectedExerciseIndx == i ? .blue : .black)
                    }
                    
                    HStack {
                        Button {
                            viewModel.onEndPressed()
                        } label: {
                            Image(systemName: "xmark")
                        }
                        .tint(Color.red)
                        
                        Button {
                            viewModel.onPausePressed()
                        } label: {
                            Image(systemName: viewModel.isRunning ? "pause" : "play")
                        }
                        .tint(viewModel.isRunning ? Color.yellow : Color.green)
                    }
                }
                .tabItem {
                    Text("List")
                }
                .tag(SelectedWorkoutViewModel.Tab.WORKOUT_VIEW)
                
                // Tab 2: Selected exercise view
                ScrollView {
                    TimerSubView(
                            elapsedTime: WorkoutService.shared.builder?.elapsedTime ?? 0,
                            showSubseconds: true
                        )
                        .font(.title3)
                    HStack {
                        Text(
                            Measurement(value: viewModel.activeEnergy, unit: UnitEnergy.kilocalories)
                                .formatted(
                                    .measurement(
                                        width: .abbreviated,
                                        usage: .workout
                                    )
                                )
                            )
                            .fontWeight(.bold)
                            .frame(width: 80, height: 30, alignment: .center)
                            .padding()
                            .foregroundColor(.pink)
                        
                        Label(
                                viewModel.heartRate.formatted(.number.precision(.fractionLength(0))),
                                systemImage: "heart"
                            )
                            .frame(width: 80, height: 30, alignment: .center)
                            .padding()
                            .foregroundColor(.yellow)
                            .font(.body.weight(.bold))
                    }
                    HStack {
                        Text("\(viewModel.weight, specifier: "%.2f") kg")
                            .frame(width: 80, height: 30, alignment: .center)
                            .focusable()
                            .focused($weightFocused)
                            .digitalCrownRotation($viewModel.weight, from: 0, through: .infinity, by: 1.25)
                            .padding()
                            .border(weightFocused ? .primary : .secondary, width: 2)
                        Text("\(viewModel.reps)")
                            .frame(width: 80, height: 30, alignment: .center)
                            .focusable()
                            .focused($repsFocused)
                            .digitalCrownRotation($viewModel.weight, from: 0, through: .infinity, by: 1)
                            .padding()
                            .border(repsFocused ? .primary : .secondary, width: 2)
                    }
                    Button("Done") {
                        viewModel.markDone()
                    }
                    .tint(Color.blue)
                }
                .tag(SelectedWorkoutViewModel.Tab.EXERCISE_VIEW)
                .tabItem {
                    Text("Exercise")
                }
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .background(.black)
            }
        }
        .onAppear {
            guard let index = workoutIndex else {
                return
            }
            
            viewModel.requestDetails(workoutIndex: index)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct SelectedWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedWorkoutView()
    }
}
