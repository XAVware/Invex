//
//  LandingView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 8/15/24.
//

import SwiftUI

struct LandingView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var hSize
    @Environment(\.verticalSizeClass) var vSize
    
    @State var index: Int = 0
    
    private let highlights: [LandingHighlight] = [
        LandingHighlight(imageName: "LandingImage", title: "Welcome!", caption: "Transform your workflow with Invex - Point of Sale designed for cash-run businesses."),
        
        LandingHighlight(imageName: "InventoryManagement", title: "Simple Inventory Management", caption: "Stay on top of your inventory levels with proactive reorder notifications."),
        
        LandingHighlight(imageName: "CustomerExperience", title: "Enhance Customer Experience", caption: "Reduce your checkout times without our easy to use dashboard."),
        
        //        LandingHighlight(imageName: "Insights", title: "Insights at Your Fingertips", caption: "Plan ahead with detailed analytics and reports.")
    ]
    
    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height
            let layout = isLandscape ? AnyLayout(HStackLayout(alignment: .center)) : AnyLayout(VStackLayout(alignment: .leading))
            VStack(spacing: 0) {
                let fontStyle = vSize == .regular ? Font.TextStyle.largeTitle : Font.TextStyle.title2
                Text("Invex")
                    .font(.system(fontStyle, design: .rounded, weight: .semibold))
                    .foregroundStyle(.accent)
                    .padding(.vertical)
                
                DividerX()
                
                TabView(selection: $index.animation(.snappy)) {
                    ForEach(highlights) { highlight in
                        VStack {
                            layout {
                                HexImage(imageName: highlight.imageName)
                                    .padding()
                                    .frame(maxWidth: 540, maxHeight: 540)
                                Spacer()
                                LandingHighlightTextView(highlight: highlight)
                                    .padding()
                                    .frame(maxWidth: 540, maxHeight: 240)
                            }
                        } //: VStack
                        .padding(.leading, max(8, geo.safeAreaInsets.leading)) // Padding on side of NeoCard. Use the width of safe areas unless they're less than 8
                        .padding(.trailing, max(8, geo.safeAreaInsets.trailing))
                        .tag(highlights.firstIndex(of: highlight)!)
                    } //: For Each
                } //: TabView
                .ignoresSafeArea()
                .tabViewStyle(.page(indexDisplayMode: .never))
                .overlay(index == highlights.count - 1 ? disclaimer : nil, alignment: .bottom)
                
                DividerX()
                
                navigationPanel
                    .padding()
            } //: VStack
            .frame(maxWidth: .infinity)
        } //: Geometry Reader
    } //: Body
    
    private var navigationPanel: some View {
        HStack {
            Button("Back", systemImage: "chevron.left", action: backTapped)
                .buttonStyle(.borderless)
                .padding(12)
                .opacity(index == 0 ? 0 : 1)
            
            Spacer()
            
            ForEach(highlights) { highlight in
                let isCurrent = highlight.id == highlights[index].id
                Circle()
                    .fill(Color.accent)
                    .frame(width: isCurrent ? 12 : 10, height: isCurrent ? 12 : 11)
                    .opacity(isCurrent ? 1 : 0.25)
            }
            
            Spacer()
            
            let nextBtnText: String = index == highlights.count - 1 ? "Sign Up" : "Next"
            Button(nextBtnText, systemImage: "chevron.right", action: nextTapped)
                .font(.headline)
                .buttonStyle(.borderedProminent)
                .labelStyle(.trailingImage)
        } //: HStack
        .buttonBorderShape(.roundedRectangle)
        .controlSize(.large)
        .frame(maxWidth: .infinity, maxHeight: 54)
        .fontDesign(.rounded)
    }
    
    private var disclaimer: some View {
        VStack {
            Text("By using Invex, you consent to our")
            HStack(spacing: 6) {
                Link("Terms of Service", destination: K.termsOfServiceURL)
                    .underline()
                Text("and")
                Link("Privacy Policy", destination: K.privacyPolicyURL)
                    .underline()
            }
            .buttonStyle(PlainButtonStyle())
        } //: VStack
        .font(.system(.caption2, design: .rounded))
        .padding()
    }
    
    // MARK: - Functions
    
    private func nextTapped() {
        if index == highlights.count - 1 {
            dismiss()
        } else {
            withAnimation(.snappy) {
                index += 1
            }
        }
    }
    
    private func backTapped() {
        guard index != 0 else { return }
        withAnimation(.snappy) {
            index -= 1
        }
    }
}

#Preview {
    LandingView()
}





