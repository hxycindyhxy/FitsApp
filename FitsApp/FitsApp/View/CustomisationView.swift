//
//  TreeShopView.swift
//  FitsApp
//
//  Created by Angelo Sayas on 7/11/2025.
//

import SwiftUI

let TreeTypes = ["Tree3", "Tree5", "Tree1", "Tree2", "Tree4", "Tree6"]
let TreeName = ["Candy", "Pine", "Oak", "Autumn", "Maple",  "Cherry"]
let BackgroundVer = ["TreeSelectBgd", "TreeSelectTrue"]
let PriceString = ["15K", "30K", "50K", "75K", "100K", "150K"]
let Prices = [15000, 30000, 50000, 75000, 100000, 150000]

struct CustomisationView: View {
    
    @AppStorage("selectedTreeIndex") private var selectedTreeIndex: Int = 0
    @State private var waterCurrency: Int = 30000
    @State private var unlockedTrees: [Bool] = [true, false, false, false, false, false]
    @State private var shakeIndex: Int? = nil
    
    var body: some View {
        ZStack() {
            //Background
            ScrollView(.vertical) {
                Image("TreeShopBgd")
                    .clipped()
            }
            
            //TreeSelect List
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20) {
                    ForEach(0..<TreeTypes.count, id: \.self) { index in
                        TreeSelectOptionsWithShake(
                            xPlace: 0,
                            yPlace: 0,
                            TreeTypeNum: index,
                            Scale: 0.9,
                            isSelected: selectedTreeIndex == index,
                            isLocked: !unlockedTrees[index],
                            price: index,
                            shouldShake: shakeIndex == index,
                            onSelect: {
                                if unlockedTrees[index] {
                                    selectedTreeIndex = index
                                } else {
                                    if waterCurrency >= Prices[index] {
                                        waterCurrency -= Prices[index]
                                        unlockedTrees[index] = true
                                        selectedTreeIndex = index
                                    } else {
                                        // Not enough currency - trigger shake
                                        shakeIndex = index
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            shakeIndex = nil
                                        }
                                    }
                                }
                            }
                        )
                    }
                    ForEach(0..<3) { index in
                        ComingSoonSlots(
                            xPlace: 0,
                            yPlace: 0,
                            Price: 1000000000,
                            Scale: 0.9,
                            shouldShake: shakeIndex == (6 + index), // Offset by 6 to avoid conflicts with real trees
                            onSelect: {
                                // Always trigger shake since it can never be bought
                                shakeIndex = 6 + index
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    shakeIndex = nil
                                }
                            }
                        )
                    }
                }
                .padding(.vertical, 100)
                .padding(.horizontal, 20)
                
                
                
                
            }
            .frame(width: 420, height: 750)
            .offset(y:20)
            
            //Mid Section, interactable
            Image("MrWorm")
                .resizable()
                .frame(width:50, height: 140)
                .rotationEffect(.degrees(35))
                .offset(x:-175, y: 270)
            
            //Foreground Dirt
            VStack(alignment: .center) {
                ZStack() {
                    Image("DirtFrontLayer")
                        .resizable()
                        .frame(width: 700, height: 200)
                        .padding(.bottom, 510)
                    Text("Customise")
                        .offset(y:-240)
                        .font(.custom("Poppins-Bold", size: 40))
                    
                    Image("WaterCurrencyBgd")
                        .resizable()
                        .frame(width: 136, height: 50)
                        .offset(x:139, y:-180)
                    Text(String(waterCurrency))
                        .offset(x:140, y:-180)
                        .font(.custom("Poppins-Regular", size: 20))
                }
                
                Image("DirtFrontLayer")
                    .resizable()
                    .frame(width: 500, height: 180)
                    .scaleEffect(x: -1, y: -1)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct TreeSelectOptionsWithShake: View {
    
    let xPlace: Int
    let yPlace: Int
    let TreeTypeNum: Int
    let Scale: Double
    let isSelected: Bool
    let isLocked: Bool
    let price: Int
    let shouldShake: Bool
    let onSelect: () -> Void
    
    @State private var shakeOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            Image(isSelected ? "TreeSelectTrue" : "TreeSelectBgd")
                .resizable()
                .frame(width: 130, height: 220)
                .offset(x: CGFloat(xPlace), y: CGFloat(yPlace))
            Text(TreeName[TreeTypeNum])
                .offset(y:-80)
                .font(.custom("Poppins-Regular", size: 20))
            Image(TreeTypes[TreeTypeNum])
                .resizable()
                .frame(width: 100, height: 150)
                .offset(y: 24)
            if isLocked {
                TreeShopUnbought(price2: price)
            }
        }
        .scaleEffect(Scale)
        .offset(x: shakeOffset)
        .onChange(of: shouldShake) {
            if shouldShake {
                withAnimation(.easeInOut(duration: 0.1).repeatCount(5, autoreverses: true)) {
                    shakeOffset = 10
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    shakeOffset = 0
                }
            }
        }
        .onTapGesture {
            onSelect()
        }
    }
}
struct TreeSelectOptions: View {
    
    let xPlace: Int
    let yPlace: Int
    let TreeTypeNum: Int
    let Scale: Double
    let isSelected: Bool
    let isLocked: Bool
    let price: Int
    let onSelect: () -> Void
    
    @State private var shakeOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            Image(isSelected ? "TreeSelectTrue" : "TreeSelectBgd")
                .resizable()
                .frame(width: 130, height: 220)
                .offset(x: CGFloat(xPlace), y: CGFloat(yPlace))
            Text(TreeName[TreeTypeNum])
                .offset(y:-80)
                .font(.custom("Poppins-Regular", size: 20))
            Image(TreeTypes[TreeTypeNum])
                .resizable()
                .frame(width: 100, height: 150)
                .offset(y: 24)
            if isLocked {
                TreeShopUnbought(price2: price)
            }
        }
        .scaleEffect(Scale)
        .offset(x: shakeOffset)
        .onTapGesture {
            onSelect()
        }
    }
    
    func triggerShake() {
        withAnimation(.easeInOut(duration: 0.1).repeatCount(5, autoreverses: true)) {
            shakeOffset = 10
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            shakeOffset = 0
        }
    }
}

struct TreeShopUnbought: View {
    let price2: Int
    
    var body: some View {
        ZStack {
            Image("LockedScreen")
                .resizable()
                .frame(width:130, height: 220)
            Image("LockIcon")
                .resizable()
                .frame(width: 80, height: 80)
                .aspectRatio(contentMode: .fit)
            Image("WaterCurrency")
                .resizable()
                .frame(width: 14, height: 28)
                .aspectRatio(contentMode: .fit)
                .offset(x: -23, y: 17)
            Text(PriceString[price2])
                .offset(x:10, y:18)
                .font(.custom("Poppins-Regular", size: 18))
        }
        .frame(width: 130, height: 220)
    }
}

struct ComingSoonSlots: View {
    
    let xPlace: Int
    let yPlace: Int
    let Price: Int
    let Scale: Double
    let shouldShake: Bool
    let onSelect: () -> Void
    
    @State private var shakeOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            Image("ComingSoonTree")
                .resizable()
                .frame(width: 130, height: 220)
                .offset(x: CGFloat(xPlace), y: CGFloat(yPlace))
            Text("Coming Soon")
                .offset(y:-60)
                .font(.custom("Poppins-Regular", size: 15))
        }
        .scaleEffect(Scale)
        .offset(x: shakeOffset)
        .onChange(of: shouldShake) {
            if shouldShake {
                withAnimation(.easeInOut(duration: 0.1).repeatCount(5, autoreverses: true)) {
                    shakeOffset = 10
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    shakeOffset = 0
                }
            }
        }
        .onTapGesture {
            onSelect()
        }
    }
}

struct ConfirmBuy: View {
    var body: some View {
        
    }
}

#Preview {
    CustomisationView()
    //ComingSoonSlots()
}
