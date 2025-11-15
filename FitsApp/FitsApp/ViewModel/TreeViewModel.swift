//
//  TreeViewModel.swift
//  FitsApp
//
//  Created by Cindy Hu on 9/11/2025.
//
//
//  TreeViewModel.swift
//  FitsApp
//
//  Created by Cindy Hu on 9/11/2025.
//

import SwiftUI
import Combine
import WatchConnectivity

class TreeViewModel: NSObject, ObservableObject, WCSessionDelegate {
    @Published var stepCount: Int = 10_000 // updated for UI testing
    @AppStorage("selectedTreeIndex") public var selectedTreeIndex: Int = 0

    override init() {
        super.init()
        activateSession()
    }

    // MARK: - Setup WatchConnectivity
    private func activateSession() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    // MARK: - WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        #if DEBUG
        if let error = error {
            print("📱 WCSession activation failed: \(error.localizedDescription)")
        } else {
            print("📱 WCSession activation completed with state: \(activationState.rawValue)")
        }
        #endif
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        #if DEBUG
        print("📱 WCSession did become inactive")
        #endif
    }

    func sessionDidDeactivate(_ session: WCSession) {
        #if DEBUG
        print("📱 WCSession did deactivate; reactivating…")
        #endif
        WCSession.default.activate()
    }

    // Called when watch sends a message
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let latestSteps = message["latestSteps"] as? Int {
            DispatchQueue.main.async {
                self.add(steps: latestSteps)
                print("🌳 Added \(latestSteps) steps from Watch. Total: \(self.stepCount)")
            }
        }
    }

    // MARK: - Tree Logic
    func add(steps: Int) {
        stepCount += max(0, steps)
    }

    // 1 segment per 5,000 steps (max 20)
    var treeSegmentCount: Int {
        return min(stepCount / 5000, 20)
    }

    func getTreeImage(for index: Int) -> String {
        if selectedTreeIndex == 1 {
            // teammate’s simplified Pine pattern
            let pattern = [1, 2, 3]
            let imageNumber = pattern[index % 3]
            return "Pine\(imageNumber)"
        } else {
            let pattern = [1, 3, 2]
            let imageNumber = pattern[index % 3]
            return "CandyTree_\(imageNumber)"
        }
    }

    // MARK: - CloudView Data Source
    struct CloudStep: Identifiable {
        let id = UUID()
        let value: Int
        let isAboveCurrent: Bool
    }

    var cloudStepValues: [CloudStep] {
        let maxStep = stepCount + 20_000
        var steps: [CloudStep] = []
        var current = 10_000
        while current <= maxStep {
            steps.append(
                CloudStep(value: current, isAboveCurrent: current > stepCount)
            )
            current += 10_000
        }
        return steps
    }
}
