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
            
//            HStack {
                
                
                FormSectionX(title: "Test Mode") {
                    
                    Text("To try out the app with sample inventory, go to Account and change your business name to 'TestMode' (case sensitive). This will erase your current data and restart the app.")
                    
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(12)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.accentColor.opacity(0.1), lineWidth: 1))
                .padding(.vertical, 16)
                .overlay(
                    Image(systemName: "lightbulb.max.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 32, maxHeight: 32)
                        .padding(12)
//                        .opacity(0.8)
                        .foregroundStyle(Color.textLight)
                        .background(
                            ZStack {
                                Color.bg100
                                Color.accentColor.opacity(0.5)
                            }
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.accentColor.opacity(0.1), lineWidth: 1))
                        .offset(x: -8, y: -8)
                    , alignment: .topTrailing)
                .padding(.vertical)
//            }
            
            
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
