//
//  TreeView.swift
//  FitsApp
//
//  Created by Cindy Hu on 7/11/2025.
//

import SwiftUI

struct TreeView: View {
    @StateObject private var viewModel = TreeViewModel()
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
                        GoalView(onDismiss: {})
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
                        ZStack (alignment: .bottom ){
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
                        .overlay (alignment: .top) {
                            VStack{
                                Color.clear.frame(height: 200)
                                // Top content
                                Text("\(viewModel.stepCount.formatted(.number)) STEPS")
                                    .font(.system(size: 32, weight: .bold, design: .default))
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
                    .padding()
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
                    .padding()
                    .offset(x:0,y: 360)
                }
                .offset(y: showingGoal ? geo.size.height * 1.1 : (showingCustomisation ? -geo.size.height * 1.1 : 0))
                .animation(.spring(response: 0.45, dampingFraction: 0.9), value: showingGoal)
                .animation(.spring(response: 0.45, dampingFraction: 0.9), value: showingCustomisation)
                .allowsHitTesting(!showingGoal && !showingCustomisation)

                // Goal overlay sliding from the top
                Group {
                    if showingGoal {
                        GoalView(onDismiss: {
                            showingGoal = false
                        })
                        .transition(.move(edge: .top))
                        .allowsHitTesting(true)
                        .zIndex(1)
                    }
                }
                .animation(.spring(response: 0.45, dampingFraction: 0.9), value: showingGoal)

                // Customisation overlay sliding from the bottom
                if showingCustomisation {
                    ZStack(alignment: .bottomTrailing) {
                        CustomisationView()
                            .transition(.move(edge: .bottom))
                        // Dismiss button
                        Button {
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.9)) {
                                showingCustomisation = false
                            }
                        } label: {
                            Image(systemName: "chevron.up")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Circle().fill(Color.black.opacity(0.35)))
                        }
                        .padding(.bottom, 16)
                        .padding(.trailing, 16)
                    }
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


#Preview {
    TreeView()
}
