//
//  EditWorkoutView.swift
//  GymLog
//
//  Created by Sachira Kuruppu on 1/05/22.
//

import SwiftUI

struct EditWorkoutView: View {
    let index: Int?
    var title: String {
        get {
            if index == nil {
                return "Add New Workout"
            }
            return "Edit Workout"
        }
    }
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var model: WorkoutModel
    @StateObject private var viewModel = EditWorkoutViewModel()
    @State private var newExerciseName = ""
    @State private var newExerciseReps = ""
    
    init(index: Int? = nil) {
        self.index = index
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20.0) {
            Text(title)
                .font(.largeTitle)
                .padding()
            
            HStack{
                Text("Workout name: ")
                TextField("Enter name", text: $viewModel.name)
            }
            HStack {
                Text("Rest time (seconds): ")
                TextField("Enter seconds", text: $viewModel.restInSeconds)
            }
            List {
                ForEach(viewModel.exercises) { exercise in
                    HStack {
                        Text(exercise.name)
                        Text("Reps: \(exercise.reps)")
                    }
                }
                HStack {
                    TextField("Name", text: $newExerciseName)
                    TextField("Reps", text: $newExerciseReps)
                }
                Button("Add exercise") {
                    viewModel.onAdd(name: newExerciseName, reps: Int(newExerciseReps) ?? 0)
                    newExerciseName = ""
                    newExerciseReps = ""
                }
            }
            Button("Save") {
                viewModel.onSave()
                dismiss()
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .onAppear{
            viewModel.setup(model: model, index: index)
            viewModel.onAppear()
        }
    }
}

struct EditWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        EditWorkoutView(index: 0)
            .environmentObject(WorkoutModel(repository: FakeRepository()))
    }
}
