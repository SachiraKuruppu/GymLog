//
//  SelectorSubView.swift
//  GymLog WatchKit Extension
//
//  Created by Sachira Kuruppu on 4/05/22.
//

import SwiftUI

//protocol IntOrFloat {}
//extension Int: IntOrFloat {}
//extension Float: IntOrFloat {}

struct SelectorSubView: View {
    let from: Float
    let to: Float
    let by: Float
    let label: String
    
    var selection: Binding<Float>
    @State private var values: [Float] = []
    
    var body: some View {
        Picker(selection: selection, label: EmptyView()) {
            ForEach(0..<values.count, id:\.self) { i in
                Text("\(values[i], specifier: "%g" + label)").tag(values[i])
            }
        }
        .pickerStyle(.wheel)
        .onAppear() {
            values = Array(stride(from: from, to: to, by: by))
        }
    }
}

struct SelectorSubView_Previews: PreviewProvider {
    static var previews: some View {
        SelectorSubView(from: 0, to: 10, by: 1.5, label: "", selection: .constant(0))
    }
}
