//
//  SettingsView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 6/4/23.
//

import SwiftUI
import RealmSwift

struct SettingsView: View {
    @Environment(NavigationService.self) var navService
    @Environment(\.verticalSizeClass) var vSize
    @Environment(\.horizontalSizeClass) var hSize
    @StateObject var settingsVM: SettingsViewModel = SettingsViewModel()
    
    @State var showPasscodeView: Bool = false
    @State var showDeleteConfirmation: Bool = false
    
    @State var colVis: NavigationSplitViewVisibility = .automatic
    @State var prefCol: NavigationSplitViewColumn = .sidebar
    
    @ObservedResults(CompanyEntity.self) var companies
    
    // This could be causing lock screen to dismiss on orientation change.
    @State var showingLockScreen: Bool = false
    
//    @Binding var path: NavigationPath
    enum Detail { case account, passcode }
    @State var currentDetail: Detail?
    
    private func lockTapped() {
        showingLockScreen.toggle()
    }
    
    var body: some View {
            ZStack {
                Color.bg.ignoresSafeArea()
                NeomorphicCardView(layer: .under)
                
                VStack {
                    
                    VStack(alignment: .leading) {
                        Button("Company Info", systemImage: "chevron.right") {
                            navService.path.append(LSXDisplay.company)
                        }
                        .buttonStyle(MenuButtonStyle())
                        
                        
                        Button("Change Passcode", systemImage: "chevron.right") {
                            navService.path.append(LSXDisplay.passcodePad([.confirm, .set]))
                        }
                        .buttonStyle(MenuButtonStyle())
                        
                        Button("Lock Screen", systemImage: "lock", action: lockTapped)
                            .buttonStyle(MenuButtonStyle())
                    } //: VStack
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Text("© 2024 XAVware, LLC. All Rights Reserved.")
                        HStack(spacing: 6) {
                            Link("Terms of Service", destination: K.termsOfServiceURL)
                            Text("-")
                            Link("Privacy Policy", destination: K.privacyPolicyURL)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                    }
                    .font(.caption2)
                    .foregroundStyle(.accent)
                    .opacity(0.7)
                } //: VStack
                .padding()
            } //: ZStack
            .navigationTitle("Account")
            .padding()
            .fullScreenCover(isPresented: $showingLockScreen) {
                LockScreenView()
                    .frame(maxHeight: .infinity)
                    .background(Color.bg)
            }
    } //: Body
    
    
}

#Preview {
    SettingsView()
        .environment(\.realm, DepartmentEntity.previewRealm)
}
