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
    @EnvironmentObject var navVM: LazySplitViewModel
    @State var selectedView: Int = 0
    
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
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Welcome to InveX")
                        .font(.title)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                        .foregroundStyle(.accent)
                    
                    
                    Text("The point of sale app designed for small businesses.")
                        .font(.headline)
                        .fontDesign(.rounded)
                        .fontWeight(.regular)
                }
                Spacer()
                
                Image("LandingImage")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 240, maxWidth: 420)
                
                Spacer()
                
                Button {
                    path.append(DetailPath.company(CompanyEntity(), .onboarding))
                } label: {
                    Spacer()
                    Text("Continue")
                    Spacer()
                }
                .modifier(PrimaryButtonMod())
                Spacer()
                
            } //: VStack
            .padding(.vertical)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationDestination(for: DetailPath.self) { view in
                switch view {
                case .company(let c, let t):
                    CompanyDetailView(company: c, detailType: t) {
                        path.append(DetailPath.passcodePad([.set]))
                    }
                    .navigationTitle("Welcome!")
                    .navigationBarTitleDisplayMode(.large)
                    
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
    
    
}

//#Preview {
//    OnboardingView()
//        .environment(\.realm, DepartmentEntity.previewRealm)
//}
