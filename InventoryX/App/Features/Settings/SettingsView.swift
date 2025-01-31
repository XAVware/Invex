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
    @EnvironmentObject var lsxVM: LSXViewModel

    @ObservedResults(CompanyEntity.self) var companies
    
    // This could be causing lock screen to dismiss on orientation change.
    @State var showingLockScreen: Bool = false
    
    var body: some View {
        FormX(title: "Settings") {
            FormSectionX(title: "Profile") {
                VStack(spacing: 0) {
                    Button("Account", systemImage: "person") { pushView(.company) }
                        .buttonStyle(MenuButtonStyle())
                } //: VStack
            }
            
            FormSectionX(title: "Legal") {
                Link(destination: K.termsOfServiceURL) {
                    HStack {
                        Image(systemName: "newspaper")
                        Text("Terms of Service")
                    }
                }
                .buttonStyle(MenuButtonStyle(trailingIcon: "arrow.up.right"))
                
                DividerX()
                
                Link(destination: K.privacyPolicyURL) {
                    HStack {
                        Image(systemName: "newspaper")
                        Text("Privacy Policy")
                    }
                }
                .buttonStyle(MenuButtonStyle(trailingIcon: "arrow.up.right"))
            }
            
            Text("© 2024 XAVware, LLC. All Rights Reserved.")
                .font(.caption2)
                .opacity(0.8)
                .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
    } //: Body
    
    // MARK: - Functions
    private func lockTapped() {
        showingLockScreen.toggle()
    }
    
    private func pushView(_ view: LSXDisplay) {
        navService.path.append(view)
    }
    
    private func changeTab(to view: LSXDisplay) {
        lsxVM.mainDisplay = view
    }
}

#Preview {
    SettingsView()
        .environment(\.realm, DepartmentEntity.previewRealm)
        .environmentObject(LSXViewModel())
        .environment(NavigationService())
}
