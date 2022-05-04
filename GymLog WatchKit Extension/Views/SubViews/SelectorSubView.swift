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
    let onChange: (Float) -> Void
    
    @State private var selection: Int = 0
    @State private var values: [Float] = []
    
    var body: some View {
        Picker(selection: $selection, label: EmptyView()) {
            ForEach(0..<values.count, id:\.self) { i in
                Text("\(values[i], specifier: "%g" + label)").tag(i)
            }
        }
        .onChange(of: selection) { tag in
            onChange(values[tag])
        }
        .pickerStyle(.wheel)
        .onAppear() {
            values = Array(stride(from: from, to: to, by: by))
        }
    }
}

struct SelectorSubView_Previews: PreviewProvider {
    static var previews: some View {
        SelectorSubView(from: 0, to: 10, by: 1.5, label: "") { _ in }
    }
}
