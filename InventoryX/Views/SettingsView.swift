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
//    @Environment(\.verticalSizeClass) var vSize
//    @Environment(\.horizontalSizeClass) var hSize
    @EnvironmentObject var lsxVM: LSXViewModel
//    @StateObject var settingsVM: SettingsViewModel = SettingsViewModel()
    
//    @State var showPasscodeView: Bool = false
//    @State var showDeleteConfirmation: Bool = false
    
    @ObservedResults(CompanyEntity.self) var companies
    
    // This could be causing lock screen to dismiss on orientation change.
    @State var showingLockScreen: Bool = false
    
    private func lockTapped() {
        showingLockScreen.toggle()
    }
    
    
    func pushView(_ view: LSXDisplay) {
        navService.path.append(view)
    }
    
    func changeTab(to view: LSXDisplay) {
        lsxVM.mainDisplay = view
    }
    
    var body: some View {
        ThemeForm {
//            VStack(spacing: 16) {
                
                ThemeFormSection(title: "Profile") {
                    VStack(spacing: 0) {
                        Button("Account", systemImage: "person") { pushView(.company) }
                            .buttonStyle(MenuButtonStyle())
                        FieldDivider()
                        Button("Change Passcode", systemImage: "asterisk") { pushView(.passcodePad([.confirm, .set])) }
                            .buttonStyle(MenuButtonStyle())
                    } //: VStack
                }
                
                ThemeFormSection(title: "Legal") {
                    VStack(spacing: 0) {
                        Link("Terms of Service", destination: K.termsOfServiceURL)
                            .buttonStyle(MenuButtonStyle(trailingIcon: "arrow.up.right"))
                        FieldDivider()
                        Link("Privacy Policy", destination: K.privacyPolicyURL)
                            .buttonStyle(MenuButtonStyle(trailingIcon: "arrow.up.right"))
                    } //: VStack
                }
                
                
            VStack(alignment: .leading, spacing: 8) {
                Button {
                    changeTab(to: .pos)
                } label: {
                    Text("Lock")
                        .font(.headline)
                        .underline()
                }
                .buttonStyle(.plain)
                
                Text("© 2024 XAVware, LLC. All Rights Reserved.")
                    .font(.caption2)
                    .opacity(0.8)
                    .padding(.vertical)
            }
            .padding(.vertical)
            
        }
        .navigationTitle("Menu")
        .navigationBarTitleDisplayMode(.inline)
    } //: Body
    
    
}

#Preview {
    SettingsView()
        .environment(\.realm, DepartmentEntity.previewRealm)
        .environmentObject(LSXViewModel())
        .environment(NavigationService())
}
