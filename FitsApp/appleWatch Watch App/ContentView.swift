//
//  ContentView.swift
//  FitsappWatchFunction Watch App
//
//  Created by Callum on 10/11/2025.
//

import SwiftUI
import CoreMotion

struct ContentView: View {
    @State private var loop = false
    @State private var animate = false
    @State private var rotate = false
    @State private var birds = false
    @State private var steps = 0
    @StateObject private var motionManager = MotionManager()
    
    var body: some View {
        VStack {
            ZStack {
                Image("Background")
                    .resizable()
                    .frame(width: 277, height: 277)
                    .offset(x: 15, y: loop  ? -20 : -0)
                    .animation(.easeInOut(duration: 2), value: loop)
                Image("Sun")
                    .resizable()
                    .frame(width: 260, height: 180)
                    .offset(x: 0, y: animate ? -95 : -160)
                    .animation(.easeInOut(duration: 2), value: animate)
                Text(Date(), style: .time)
                    .foregroundStyle(.orange)
                    .font(.custom("Poppins-Bold", size: 35))
                    .opacity(animate ? 1 : 0)
                    .opacity(birds ? 0 : 1)
                    .offset(x: 6, y: -92)
                    .animation(.easeInOut(duration: 1.5), value: animate)
                    .animation(.easeInOut(duration: 1.5), value: birds)
                Image("Cloud")
                    .resizable()
                    .frame(width: 230, height: 110)
                    .offset(x: animate ? 220 : 60, y: -110)
                    .animation(.easeInOut(duration: 2), value: animate)
                Image("Cloudleft")
                    .resizable()
                    .frame(width: 230, height: 110)
                    .offset(x: animate ? -220 : -60, y: -110)
                    .animation(.easeInOut(duration: 2), value: animate)
                Image("Birdleft")
                    .resizable()
                    .frame(width: 80, height: 70)
                    .offset(x: birds ? -50 : 0, y: -30)
                    .animation(.easeInOut(duration: 2), value: birds)
                Image("Birdright")
                    .resizable()
                    .frame(width: 80, height: 70)
                    .offset(x: birds ? 50 : 0, y: -30)
                    .animation(.easeInOut(duration: 2), value: birds)
                Image("Tree")
                    .resizable()
                    .frame(width: 120, height: 170)
                    .offset(x: rotate ? -3 : 3, y: 20)
                    .rotationEffect(.degrees(rotate ? 360 : 358))
                    .animation(.easeInOut(duration: 3), value: rotate)
                Text(Date(), style: .time)
                    .foregroundStyle(.black)
                    .font(.custom("Poppins-Bold", size: 35))
                    .opacity(animate ? 0 : 1)
                    .opacity(birds ? 0 : 1)
                    .offset(x: 6, y: -92)
                    .animation(.easeInOut(duration: 1.5), value: animate)
                    .animation(.easeInOut(duration: 1.5), value: birds)
                Text("You Walked")
                    .foregroundStyle(.black)
                    .font(.custom("Poppins-Bold", size: 10))
                    .opacity(birds ? 1 : 0)
                    .offset(x: 0, y: -110)
                    .animation(.easeInOut(duration: 1.5), value: birds)
                Text("\(steps) Steps!")
                    .foregroundStyle(.black)
                    .font(.custom("Poppins-Bold", size: 25))
                    .opacity(birds ? 1 : 0)
                    .offset(x: 0, y: -90)
                    .animation(.easeInOut(duration: 1.5), value: birds)
            }
        }
        .padding()
        .onAppear {
            motionManager.startMonitoring()
            Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 2)) {
                    loop.toggle()
                }
            }
            Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 2)) {
                    rotate.toggle()
                }
            }
        }
        .onChange(of: motionManager.isMoving) { moving in
            withAnimation {
                animate = moving
            }
        }
        .onTapGesture {
            motionManager.fetchStepsSinceMotionStarted { count in
                steps = count
                withAnimation(.easeInOut(duration: 2)) {
                    birds = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeInOut(duration: 2)) {
                        birds = false
                    }
                    motionManager.resetStepTracking()
                }
            }
        }
    }
    
}

        #Preview {
            ContentView()
}

