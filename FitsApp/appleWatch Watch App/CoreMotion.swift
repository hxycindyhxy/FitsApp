
//
//  Coremotion.swift
//  FitsappWatchFunction Watch App
//
//  Created by Callum on 12/11/2025.
//

import Foundation
import CoreMotion
import Combine

class MotionManager: ObservableObject {
    private let pedometer = CMPedometer()
    @Published var isMoving = false
    @Published var stepCountWatch: Int = 0
    @Published var stepHistory: [Int] = [] // ✅ store all tapped step counts here

    private var motionStartDate: Date?

    func startMonitoring() {
        guard CMPedometer.isStepCountingAvailable(),
              CMPedometer.isPedometerEventTrackingAvailable() else { return }

        pedometer.startEventUpdates { [weak self] event, error in
            guard let event = event, error == nil else { return }

            DispatchQueue.main.async {
                if event.type == .resume {
                    self?.isMoving = true
                    self?.motionStartDate = Date()
                } else if event.type == .pause {
                    self?.isMoving = false
                }
            }
        }
    }

    func fetchStepsSinceMotionStarted(completion: @escaping (Int) -> Void) {
        guard let startDate = motionStartDate else {
            completion(0)
            return
        }

        pedometer.queryPedometerData(from: startDate, to: Date()) { data, error in
            guard let data = data, error == nil else {
                completion(0)
                return
            }

            DispatchQueue.main.async {
                self.stepCountWatch = data.numberOfSteps.intValue
                self.stepHistory.append(self.stepCountWatch) // ✅ add new step count to list
                print("Step History: \(self.stepHistory)")   // ✅ print updated list
                completion(self.stepCountWatch)
            }
        }
    }

    func stopMonitoring() {
        pedometer.stopEventUpdates()
    }
    
    func resetStepTracking() {
        motionStartDate = Date()
        stepCountWatch = 0
    }
}
