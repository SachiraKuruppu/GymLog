//
//  RestTimeView.swift
//  GymLog WatchKit Extension
//
//  Created by Sachira Kuruppu on 3/05/22.
//

import SwiftUI

struct RestTimeView: View {
    @State var restTimeInSeconds: Int
    @State var startDate = Date()
    let completion: () -> Void
    
    var body: some View {
        
        TimelineView(
            ElapsedTimerSchedule(from: startDate)
        ) { context in
            ZStack{
                let elapsedTime = Date().timeIntervalSince(startDate)
                let normalizedElapsedTime = CGFloat(elapsedTime) / CGFloat(restTimeInSeconds)
                
                Text(elapsedTime.formatted(.number.precision(.fractionLength(0))))
                    .foregroundColor(Color.yellow)
                    .font(.title)
                    .onChange(of: elapsedTime) { newVal in
                        if normalizedElapsedTime >= 1 {
                            completion()
                        }
                    }
                
                Circle()
                    .trim(from: 0, to: normalizedElapsedTime)
                    .rotation(Angle(degrees: -90))
                    .stroke(Color.yellow, lineWidth: 10)
                    .frame(width: 150, height: 150, alignment: .center)
            }
            .frame(width: 200, height: 200, alignment: .center)
            .background(Color.black)
        }
    }
}

struct RestTimeView_Previews: PreviewProvider {
    static var previews: some View {
        RestTimeView(restTimeInSeconds: 120){}
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
