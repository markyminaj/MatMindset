//
//  HealthKitManager.swift
//  MatMindset
//
//  Created by Mark Martin on 5/30/25.
//

import Foundation
import HealthKit

class HealthKitManager {
    static let shared = HealthKitManager()
    let healthStore = HKHealthStore()

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            return
        }

        let typesToShare: Set = [
            HKObjectType.workoutType()
        ]

        let typesToRead: Set = [
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!
        ]

        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }

    func saveWorkout(start: Date, end: Date, duration: TimeInterval, calories: Double?) {
        let workout = HKWorkout(
            activityType: .martialArts,
            start: start,
            end: end,
            duration: duration,
            totalEnergyBurned: calories != nil ?
                HKQuantity(unit: .kilocalorie(), doubleValue: calories!) : nil,
            totalDistance: nil,
            metadata: [
                HKMetadataKeyWorkoutBrandName: "Mat Mindset"
            ]
        )

        healthStore.save(workout) { success, error in
            if success {
                print("✅ Workout saved to Health")
            } else {
                print("❌ Failed to save workout: \(String(describing: error))")
            }
        }
    }

    func fetchWorkouts(completion: @escaping ([HKWorkout]) -> Void) {
        let predicate = HKQuery.predicateForWorkouts(with: .martialArts)
        let sort = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]

        let query = HKSampleQuery(
            sampleType: HKObjectType.workoutType(),
            predicate: predicate,
            limit: 10,
            sortDescriptors: sort
        ) { _, samples, _ in
            let workouts = samples as? [HKWorkout] ?? []
            DispatchQueue.main.async {
                completion(workouts)
            }
        }

        healthStore.execute(query)
    }
}
