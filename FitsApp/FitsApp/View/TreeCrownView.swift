//
//  TreeCrownView.swift
//  FitsApp
//
//  Created by Xinyi Hu on 9/11/2025.
//

import SwiftUI

struct TreeCrownView: View {
    @ObservedObject var viewModel: TreeViewModel
    
    var body: some View {
        ZStack {
            // Case 1: only first segment
            if viewModel.treeSegmentCount == 1 {
                Image(viewModel.getTreeImage(for: 0))
                    .offset(x: 0, y: -70)
            }
            
            // Case 2: show first and second segments
            else if viewModel.treeSegmentCount == 2 {
                Image(viewModel.getTreeImage(for: 0))
                    .offset(x: 0, y: -120)
                Image(viewModel.getTreeImage(for: 1))
                    .offset(x: 0, y: -220)
            }
            
            // Case 3 and beyond: show all segments dynamically
            else if viewModel.treeSegmentCount >= 3 {
                ForEach(0..<viewModel.treeSegmentCount, id: \.self) { index in
                    Image(viewModel.getTreeImage(for: index))
                        .offset(x: 0, y: getYPosition(for: index))
                }
            }
        }
    }
    
    // Calculate Y position for each segment
    private func getYPosition(for index: Int) -> CGFloat {
        return -160 + CGFloat(index * -100)
    }
}

#Preview {
    TreeCrownView(viewModel: TreeViewModel())
}
