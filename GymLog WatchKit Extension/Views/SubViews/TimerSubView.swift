//
//  TimerSubView.swift
//  GymLog WatchKit Extension
//
//  Created by Sachira Kuruppu on 2/05/22.
//

import SwiftUI

struct TimerSubView: View {
    var elapsedTime: TimeInterval = 0
    var showSubseconds: Bool = true
    
    @State private var timeFormatter = ElapsedTimeFormatter()
    
    var body: some View {
        Text(NSNumber(value: elapsedTime), formatter: timeFormatter)
            .fontWeight(.semibold)
            .onChange(of: showSubseconds) {
                timeFormatter.showSubseconds = $0
            }
    }
}

fileprivate class ElapsedTimeFormatter: Formatter {
    var showSubseconds = true
    var componentsFormatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }
    
    override func string(for value: Any?) -> String? {
        guard let time = value as? TimeInterval else {
            return nil
        }
        
        guard let formattedString = componentsFormatter.string(from: time) else {
            return nil
        }
        
        if showSubseconds {
            let hundredths = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
            let decimalSeparator = Locale.current.decimalSeparator ?? "."
            return String(format: "%@%@%0.2d", formattedString, decimalSeparator, hundredths)
        }
        
        return formattedString
    }
}

struct TimerSubView_Previews: PreviewProvider {
    static var previews: some View {
        TimerSubView()
    }
}
