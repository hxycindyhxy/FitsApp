//
//  TreeView.swift
//  FitsApp
//
//  Created by Cindy Hu on 7/11/2025.
//

import SwiftUI

struct TreeView: View {
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            Image("TopCloud")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(edges: .top)
                .position(x: 200, y: 0)

            
            ScrollView(.vertical, showsIndicators: false) {
                ZStack {
                    CloudView()
                    
                    VStack {
                        Image("Trunck")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60)
                            .position(x: 200, y: 600)
                        
                        Image("Ground")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 770)
                            .position(x: 200, y: 530)
                    }
                }
            }
        }
    }
}

#Preview {
    TreeView()
}
