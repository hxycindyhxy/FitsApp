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
            
//            Image(viewModel.getTreeImage(for: 0))
//                .offset(x: 0, y: 80)
            
            
            //BELLO CHANGE
            // Dynamically generate tree segments based on step count
            ForEach(0..<viewModel.treeSegmentCount, id: \.self) { index in
                
                Image(viewModel.getTreeImage(for: index))
                    .resizable()
                    .scaledToFit()
                    .frame(width: getTreeWidth())
                    .offset(x: 0, y: getYPosition(for: index))
            }
        }
        //BELLO CHANGE
        .offset(y: 20)
    }
    
    // Calculate Y position for each segment
    // First image at y: 260, then each subsequent image is 100 units lower
    // -300
    private func getYPosition(for index: Int) -> CGFloat {
        return -160 + CGFloat(index * -1 * 100)
    }
    
    //BELLO
    // Get tree width based on selected tree type
    private func getTreeWidth() -> CGFloat {
        // Adjust these values to scale each tree type appropriately
        switch viewModel.selectedTreeIndex {
        case 0: // Candy tree
            return 160 // Original size for Candy tree
        case 1: // Pine tree
            return 180 // Smaller size for Pine tree
        default:
            return 150 // Default size for other trees
        }
    }
}

#Preview {
    TreeCrownView(viewModel: TreeViewModel())
}
