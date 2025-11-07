//
//  CloudView.swift
//  FitsApp
//
//  Created by Cindy Hu on 7/11/2025.
//

import SwiftUI

struct CloudView: View {
    var body: some View {
        ZStack {
            Text("10,000")
                .font(.system(size:26))
                .fontWeight(.bold)
                .position(x: 310, y: 240)
                .foregroundColor(Color("FontColour"))
            Image("Cloud")
                .opacity(0.8)
                .position(x: 310, y: 270)
        }
        ZStack {
            Text("5,000")
                .font(.system(size:26))
                .fontWeight(.bold)
                .position(x: 90, y: 380)
                .foregroundColor(Color("FontColour"))
            Image("Cloud")
                .opacity(0.8)
                .position(x: 100, y: 410)
        }
    }
}

#Preview {
    ZStack{
        Color(.green)
        CloudView()
    }
}
