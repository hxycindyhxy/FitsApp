//
//  GoalView.swift
//  Survey
//
//  Created by Stanley Diomampo on 7/11/2025.
//

import SwiftUI
import Combine

// Shared data model to store user's goal settings
class GoalSettings: ObservableObject {
    @Published var activityLevel: String = ""
    @Published var treeName: String = ""
    @Published var isGoalSet: Bool = false
}

//Hex Code Converter
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

//Flipped Button
struct FlippableButton: View {
    let activity: String
    let selectedActivity: String?
    let isFlipped: Bool
    let onSelect: () -> Void
    let onTap: () -> Void
    let onLongPress: () -> Void
    
    var body: some View {
        let isSelected = selectedActivity == activity
        
        ZStack {
            // Front side (image) - shown when NOT selected
            Image(activity.capitalized)
                .resizable()
                .scaledToFit()
                .frame(width: 95, height: 95)
                .opacity(isSelected ? 0 : 1)
                .rotation3DEffect(
                    .degrees(isSelected ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )
            
            // Back side (step goals) - shown when selected
            VStack(spacing: 4) {
                Text(activity.capitalized)
                    .font(.custom("Poppins-Bold", size: 14))
                    .foregroundStyle(.white)
                
                Text(infoText(for: activity))
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
            }
            .frame(width: 95, height: 95)
            .background(Color(hex: "#7574A7"))
            .cornerRadius(15)
            .opacity(isSelected ? 1 : 0)
            .rotation3DEffect(
                .degrees(isSelected ? 0 : -180),
                axis: (x: 0, y: 1, z: 0)
            )
        }
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isSelected)
        .onTapGesture {
            onTap()
        }
    }
    
    // Description
    func infoText(for activity: String) -> String {
        switch activity {
        case "casual": return "35,000 \n Steps"
        case "committed": return "52,500 \n Steps"
        case "consistent": return "70,000 \n Steps"
        default: return ""
        }
    }
}

struct GoalView: View {
    @ObservedObject var goalSettings: GoalSettings
    var onDismiss: () -> Void
    
    @State private var selectedActivity: String? = nil
    @State private var treeName: String = ""
    @State private var showConfirmation: Bool = false
    @State private var isDismissing: Bool = false
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 0) {
                        Color.clear.frame(height: 1).id("scrollTop")
                        
                        GoalHeaderView()
                        
                        VStack(spacing: 32) {
                            ActivitySelectionCard(
                                selectedActivity: $selectedActivity,
                                goalSettings: goalSettings
                            )
                            
                            TreeNameCard(
                                treeName: $treeName,
                                showConfirmation: $showConfirmation,
                                isTextFieldFocused: $isTextFieldFocused,
                                goalSettings: goalSettings
                            )
                            
                            Spacer(minLength: 40)
                        }
                        .padding(.top, 28)
                        .padding(.bottom, 100)
                        .id("topContent")
                    }
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: isTextFieldFocused) { oldValue, newValue in
                    if !newValue && oldValue {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                proxy.scrollTo("scrollTop", anchor: .top)
                            }
                        }
                    }
                }
            }
        }
        .background(Color(hex: "#F5F5F8").ignoresSafeArea())
        .onTapGesture { isTextFieldFocused = false }
        .onAppear { 
            isDismissing = false
        }
        .overlay(alignment: .bottom) {
            if !isTextFieldFocused {
                BottomNavigationBar(isDismissing: $isDismissing, onDismiss: onDismiss)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isTextFieldFocused)
    }
}

// MARK: - Header View
private struct GoalHeaderView: View {
    var body: some View {
        ZStack {
            Image("Ellipse 3").offset(x: 100, y: -82)
            Image("Ellipse 2").offset(x: -60, y: -89)
            Image("Ellipse 1").offset(x: -140, y: -105)
            
            Text("Plan Your")
                .font(.custom("Poppins-Regular", size: 26))
                .foregroundStyle(.white)
                .offset(x: -105, y: -110)
            Text("Weekly")
                .font(.custom("Poppins-SemiBold", size: 32))
                .foregroundStyle(.white)
                .offset(x: -106, y: -75)
            Text("Goal")
                .font(.custom("Poppins-Bold", size: 32))
                .foregroundStyle(.white)
                .offset(x: -4, y: -75)
        }
        .frame(height: 300)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 30).offset(y: -160))
        .padding(.bottom, -150)
    }
}

// MARK: - Activity Selection Card
private struct ActivitySelectionCard: View {
    @Binding var selectedActivity: String?
    let goalSettings: GoalSettings
    
    var body: some View {
        VStack(spacing: 20) {
            Text("How active do you want to be?")
                .font(.custom("Poppins-Bold", size: 20))
                .foregroundStyle(Color(hex: "#595880"))
                .multilineTextAlignment(.center)
            
            HStack(spacing: 15) {
                ForEach(["casual", "committed", "consistent"], id: \.self) { activity in
                    activityButton(activity)
                }
            }
            
            HStack(spacing: 4) {
                Image(systemName: "hand.tap.fill").font(.system(size: 11))
                Text("Tap to select and see your weekly step goal")
                    .font(.custom("Poppins-Regular", size: 12))
            }
            .foregroundStyle(Color(hex: "#595880").opacity(0.6))
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 8)
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func activityButton(_ activity: String) -> some View {
        FlippableButton(
            activity: activity,
            selectedActivity: selectedActivity,
            isFlipped: false,
            onSelect: { selectedActivity = activity },
            onTap: {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    if selectedActivity == activity {
                        selectedActivity = nil
                        goalSettings.activityLevel = ""
                    } else {
                        selectedActivity = activity
                        goalSettings.activityLevel = activity
                    }
                }
            },
            onLongPress: {}
        )
    }
}

// MARK: - Tree Name Card
private struct TreeNameCard: View {
    @Binding var treeName: String
    @Binding var showConfirmation: Bool
    @FocusState.Binding var isTextFieldFocused: Bool
    let goalSettings: GoalSettings
    
    var body: some View {
        VStack(spacing: 20) {
            Text("What do you want your tree to be named?")
                .font(.custom("Poppins-Bold", size: 20))
                .foregroundStyle(Color(hex: "#595880"))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            
            TextField("Enter tree name", text: $treeName)
                .font(.custom("Poppins-Regular", size: 16))
                .padding(16)
                .background(Color(hex: "#F5F5F8"))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            treeName.isEmpty ? Color(hex: "#7574A7").opacity(0.3) : Color(hex: "#7574A7"),
                            lineWidth: 2
                        )
                )
                .submitLabel(.done)
                .focused($isTextFieldFocused)
                .onSubmit { isTextFieldFocused = false }
                .id("textField")
            
            Button(action: confirmAction) {
                HStack {
                    Image(systemName: showConfirmation ? "checkmark.circle.fill" : "checkmark.circle")
                        .font(.system(size: 16, weight: .semibold))
                    Text(showConfirmation ? "Confirmed!" : "Confirm")
                        .font(.custom("Poppins-SemiBold", size: 16))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    !treeName.trimmingCharacters(in: .whitespaces).isEmpty
                        ? Color(hex: "#7574A7")
                        : Color(hex: "#7574A7").opacity(0.5)
                )
                .cornerRadius(12)
            }
            .disabled(treeName.trimmingCharacters(in: .whitespaces).isEmpty)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showConfirmation)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 8)
        .padding(.horizontal, 20)
    }
    
    private func confirmAction() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        isTextFieldFocused = false
        goalSettings.treeName = treeName
        showConfirmation = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showConfirmation = false
                treeName = ""
            }
        }
    }
}

// MARK: - Bottom Navigation Bar
private struct BottomNavigationBar: View {
    @Binding var isDismissing: Bool
    let onDismiss: () -> Void
    
    var body: some View {
        if !isDismissing {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.white)
                    .frame(height: 80)
                    .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: -5)
                    .offset(y: 30)
                    .ignoresSafeArea(edges: .bottom)
                    .allowsHitTesting(false)
                
                Button {
                    isDismissing = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        onDismiss()
                    }
                } label: {
                    Image(systemName:"arrow.down")
                        .font(Font.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .opacity(0.8)
                }
                .buttonStyle(GlassButtonStyle())
                .offset(y: 30)
            }
        }
    }
}

#Preview {
    GoalView(goalSettings: GoalSettings(), onDismiss: {})
}
