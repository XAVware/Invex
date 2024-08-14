//
//  OnboardingView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/24/23.
//

import SwiftUI
import RealmSwift

struct OnboardingView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var hSize
    @Environment(\.verticalSizeClass) var vSize
//    @EnvironmentObject var navVM: LazySplitViewModel
//    @State var selectedView: Int = 0
    
    @State var path: NavigationPath = .init()
    
    var body: some View {
        //        TabView(selection: $selectedView) {
        //            VStack {
        //                LogoView()
        //
        //                Image("LandingImage")
        //                    .resizable()
        //                    .scaledToFit()
        //                    .frame(minWidth: 240, maxWidth: 420)
        //
        //                Button {
        //                    selectedView += 1
        //                } label: {
        //                    Spacer()
        //                    Text("Continue")
        //                    Spacer()
        //                }
        //                .modifier(PrimaryButtonMod())
        //
        //            } //: VStack
        //            .toolbar(content: {
        //                ToolbarItem(placement: .keyboard) {
        //                    Button {
        //                        selectedView += 1
        //                    } label: {
        //                        Spacer()
        //                        Text("Continue")
        //                        Spacer()
        //                    }
        //                    .modifier(PrimaryButtonMod())
        //                }
        //            })
        //            .frame(maxWidth: .infinity, maxHeight: .infinity)
        //            .tag(0)
        //
        //            CompanyDetailView(company: nil, detailType: .onboarding)
        //                .navigationTitle("Welcome!")
        //                .navigationBarTitleDisplayMode(.large)
        //                .tag(1)
        //
        //
        //            DepartmentDetailView(department: nil, detailType: .onboarding)
        //                .tag(2)
        //
        //            ItemDetailView(item: nil, detailType: .onboarding)
        //                .tag(3)
        //
        //
        //            PasscodeView(processes: [.set]) {
        //                LazySplitService.shared.pushPrimary(DetailPath.department(nil, .onboarding))
        //            }
        //            .tag(4)
        //
        //        }
        
        
        NavigationStack(path: $path) {
            
            landingPage
            
                .navigationDestination(for: DetailPath.self) { view in
                    switch view {
                    case .company(let c, let t):
                        CompanyDetailView(company: c, detailType: t) {
                            path.append(DetailPath.passcodePad([.set]))
                        }
                        
                    case .passcodePad(let p):
                        PasscodeView(processes: p) {
                            path.append(DetailPath.department(nil, .onboarding))
                        }
                        
                    case .department(let d, let t):
                        DepartmentDetailView(department: d, detailType: t) {
                            path.append(DetailPath.item(nil, .onboarding))
                        }
                        
                    case .item(let i, let t):
                        ItemDetailView(item: i, detailType: t) {
                            dismiss()
                        }
                        
                    default: Color.black
                    }
                    
                } // Navigation Stack
                
        }
        
    } //: Body
    
    @ViewBuilder private var landingPage: some View {
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height
            if isLandscape {
                HStack(alignment: .top, spacing: 24) {
                    
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 0) {
                        Spacer()
                        
                        Image("LandingImage")
                            .resizable()
                            .scaledToFit()
                        
                        introPanel
                            .padding(.vertical)
                            .fontDesign(.rounded)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        getStartedButton
                    } //: VStack
                    .frame(maxWidth: 560)
                    .padding(.horizontal, vSize == .regular ? 16 : 0)
                    
                    Spacer()
                    highlights
                        .padding()
                        .frame(maxWidth: 480, maxHeight: .infinity)
                        .modifier(NeoUnderShadowMod())
                } //: HStack
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.bg.ignoresSafeArea())
            } else {
                VStack(alignment: .center) {
                    
                    Image("LandingImage")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 560)
                    
                    introPanel
                        .padding()
                        .fontDesign(.rounded)
                        .frame(maxWidth: 560, alignment: .leading)
                    
                    Spacer()
                    highlights
                        .frame(maxWidth: 560)
                        .modifier(NeoUnderShadowMod())
                        .padding()
                    
                    Spacer()
                    getStartedButton
                } //: VStack
                .frame(maxWidth: .infinity)
                .background(Color.bg.ignoresSafeArea())
            }
        }
    }
    
    private var getStartedButton: some View {
        Button {
            path.append(DetailPath.company(CompanyEntity(), .onboarding))
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
            Text("Welcome!")
                .font(vSize == .regular ? .largeTitle : .title)
                .fontWeight(.semibold)
                .foregroundStyle(.accent)
            
            Text("Invex Point of Sale for small businesses.")
                .font(.title3)
                .fontWeight(.regular)
            
        } //: VStack
    }
    
    private var highlights: some View {
        VStack(alignment: .center, spacing: vSize == .regular ? 24 : 16) {
            LandingHighlight(imageName: "archivebox", title: "Simple Setup", caption: "Start selling in minutes. Easy setup with no training required.", vSize: self.vSize)
                .padding(vSize == .regular ? 16 : 8)
            
            LandingHighlight(imageName: "archivebox", title: "Simple Setup", caption: "Start selling in minutes. Easy setup with no training required.", vSize: self.vSize)
                .padding(vSize == .regular ? 16 : 8)
            
            LandingHighlight(imageName: "archivebox", title: "Simple Setup", caption: "Start selling in minutes. Easy setup with no training required.", vSize: self.vSize)
                .padding(vSize == .regular ? 16 : 8)
        }
        
    }
    
    
    struct LandingHighlight: View {
        let imageName: String
        let title: String
        let caption: String
        let vSize: UserInterfaceSizeClass?
        
        var body: some View {
            HStack(spacing: 16) {
                Image(systemName: imageName)
                    .foregroundStyle(.accent)
                    .padding(6)
                    .font(vSize == .regular ? .largeTitle : .title2)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.headline)
                    
                    Text(caption)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .frame(minHeight: 42)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } //: HStack
        }
    }
}

#Preview {
    OnboardingView()
        .environment(\.realm, DepartmentEntity.previewRealm)
}
