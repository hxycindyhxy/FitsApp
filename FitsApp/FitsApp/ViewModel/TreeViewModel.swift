//
//  TreeViewModel.swift
//  FitsApp
//
//  Created by Cindy Hu on 9/11/2025.
//

import SwiftUI
import Combine

class TreeViewModel: ObservableObject {
    @Published var stepCount: Int = 25_000 // change to test different heights
    @AppStorage("selectedTreeIndex") public var selectedTreeIndex: Int = 0


    // 1 segment per 5,000 steps
    var treeSegmentCount: Int {
        return min(stepCount / 5000, 20)
    }
    
    func add(steps: Int) {
        stepCount += max(0, steps)
    }

    func getTreeImage(for index: Int) -> String {
        if (selectedTreeIndex == 1) {
            let pattern = [1, 3, 5, 9, 2, 4, 6, 8]
            let imageNumber = pattern[index % 9]
            return "Pine\(imageNumber)"
        }
        else {
            let pattern = [1, 3, 2]
            let imageNumber = pattern[index % 3]
            return "CandyTree_\(imageNumber)"
        }
    }

    // MARK: - CloudView data source
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
