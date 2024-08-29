//
//  LandingView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 8/15/24.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")

        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let red = Double((rgbValue & 0xff0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00ff00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000ff) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}


struct LandingView: View {
    @Environment(\.horizontalSizeClass) var hSize
    @Environment(\.verticalSizeClass) var vSize
    
    @Binding var path: NavigationPath
    
    let highlights: [LandingHighlight] = [
        LandingHighlight(iconName: "archivebox", title: "Simple Inventory Management", caption: "Stay on top of your inventory levels with proactive reorder notifications."),
        
        LandingHighlight(iconName: "archivebox", title: "Enhanced Customer Experience", caption: "Reduce checkout times without our easy to use dashboard."),
        
        LandingHighlight(iconName: "archivebox", title: "Insights at Your Fingertips", caption: "Plan ahead with detailed analytics and reports.")
    ]
    
    var body: some View {
        GeometryReader { geo in
            if geo.size.width > geo.size.height {
                HStack(alignment: .top, spacing: 24) {
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                image
                                    .frame(maxWidth: geo.size.height * 0.4)
                                    .opacity(0.8)
                                    .rotationEffect(Angle(degrees: -12))
                                 Spacer()
                            }
                            
                            Text("Welcome to Invex")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundStyle(.accent)
                            
                            Text("The point of sale app built for small businesses, so you can focus on doing what you do best.")
                                .font(.headline)
                                .fontWeight(.regular)
                        } //: VStack
                        .fontDesign(.rounded)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
//                            .frame(minHeight: 48, maxHeight: 72)
                        
                        getStartedButton
                    } //: VStack
                    .padding()
//                    .padding(.horizontal, vSize == .regular ? 16 : 0)
//                    .frame(maxWidth: 560)
                    
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 12)
//                            .fill(
//                                .shadow(.inner(color: .neoUnderDark, radius: 2, x: 2, y: 2))
//                                .shadow(.inner(color: .neoUnderLight, radius: 2, x: -3, y: -3))
//                            )
//                            .foregroundColor(.neoUnderBg)
//                        
//                        VStack(alignment: .center, spacing: vSize == .regular ? 24 : 16) {
//                            ForEach(highlights) { highlight in
//                                LandingHighlightView(highlight: highlight, vSize: self.vSize)
//                                    .padding(vSize == .regular ? 16 : 8)
//                            }
//                        }
//                    }
//                    .frame(maxWidth: 480, maxHeight: .infinity)
//                    .padding()
                    

                    
                    VStack(alignment: .center, spacing: vSize == .regular ? 24 : 16) {
                        ForEach(highlights) { highlight in
                            LandingHighlightView(highlight: highlight, vSize: self.vSize)
                                .padding(vSize == .regular ? 16 : 8)
                        }
                    } //: VStack
                    .padding()
                    .frame(maxWidth: 480, maxHeight: .infinity)
                    .modifier(NeoUnderShadowMod())
                } //: HStack
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.bg.ignoresSafeArea())
            } else {
                VStack {
                    image
                        .frame(maxWidth: 240)
                    
                    Text("Welcome to Invex")
                        .padding()
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(.accent)
                        .fontDesign(.rounded)
                        .frame(maxWidth: 560, alignment: .leading)
                    
                    TabView {
                        VStack(alignment: .center) {
                            introPanel
                                .padding()
                                .fontDesign(.rounded)
                                .frame(maxWidth: 560, alignment: .leading)
                            
                            Spacer()
                        } //: VStack

                        VStack(alignment: .center) {
                            highlightsView
                                .frame(maxWidth: 560)
//                                .modifier(NeoUnderShadowMod())
                                .padding()
                            
                            Spacer()
                        } //: VStack
//                        .frame(maxWidth: .infinity)
//                        .background(Color.bg.ignoresSafeArea())
                    } //: Tab View
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
//                    .modifier(NeoUnderShadowMod())
                    .padding()
                    
                    getStartedButton
                } //: VStack
                .frame(maxWidth: .infinity)
                .background(Color.bg.ignoresSafeArea())
            } //: If-Else
        } //: Geometry Reader
    } //: Body
    
    private var image: some View {
        Image("LandingImage")
            .resizable()
            .scaledToFit()
    } //: Image
    
    private var getStartedButton: some View {
        Button {
            path.append(LSXDisplay.company(CompanyEntity(), .onboarding))
        } label: {
            Spacer()
            Text("Get Started")
            Spacer()
        }
        .modifier(PrimaryButtonMod())
        .padding(.bottom)
    }
    
    private var introPanel: some View {
        VStack(alignment: .leading, spacing: 12) {

            Spacer()
            Text("The point of sale app built for small businesses, so you can focus on doing what you do best.")
                .font(.title3)
                .fontWeight(.regular)
            Spacer()
        } //: VStack
    }
    
    
    
    private var highlightsView: some View {
        VStack(alignment: .center, spacing: vSize == .regular ? 24 : 16) {
            ForEach(highlights) { highlight in
                LandingHighlightView(highlight: highlight, vSize: self.vSize)
                    .padding(vSize == .regular ? 16 : 8)
            }
        }
    }
}

#Preview {
    LandingView(path: .constant(.init()))
}
