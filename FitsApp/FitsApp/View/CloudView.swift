//
//  CloudView.swift
//  FitsApp
//
//  Created by Cindy Hu on 7/11/2025.
//

import SwiftUI

struct CloudView: View {
    @ObservedObject var viewModel: TreeViewModel

    var body: some View {
        ZStack {
            // Static 5,000 cloud
            ZStack {
                Text("5,000")
                    .font(.system(size: 26))
                    .fontWeight(.bold)
                    .offset(x: -120, y: 100)
                    .foregroundColor(Color("FontColour"))
                
                Image("Cloud")
                    .opacity(0.8)
                    .offset(x: -120, y: 120)
            }

            // Dynamic clouds from view model
            ForEach(Array(viewModel.cloudStepValues.enumerated()), id: \.element.id) { index, cloud in
                let isLeft = index % 2 != 0
                let xOffset: CGFloat = isLeft ? -120 : 120
                let yOffset: CGFloat = 0 - CGFloat(index) * 198
                let baseOpacity: Double = 0.8
                let cloudOpacity = cloud.isAboveCurrent ? baseOpacity * 0.5 : baseOpacity
                let textOpacity = cloud.isAboveCurrent ? 0.5 : 1.0

                ZStack {
                    Text("\(cloud.value.formatted())")
                        .font(.system(size: 26))
                        .fontWeight(.bold)
                        .foregroundColor(Color("FontColour"))
                        .opacity(textOpacity)
                        .offset(x: xOffset, y: yOffset - 20)
                    
                    Image("Cloud")
                        .opacity(cloudOpacity)
                        .offset(x: xOffset, y: yOffset)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color("Background")
        CloudView(viewModel: TreeViewModel())
    }
}
