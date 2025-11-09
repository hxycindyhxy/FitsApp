//
//  TreeView.swift
//  FitsApp
//
//  Created by Cindy Hu on 7/11/2025.
//

import SwiftUI

struct TreeView: View {
    @StateObject private var viewModel = TreeViewModel()
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                ZStack() {
                    Text("12,000 STEPS")
                        .font(.system(size: 32, weight: .bold, design: .default))
                        .offset(x:0,y: -480)
                    
                    // Trunk
                    Image("Trunk")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                        .offset(x:0,y: 600)
                    
                    // Ground
                    Image("Ground")
                        .resizable()
                        .scaledToFit()
                        .offset(x:0,y: 700)
                    
                    
                    // Tree crown
                    VStack {
                        Color.clear
                            .frame(height: 300)
                        
                        TreeCrownView(viewModel: viewModel)
                            .frame(height: CGFloat(viewModel.treeSegmentCount * 100 + 200))
                            .scaledToFit()
                            .offset(x:0,y: -140)
                    }
                    
                    CloudView()
                        .offset(x:0,y: 340)
                    
                }
                .frame(maxWidth: .infinity)
            }
            
            // Clouds overlay on top
            VStack {
                Image("TopCloud")
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea(edges: .top)
                
                Spacer()
            }
        }
    }
}

#Preview {
    TreeView()
}
