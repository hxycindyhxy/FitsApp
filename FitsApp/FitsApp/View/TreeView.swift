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
        GeometryReader { geo in
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
                
                
                ScrollView(.vertical, showsIndicators: false) {
                    ZStack (alignment: .bottom ){
                        VStack{
                            Spacer()
                            TreeCrownView(viewModel: viewModel)
                        }
                    }
                    .frame(height: CGFloat(viewModel.treeSegmentCount * 100 + 500))                    
                    .frame(maxWidth: .infinity, minHeight: geo.size.height)
                    .overlay (alignment: .top) {
                        VStack{
                            Color.clear.frame(height: 200)
                            // Top content
                            Text("\(viewModel.stepCount.formatted(.number)) STEPS")
                                .font(.system(size: 32, weight: .bold, design: .default))
                        }
                    }
                    .overlay(alignment: .bottom) {
                        ZStack(alignment: .bottom) {
                            CloudView(viewModel: viewModel)
                                .offset(x:0,y: -360)
                            
                            Image("Trunk")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60)
                                .offset(y: -80)
                            
                            Image("Ground")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 410)
                                .offset(y: 70)
                        }
                    }
                }
                
                // Viewport overlay (not part of the scrollable content)
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
}

#Preview {
    TreeView()
}
