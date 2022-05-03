//
//  WorkoutService.swift
//  GymLog WatchKit Extension
//
//  Created by Sachira Kuruppu on 2/05/22.
//

import Foundation
import HealthKit

final class WorkoutService: NSObject, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate, ObservableObject {
    static let shared = WorkoutService()
    
    private let healthStore = HKHealthStore()
    private var session: HKWorkoutSession?
    private var builder: HKLiveWorkoutBuilder?
    
    @Published var isRunning = false
    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0
    
    private override init() {
        super.init()
    }
    
    func startWorkout() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .traditionalStrengthTraining
        configuration.locationType = .indoor
        
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        }
        catch {
            fatalError("Unable to start the workout")
        }
        
        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)
        session?.delegate = self
        builder?.delegate = self
        
        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (success, error) in
        }
    }
    
    func requestHealthKitAccess() {
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]
        
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.activitySummaryType()
        ]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            if !success {
                fatalError("Unable to get access to read and write health metrics")
            }
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        self.isRunning = toState == .running
        
        if toState == .ended {
            builder?.endCollection(withEnd: date) { (success, error) in
                self.builder?.finishWorkout() { (workout, error) in
                }
            }
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
    }
    
    func pause() {
        guard let session = session else {
            return
        }
        
        session.pause()
    }
    
    func resume() {
        guard let session = session else {
            return
        }
        
        session.resume()
    }
    
    func endWorkout() {
        guard let session = session else {
            return
        }
        
        session.end()
    }
    
    func getElapsedTime() -> Double {
        return builder?.elapsedTime ?? 0
    }
    
    func getBuilderStart() -> Date {
        return builder?.startDate ?? Date()
    }
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { return }
            
            let statistics = workoutBuilder.statistics(for: quantityType)
            updateForStatistics(statistics)
        }
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
    }
    
    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }
        
        switch statistics.quantityType {
        case HKQuantityType.quantityType(forIdentifier: .heartRate):
            let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
            self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            
        case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
            let energyUnit = HKUnit.kilocalorie()
            self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            
        default:
            return
        }
    }
}
