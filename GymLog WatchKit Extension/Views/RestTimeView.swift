//
//  RestTimeView.swift
//  GymLog WatchKit Extension
//
//  Created by Sachira Kuruppu on 3/05/22.
//

import SwiftUI

struct RestTimeView: View {
    var restTimeInSeconds: Int
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Environment(\.dismiss) private var dismiss
    @State private var timeRemaining: Int = 10
    @State private var normalizedTimeRemaining: CGFloat = 1
    
    var body: some View {
        
        ZStack{
            Text("\(timeRemaining)")
                .foregroundColor(Color.yellow)
                .font(.title)
                .onReceive(timer) { _ in
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    }
                    else if timeRemaining == 0 {
                        dismiss()
                    }
                }
                .onAppear { timeRemaining = restTimeInSeconds }
            
            Circle()
                .trim(from: 0, to: normalizedTimeRemaining)
                .rotation(Angle(degrees: -90))
                .stroke(Color.yellow, lineWidth: 10)
                .frame(width: 150, height: 150, alignment: .center)
                .onReceive(timer) { _ in
                    normalizedTimeRemaining = CGFloat(timeRemaining) / CGFloat(restTimeInSeconds)
                }
        }
        .frame(width: 200, height: 200, alignment: .center)
        .background(Color.black)
    }
}

struct RestTimeView_Previews: PreviewProvider {
    static var previews: some View {
        RestTimeView(restTimeInSeconds: 120)
    }
}
