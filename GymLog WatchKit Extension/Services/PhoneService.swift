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
    
    func requestWorkoutsList(completion: @escaping ([String]) -> Void) {
        WCSession.default.sendMessage(["request": "list"]) { receivedData in
            guard let workoutNames = receivedData["workout_names"] as? [String] else {
                print("Workout names not received")
                return
            }
            
            completion(workoutNames)
        }
    }
    
    func requestWorkout(index: Int, completion: @escaping (WorkoutItem) -> Void) {
        WCSession.default.sendMessage(["request": "selected", "index": index]) { receivedData in
            guard let encodedWorkout = receivedData["workout"] as? [String: Any] else {
                print("Workout info not received")
                return
            }
            
            let workout = WorkoutItem.decode(encodedWorkout: encodedWorkout)
            completion(workout)
        }
    }
    
    func requestSaveWorkout(index: Int, workout: WorkoutItem) {
        WCSession.default.sendMessage([
            "request": "save",
            "index": index,
            "workout": workout.encode()
        ]) { receivedData in
            guard let status = receivedData["status"] as? Bool else {
                print("Cannot determine whether workout was saved or not")
                return
            }
            
            if status == false {
                fatalError("Could not save the workout")
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        setStatus()
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        setStatus()
    }
}
