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
    
    @Binding var path: NavigationPath
    
    let highlights: [LandingHighlight] = [
        LandingHighlight(imageName: "LandingImage", title: "Welcome!", caption: "Point of Sale for small businesses."),
        
        LandingHighlight(imageName: "InventoryManagement", title: "Simple Inventory Management", caption: "Stay on top of your inventory levels with proactive reorder notifications."),
        
        LandingHighlight(imageName: "CustomerExperience", title: "Enhanced Customer Experience", caption: "Reduce checkout times without our easy to use dashboard."),
        
        LandingHighlight(imageName: "Insights", title: "Insights at Your Fingertips", caption: "Plan ahead with detailed analytics and reports.")
    ]
    
    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 16) {
                Text("Invex")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundStyle(.accent)
                    .fontDesign(.rounded)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                TabView {
                    ForEach(highlights) { highlight in
                        LandingHighlightView(highlight: highlight, vSize: self.vSize)
                            .padding(.horizontal)
                    }
                } //: TabView
                .ignoresSafeArea()
                .tabViewStyle(.page(indexDisplayMode: .always))
                
                PrimaryButton(label: "Get Started") {
                    path.append(LSXDisplay.company(CompanyEntity(), .onboarding))
                }
                
            } //: VStack
            .padding(.vertical)
        } //: ZStack
    } //: Body
    
}

#Preview {
    LandingView(path: .constant(.init()))
}


