import Foundation
import CoreMotion
import Combine
import WatchConnectivity

class MotionManager: NSObject, ObservableObject, WCSessionDelegate {
    private let pedometer = CMPedometer()
    @Published var isMoving = false
    @Published var stepCountWatch: Int = 0
    @Published var stepHistory: [Int] = []

    private var motionStartDate: Date?

    override init() {
        super.init()
        activateSession()
    }

    // MARK: - WatchConnectivity setup
    private func activateSession() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func session(_: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}

    // MARK: - Pedometer logic
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
                self.stepHistory.append(self.stepCountWatch)
                print("Step History: \(self.stepHistory)")

                // ✅ Send latest count to iPhone
                self.sendLatestStepToPhone()

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

    // MARK: - Send data to iPhone
    private func sendLatestStepToPhone() {
        guard WCSession.default.isReachable else {
            print("📡 iPhone not reachable.")
            return
        }
        if let latest = stepHistory.last {
            WCSession.default.sendMessage(["latestSteps": latest], replyHandler: nil) { error in
                print("❌ Failed to send: \(error.localizedDescription)")
            }
            print("📤 Sent \(latest) steps to iPhone")
        }
    }
}
