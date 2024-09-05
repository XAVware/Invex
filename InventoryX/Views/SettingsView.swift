//
//  SettingsView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 6/4/23.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var settingsVM: SettingsViewModel = SettingsViewModel()
    
    @State var showPasscodeView: Bool = false
    @State var showDeleteConfirmation: Bool = false
    
    var body: some View {
        ZStack {
            NeomorphicCardView(layer: .under)
            
            VStack(alignment: .leading, spacing: 16) {
                
                Button {
                    LSXService.shared.update(newDisplay: .company(CompanyEntity(name: settingsVM.companyName, taxRate: Double(settingsVM.taxRateStr) ?? 0.0), .update))
                } label: {
                    HStack(spacing: 24) {
                        Text("Company Info")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: "chevron.right")
                    }
                    .foregroundStyle(Color.textPrimary.opacity(0.9)) 
                }
                .buttonStyle(MenuButtonStyle())
                .frame(maxHeight: 48)
                

                Divider()
                Button {
                    LSXService.shared.update(newDisplay: .passcodePad([.confirm, .set]))
                } label: {
                    HStack(spacing: 24) {
                        Text("Change Passcode")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: "chevron.right")
                    }
                    .foregroundStyle(Color.textPrimary.opacity(0.9))
                }
                .buttonStyle(MenuButtonStyle())
                .frame(maxHeight: 48)
                
                Spacer()
                
                Button {
                    //                LSXService.shared.popDetail()
                    showDeleteConfirmation = true
                    
                } label: {
                    HStack(spacing: 24) {
                        Text("Delete Account")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: "trash")
                    }
                    .foregroundStyle(Color.textPrimary.opacity(0.9))
                }
                .buttonStyle(MenuButtonStyle())
                
                
                .frame(maxHeight: 48)
                //                Spacer()
                
            } //: VStack
            
            .padding()
            .alert("Are you sure?", isPresented: $showDeleteConfirmation) {
                Button("Go back", role: .cancel) { }
                Button("Yes, delete account", role: .destructive) {
                    //                LSXService.shared.primaryRoot = .makeASale
                    //                LSXService.shared.detailRoot =  nil
                    //                LSXService.shared.primaryPath = .init()
                    //                LSXService.shared.detailPath = .init()
                    
                    Task {
                        await settingsVM.deleteAccount()
                    }
                }
            }
        } //: ZStack
        .padding()
        .background(Color.bg)
        
    } //: Body
    
}

#Preview {
    SettingsView()
        .environment(\.realm, DepartmentEntity.previewRealm)
}
