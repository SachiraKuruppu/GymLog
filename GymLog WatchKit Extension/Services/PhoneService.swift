//
//  PhoneService.swift
//  GymLog WatchKit Extension
//
//  Created by Sachira Kuruppu on 1/05/22.
//

import Foundation
import WatchConnectivity

final class PhoneService: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = PhoneService()
    
    @Published var status: String = ""
    @Published var workoutNames: [String] = []
    @Published var workout: WorkoutItem?
    
    override private init() {
        super.init()
        
        guard WCSession.isSupported() else {
            fatalError("WCSession is not supported")
        }
        
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
    func setStatus() {
        guard WCSession.default.activationState == .activated else {
            status = "Not Activated"
            return
        }
        
        guard WCSession.default.isCompanionAppInstalled else {
            status = "Not Installed"
            return
        }
        
        if WCSession.default.isReachable {
            status = "Reachable"
        }
        else {
            status = "Not Reachable"
        }
    }
    
    func requestWorkoutsList() {
        WCSession.default.sendMessage(["request": "list"]) { receivedData in
            guard let workoutNames = receivedData["workout_names"] as? [String] else {
                print("Workout names not received")
                return
            }
            
            self.workoutNames = workoutNames
        }
    }
    
    func requestWorkout(index: Int) {
        WCSession.default.sendMessage(["request": "selected", "index": index]) { receivedData in
            guard let encodedWorkout = receivedData["workout"] as? [String: Any] else {
                print("Workout info not received")
                return
            }
            
            let workout = WorkoutItem.decode(encodedWorkout: encodedWorkout)
            self.workout = workout
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        setStatus()
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        setStatus()
    }
}
