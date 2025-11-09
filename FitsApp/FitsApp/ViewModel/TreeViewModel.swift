//
//  TreeViewModel.swift
//  FitsApp
//
//  Created by Cindy Hu on 9/11/2025.
//

import SwiftUI
import Combine

class TreeViewModel: ObservableObject {
    @Published var stepCount: Int = 45000 // change to test different heights

    // 1 segment per 5,000 steps
    var treeSegmentCount: Int {
        return min(stepCount / 5000, 20)
    }

    func getTreeImage(for index: Int) -> String {
        let pattern = [1, 3, 2]
        let imageNumber = pattern[index % 3]
        return "CandyTree_\(imageNumber)"
    }
}
