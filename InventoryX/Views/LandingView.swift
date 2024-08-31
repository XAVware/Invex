//
//  LandingView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 8/15/24.
//

import SwiftUI

struct LandingView: View {
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
    
    var body: some View {
        ZStack {
            if vSize == .regular {
                Color.bg.ignoresSafeArea()
            } else {
                Color.neoUnderBg.ignoresSafeArea()
            }
            
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
                            ZStack(alignment: .center) {
                                /// If the screen is large enough, place a NeomorphicCard behind the content to give the illusion of depth
                                if vSize == .regular {
                                    NeomorphicCardView(layer: .under)
                                }
                                
                                if isLandscape {
                                    HStack(alignment: .center) {
                                        HexImage(imageName: highlight.imageName)
                                            .padding()
                                            .frame(maxWidth: 540, maxHeight: 540)
                                        Spacer()
                                        LandingHighlightTextView(highlight: highlight)
                                            .padding()
                                            .frame(maxWidth: 540, maxHeight: 240)
                                        
                                    }
                                    .frame(maxWidth: 1150)
                                } else {
                                    VStack(alignment: .leading) {
                                        
                                        HexImage(imageName: highlight.imageName)
                                            .padding()
                                            .frame(maxWidth: 540, maxHeight: 540)
                                        
                                        LandingHighlightTextView(highlight: highlight)
                                            .padding()
                                            .frame(maxWidth: 540, maxHeight: 240)
                                        
                                    }
                                    .padding(isIphone ? 12 : 0)
                                }
                                
                            } //: ZStack
                            .padding(.leading, max(8, geo.safeAreaInsets.leading)) // Padding on side of NeoCard. Use the width of safe areas unless they're less than 8
                            .padding(.trailing, max(8, geo.safeAreaInsets.trailing))
                            
                            .tag(highlights.firstIndex(of: highlight)!)
                        } //: For Each
                    } //: TabView
                    .ignoresSafeArea()
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                    navigationPanel
                    
                } //: VStack
            } //: Geometry Reader
        } //: ZStack
    } //: Body
    
    private var navigationPanel: some View {
        HStack {
            Button("Back", systemImage: "chevron.left") {
                withAnimation(.snappy) {
                    index -= 1
                }
            }
            .buttonStyle(ThemeButtonStyle(.secondary))
            .opacity(index == 0 ? 0 : 1)
            
            Spacer()
            
            HStack(alignment: .center) {
                ForEach(highlights) { highlight in
                    let isCurrent = highlight.id == highlights[index].id
                    Circle()
                        .fill(Color.accent)
                        .frame(width: isCurrent ? 12 : 10, height: isCurrent ? 12 : 11)
                        .opacity(isCurrent ? 1 : 0.25)
                    
                }
            } //: HStack
            
            Spacer()
            
            Button {
                if index == highlights.count - 1 {
                    path.append(LSXDisplay.company(CompanyEntity(), .onboarding))
                } else {
                    withAnimation(.snappy) {
                        index += 1
                    }
                }
            } label: {
                HStack {
                    Text(index == highlights.count - 1 ? "Sign Up" : "Next")
                    Image(systemName: "chevron.right")
                }
            }
            .buttonStyle(ThemeButtonStyle())
        }
        .padding()
        .frame(height: 48)
        .padding(isIphone ? 8 : 12) // Remove for hexagon style
    }
}

#Preview {
    LandingView(path: .constant(.init()))
}





