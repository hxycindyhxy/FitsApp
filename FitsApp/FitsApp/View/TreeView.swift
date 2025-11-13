//
//  TreeView.swift
//  FitsApp 123
//
//  Created by Cindy Hu on 7/11/2025.
//

import SwiftUI

struct TreeView: View {
    @StateObject private var viewModel = TreeViewModel()
    @StateObject private var goalSettings = GoalSettings()
    @State private var path = NavigationPath()
    @State private var showingGoal: Bool = false
    @State private var showingCustomisation: Bool = false
    private enum Route: Hashable { case goal, customise }
    
    var body: some View {
        NavigationStack(path: $path) {
            coreContent
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .goal:
                        GoalView(goalSettings: goalSettings, onDismiss: {})
                    case .customise:
                        CustomisationView()
                    }
                }
        }
    }
    
    @ViewBuilder
    private var coreContent: some View {
        GeometryReader { geo in
            ZStack {
                Color("Background")
                    .ignoresSafeArea()

                // Main layer that moves down when showingGoal or up when showingCustomisation
                ZStack {
                    // Scrollable content
                    ScrollView(.vertical, showsIndicators: false) {
                        ZStack (alignment: .bottom){
                            
                            // 🌳 Trunk 3-case logic
                            if viewModel.treeSegmentCount == 1 {
                                Image("Trunk")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60)
                                    .offset(y: 10)
                            } else if viewModel.treeSegmentCount == 2 {
                                    Image("Trunk")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60)
                                        .offset(y: -30)
                            } else if viewModel.treeSegmentCount >= 3 {
                                // For 3 or more, repeat trunk dynamically (simulate stacked growth)
                                ForEach(0..<min(viewModel.treeSegmentCount / 2, 5), id: \.self) { i in
                                    Image("Trunk")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60)
                                        .offset(y: -80 - CGFloat(i * 60))
                                }
                            }
                                
                                
                            
                            VStack{
                                Spacer()
                                TreeCrownView(viewModel: viewModel)
                            }
                        }
                        .frame(height: CGFloat(viewModel.treeSegmentCount * 100 + 500))
                        .frame(maxWidth: .infinity, minHeight: geo.size.height)
                        .overlay(alignment: .bottom) {
                            ZStack(alignment: .bottom) {
                                CloudView(viewModel: viewModel)
                                    .offset(x:0,y: -360)
                                
                                
                                
                                Image("Ground")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 410)
                                    .offset(y: 70)
                            }
                        }
                        .overlay (alignment: .top) {
                            VStack(spacing: 8){
                                Color.clear.frame(height: 280)
                                
                                // Top content
                                Text("\(viewModel.stepCount.formatted(.number)) STEPS")
                                    .font(.custom("Poppins-Bold", size: 42))
                                    .offset(x: 0, y: -100)
                            }
                        }
                        .overlay(alignment: .bottom) {
                            if !goalSettings.treeName.isEmpty {
                                TreeNamePlaque(name: goalSettings.treeName)
                                    .rotationEffect(.degrees(-3))
                                    .offset(x: -100, y: -80)
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

                    // Up button -> show GoalView
                    Button {
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.9)) {
                            showingGoal = true
                        }
                    } label: {
                        Image(systemName:"arrow.up")
                            .font(Font.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .opacity(0.8)
                    }
                    .buttonStyle(GlassButtonStyle())
                    .offset(x:0,y: -350)
                    
                    

                    // Down button -> show CustomisationView
                    Button {
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.9)) {
                            showingCustomisation = true
                        }
                    } label: {
                        Image(systemName:"arrow.down")
                            .font(Font.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .opacity(0.8)
                    }
                    .buttonStyle(GlassButtonStyle())
                    .offset(x:0,y: 360)
                }
                .offset(y: showingGoal ? geo.size.height * 1.1 : (showingCustomisation ? -geo.size.height * 1.1 : 0))
                .animation(.spring(response: 0.45, dampingFraction: 0.9), value: showingGoal)
                .animation(.spring(response: 0.45, dampingFraction: 0.9), value: showingCustomisation)
                .allowsHitTesting(!showingGoal && !showingCustomisation)

                // Goal overlay sliding from the top
                if showingGoal {
                    GoalView(
                        goalSettings: goalSettings,
                        onDismiss: {
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.9)) {
                                showingGoal = false
                            }
                        }
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.move(edge: .top))
                    .allowsHitTesting(true)
                    .zIndex(2)
                }

                // Customisation overlay sliding from the bottom
                if showingCustomisation {
                    GeometryReader { customGeo in
                        ZStack(alignment: .top) {
                            CustomisationView()
                                .frame(width: customGeo.size.width, height: customGeo.size.height)
                                .transition(.move(edge: .bottom))
                            
                            
                            // Dismiss button
                            Button {
                                withAnimation(.spring(response: 0.45, dampingFraction: 0.9)) {
                                    showingCustomisation = false
                                }
                            } label: {
                                Image(systemName: "arrow.up")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(12)
                            }
                            .padding(.top, 16)
                            .buttonStyle(GlassButtonStyle())
                           
                        }
                    }
                    .zIndex(2)
                }
            }
        }
    }
}

// Glass button style
struct GlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 64, height: 64) // fixed square so Circle renders correctly
            .contentShape(Circle())
            .background(
                ZStack {
                    // translucent material base (iOS 15+). Falls back to a semi-transparent blur-like color in older SDKs.
                    if #available(iOS 15.0, *) {
                        Circle().fill(.ultraThinMaterial)
                    } else {
                        Circle().fill(Color.white.opacity(0.12))
                    }

                    // subtle glossy overlay gradient
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(configuration.isPressed ? 0.06 : 0.12), Color.white.opacity(0.02)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .blendMode(.overlay)

                    // fine border
                    Circle().stroke(Color.white.opacity(0.25), lineWidth: 1)
                }
            )
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 0.85)
            .shadow(color: Color.black.opacity(configuration.isPressed ? 0.06 : 0.18), radius: configuration.isPressed ? 4 : 10, x: 0, y: configuration.isPressed ? 2 : 6)
    }
}

// Smaller glass button style
struct SmallGlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 52, height: 52) // smaller size
            .contentShape(Circle())
            .background(
                ZStack {
                    // translucent material base (iOS 15+). Falls back to a semi-transparent blur-like color in older SDKs.
                    if #available(iOS 15.0, *) {
                        Circle().fill(.ultraThinMaterial)
                    } else {
                        Circle().fill(Color.white.opacity(0.15))
                    }

                    // subtle glossy overlay gradient
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(configuration.isPressed ? 0.08 : 0.15), Color.white.opacity(0.03)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .blendMode(.overlay)

                    // fine border
                    Circle().stroke(Color.white.opacity(0.3), lineWidth: 1)
                }
            )
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.95 : 1.0)
            .shadow(color: Color.black.opacity(configuration.isPressed ? 0.08 : 0.2), radius: configuration.isPressed ? 4 : 10, x: 0, y: configuration.isPressed ? 2 : 6)
    }
}

// Tree name plaque - looks like a garden stake sign on the grass
struct TreeNamePlaque: View {
    let name: String
    
    var body: some View {
        VStack(spacing: 0) {
            // Sign board
            Text(name)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.2))
                .tracking(1)
                .textCase(.uppercase)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(
                    ZStack {
                        // Wooden sign background
                        RoundedRectangle(cornerRadius: 6)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.82, green: 0.71, blue: 0.55),
                                        Color(red: 0.76, green: 0.65, blue: 0.49)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        // Border
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(Color(red: 0.5, green: 0.4, blue: 0.3), lineWidth: 1.5)
                    }
                )
            
            // Stake going into the ground
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.6, green: 0.5, blue: 0.35),
                            Color(red: 0.55, green: 0.45, blue: 0.3)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 4, height: 28)
        }
    }
}

struct CurvedText: View {
    let text: String
    let radius: CGFloat
    let angle: Double // total sweep angle of the curve (in degrees)
    
    var body: some View {
        let characters = Array(text)
        let anglePerChar = angle / Double(characters.count)
        let startAngle = -angle / 2
        
        ZStack {
            ForEach(0..<characters.count, id: \.self) { i in
                let charAngle = startAngle + (Double(i) * anglePerChar)
                let radian = charAngle * .pi / 180
                let x = cos(radian) * radius
                let y = sin(radian) * radius
                
                Text(String(characters[i]))
                    .font(.custom("Poppins-Bold", size: 36))
                    .foregroundColor(.white)
                    .position(x: radius - x, y: radius - y)
                    .rotationEffect(.degrees(-charAngle))
            }
        }
        .frame(width: radius * 2, height: radius, alignment: .center)
    }
}





#Preview {
    TreeView()
}
