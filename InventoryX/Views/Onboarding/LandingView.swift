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
    var isIphone: Bool { hSize == .compact || vSize == .compact }
    
    @State var index: Int = 0
    @Binding var path: NavigationPath
    
    let highlights: [LandingHighlight] = [
        LandingHighlight(imageName: "LandingImage", title: "Welcome!", caption: "Transform your workflow with Invex - Point of Sale designed for cash-run businesses."),
        
        LandingHighlight(imageName: "InventoryManagement", title: "Simple Inventory Management", caption: "Stay on top of your inventory levels with proactive reorder notifications."),
        
        LandingHighlight(imageName: "CustomerExperience", title: "Enhance Customer Experience", caption: "Reduce your checkout times without our easy to use dashboard."),
        
        //        LandingHighlight(imageName: "Insights", title: "Insights at Your Fingertips", caption: "Plan ahead with detailed analytics and reports.")
    ]
    
    private func nextTapped() {
        if index == highlights.count - 1 {
            dismiss()
            path.append(LSXDisplay.company)
        } else {
            withAnimation(.snappy) {
                index += 1
            }
        }
    }
    
    private func backTapped() {
        withAnimation(.snappy) {
            index -= 1
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height
            
            VStack {
                Text("Invex")
                    .font(vSize == .regular ? .largeTitle : .title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.accent)
                    .fontDesign(.rounded)
                    .padding(.top)
                
                TabView(selection: $index.animation(.snappy)) {
                    ForEach(highlights) { highlight in
                        VStack {
                            if isLandscape {
                                HStack(alignment: .center) {
                                    HexImage(imageName: highlight.imageName)
                                        .padding()
                                        .frame(maxWidth: 540, maxHeight: 540)
                                    Spacer()
                                    LandingHighlightTextView(highlight: highlight)
                                        .padding()
                                        .frame(maxWidth: 540, maxHeight: 240)
                                } //: HStack
                                .frame(maxWidth: 1150)
                            } else {
                                VStack(alignment: .leading) {
                                    HexImage(imageName: highlight.imageName)
                                        .padding()
                                        .frame(maxWidth: 540, maxHeight: 540)
                                    
                                    LandingHighlightTextView(highlight: highlight)
                                        .padding()
                                        .frame(maxWidth: 540, maxHeight: 240)
                                } //: VStack
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
                
                navigationPanel
            } //: VStack
            .frame(maxWidth: .infinity)
        } //: Geometry Reader
    } //: Body
    
    private var navigationPanel: some View {
        HStack {
            Button("Back", systemImage: "chevron.left", action: backTapped)
                .buttonStyle(ThemeButtonStyle(.secondary))
                .opacity(index == 0 ? 0 : 1)
            
            HStack(alignment: .center) {
                Spacer()
                ForEach(highlights) { highlight in
                    let isCurrent = highlight.id == highlights[index].id
                    Circle()
                        .fill(Color.accent)
                        .frame(width: isCurrent ? 12 : 10, height: isCurrent ? 12 : 11)
                        .opacity(isCurrent ? 1 : 0.25)
                    
                }
                Spacer()
            } //: HStack
            
            Button {
                backTapped()
            } label: {
                HStack {
                    Text(index == highlights.count - 1 ? "Sign Up" : "Next")
                    Image(systemName: "chevron.right")
                }
            }
            .buttonStyle(ThemeButtonStyle(cornerRadius: 8))
        } //: HStack
        .frame(height: 48)
        .frame(maxWidth: .infinity)
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
        .font(.caption2)
        .padding()
    }
}

#Preview {
    LandingView(path: .constant(.init()))
}





