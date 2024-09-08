//
//  SettingsView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 6/4/23.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.verticalSizeClass) var vSize
    @Environment(\.horizontalSizeClass) var hSize
    @StateObject var settingsVM: SettingsViewModel = SettingsViewModel()
    
    @State var showPasscodeView: Bool = false
    @State var showDeleteConfirmation: Bool = false
    
    @State var colVis: NavigationSplitViewVisibility = .doubleColumn
    @State var prefCol: NavigationSplitViewColumn = .content
    
    enum Detail { case account, passcode }
    @State var currentDetail: Detail?
    
    var body: some View {
        NavigationSplitView(columnVisibility: $colVis, preferredCompactColumn: $prefCol) {
            ZStack {
                NeomorphicCardView(layer: .over)
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    NavigationLink {
                        CompanyDetailView()
                            .toolbar(vSize == .regular && hSize == .regular ? .visible : .hidden, for: .tabBar)
                    } label: {
                        HStack(spacing: 24) {
                            Text("Company Info")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Image(systemName: "chevron.right")
                        }
                        .foregroundStyle(Color.textPrimary.opacity(0.9))
                    }
                    .buttonStyle(MenuButtonStyle())
                    
                    
                    NavigationLink {
                        PasscodeView(processes: [.confirm, .set]) { }
                    } label: {
                        HStack(spacing: 24) {
                            Text("Change Passcode")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Image(systemName: "chevron.right")
                        }
                        .foregroundStyle(Color.textPrimary.opacity(0.9))
                    }
                    .buttonStyle(MenuButtonStyle())
                    
                    Spacer()
                    
                } //: VStack
                .padding()

            } //: ZStack
            .padding()
            .background(Color.bg)
            .navigationTitle("Settings")
            .toolbar(removing: .sidebarToggle)
            .toolbar(.visible, for: .tabBar)
        } detail: {
            if hSize == .regular {
                CompanyDetailView()
            }
        }
        .navigationSplitViewStyle(.balanced)
        
        
        
    } //: Body
    
}

#Preview {
    SettingsView()
        .environment(\.realm, DepartmentEntity.previewRealm)
}
