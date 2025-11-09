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
            Text("20,000")
                .font(.system(size:26))
                .fontWeight(.bold)
                .offset(x: -120, y: -200)
                .foregroundColor(Color("FontColour"));
            Image("Cloud")
                .opacity(0.8)
                .offset(x: -120, y: -180)
        };
        
        ZStack {
            Text("10,000")
                .font(.system(size:26))
                .fontWeight(.bold)
                .offset(x: 120, y: -10)
                .foregroundColor(Color("FontColour"));
            Image("Cloud")
                .opacity(0.8)
                .offset(x: 120, y: 10)
        };
        
        ZStack {
            Text("5,000")
                .font(.system(size:26))
                .fontWeight(.bold)
                .offset(x: -120, y: 100)
                .foregroundColor(Color("FontColour"));
            
            Image("Cloud")
            .opacity(0.8)
            .offset(x: -120, y: 120) }
    }
};

#Preview {
    ZStack{
        Color("Background"); CloudView()
    }
}

