//
//  TreeCrownView.swift
//  FitsApp
//
//  Created by Xinyi Hu on 9/11/2025.
//

import SwiftUI

struct TreeCrownView: View {
    @ObservedObject var viewModel: TreeViewModel
    @AppStorage("selectedTreeIndex") public var selectedTreeIndex: Int = 0
    
    var body: some View {
        ZStack {
            // Case 1: only first segment
            if viewModel.treeSegmentCount == 1 {
                Image(viewModel.getTreeImage(for: 0))
                    .resizable()
                    .scaledToFit()
                    .frame(width: getTreeWidth(for: 0))
                    .offset(x: 0, y: -70)
            }
            
            // Case 2: show first and second segments
            else if viewModel.treeSegmentCount == 2 {
                Image(viewModel.getTreeImage(for: 0))
                    .resizable()
                    .scaledToFit()
                    .frame(width: getTreeWidth(for: 0))
                    .offset(x: 0, y: -120)
                
                Image(viewModel.getTreeImage(for: 1))
                    .resizable()
                    .scaledToFit()
                    .frame(width: getTreeWidth(for: 1))
                    .offset(x: 0, y: -220)
            }
            
            // Case 3 and beyond: show all segments dynamically
            else if viewModel.treeSegmentCount >= 3 {
                ForEach(0..<viewModel.treeSegmentCount, id: \.self) { index in
                    Image(viewModel.getTreeImage(for: index))
                        .resizable()
                        .scaledToFit()
                        .frame(width: getTreeWidth(for: index))
                        .offset(x: 0, y: getYPosition(for: index))
                }
            }
        }
        .offset(y: 15)
    }
    
    // Calculate Y position for each segment
    private func getYPosition(for index: Int) -> CGFloat {
        let TreeSpacing = 100
        return -160 + CGFloat(index * -1 * TreeSpacing)
    }
    
    // Get tree width based on selected tree type AND segment index
    private func getTreeWidth(for index: Int) -> CGFloat {
        switch viewModel.selectedTreeIndex {
        case 0: // Candy tree - different size per segment
            return 140
        case 1: // Pine tree - uniform size
            return 160
        default: // Other trees
            return 150
        }
    }
}

#Preview {
    TreeCrownView(viewModel: TreeViewModel())
}
