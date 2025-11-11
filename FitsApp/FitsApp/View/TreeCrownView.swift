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
            
//            Image(viewModel.getTreeImage(for: 0))
//                .offset(x: 0, y: 80)
            
            // Dynamically generate tree segments based on step count
            ForEach(0..<viewModel.treeSegmentCount, id: \.self) { index in
                
                Image(viewModel.getTreeImage(for: index))
                    .offset(x: 0, y: getYPosition(for: index))
            }
        }
    }
    
    // Calculate Y position for each segment
    // First image at y: 260, then each subsequent image is 100 units lower
    // -300
    private func getYPosition(for index: Int) -> CGFloat {
        return -160 + CGFloat(index * -1 * 100)
    }
}

#Preview {
    TreeCrownView(viewModel: TreeViewModel())
}
