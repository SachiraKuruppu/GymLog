//
//  SelectedWorkoutView.swift
//  GymLog WatchKit Extension
//
//  Created by Sachira Kuruppu on 1/05/22.
//

import SwiftUI

struct SelectedWorkoutView: View {
    var workoutIndex: Int
    
    @Environment(\.dismiss) private var dismiss
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
                            viewModel.onEndPressed(workoutIndex: workoutIndex)
                            dismiss()
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
                    TimelineView(
                        ElapsedTimerSchedule(from: viewModel.startDate)
                    ) { context in
                        TimerSubView(
                            elapsedTime: viewModel.getElapsedTime(),
                            showSubseconds: context.cadence == .live
                        )
                        .font(.title3)
                    }
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
                        
                        SelectorSubView(from: 0, to: 100, by: 1.25, label: " kg", selection: $viewModel.weight)
                        .frame(width: 80, height: 50, alignment: .center)
                        SelectorSubView(from: 0, to: 20, by: 1, label: "", selection: $viewModel.reps)
                        .frame(width: 80, height: 50, alignment: .center)
                    }
                    Button {
                        viewModel.markDone()
                    } label: {
                        Image(systemName: "forward.frame")
                    }
                    .tint(Color.blue)
                }
                .tag(SelectedWorkoutViewModel.Tab.EXERCISE_VIEW)
                .tabItem {
                    Text("Exercise")
                }
            }
            
            if viewModel.showRestTimer {
                RestTimeView(restTimeInSeconds: viewModel.restInSeconds) {
                    viewModel.showRestTimer = false
                    WKInterfaceDevice.current().play(.success)
                }
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .background(.black)
            }
        }
        .onAppear {
            guard workoutIndex >= 0 else {
                return
            }
            viewModel.requestDetails(workoutIndex: workoutIndex)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct SelectedWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedWorkoutView(workoutIndex: -1)
    }
}

private struct ElapsedTimerSchedule: TimelineSchedule {
    var startDate: Date
    
    init(from startDate: Date) {
        self.startDate = startDate
    }
    
    func entries(from startDate: Date, mode: TimelineScheduleMode) -> PeriodicTimelineSchedule.Entries {
        PeriodicTimelineSchedule(
            from: self.startDate,
            by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0)
        ).entries(
            from: startDate,
            mode: mode
        )
    }
}
