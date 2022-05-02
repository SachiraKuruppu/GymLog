//
//  WatchService.swift
//  GymLog
//
//  Created by Sachira Kuruppu on 1/05/22.
//

import Foundation
import WatchConnectivity

final class WatchService: NSObject, WCSessionDelegate {
    static let shared = WatchService()
    
    private var model: WorkoutModel?
    
    override private init() {
        super.init()
        
        guard WCSession.isSupported() else {
            fatalError("WCSession is not supported")
        }
        
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
    func setModel(_ model: WorkoutModel) {
        self.model = model
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        guard let model = self.model else {
            print("Model is not set")
            return
        }
        
        guard let request = message["request"] as? String else {
            print("Message does not have a request")
            return
        }
        
        switch request {
        case "list":
            let workoutNames: [String] = model.workouts.map { $0.name }
            replyHandler(["workout_names": workoutNames])
        
        case "selected":
            guard let index = message["index"] as? Int else {
                print("Did not get the index with the select request")
                return
            }
            replyHandler(["workout": model.workouts[index].encode()]);
        
        default:
            print("Unknown request: " + request)
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }
}
