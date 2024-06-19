//
//  SettingsView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 6/4/23.
//

import SwiftUI
//import RealmSwift

struct SettingsView: View {
//    @ObservedResults(CompanyEntity.self) var company
//    @ObservedResults(DepartmentEntity.self) var departments
//    @ObservedResults(ItemEntity.self) var items
    let termsOfServiceURL: URL = URL(string: "https://xavware.com/invex/termsOfService")!
    let privacyPolicyURL: URL = URL(string: "https://xavware.com/invex/privacyPolicy")!
    
    @StateObject var settingsVM: SettingsViewModel = SettingsViewModel()
    
    @State var showPasscodeView: Bool = false
    @State var showDeleteConfirmation: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                LazySplitService.shared.setDetailRoot(DetailPath.company(CompanyEntity(name: settingsVM.companyName, taxRate: Double(settingsVM.taxRateStr) ?? 0.0), .update))
            } label: {
                HStack {
                    Image(systemName: "case")
                        .frame(width: 24)
                    Text("Company Info")
                    Spacer()
                }
                .contentShape(Rectangle())
            }
            .padding(.vertical, 8)
            .foregroundStyle(.accent)
            
            Button {
                LazySplitService.shared.setDetailRoot(.passcodePad([.confirm, .set]))
            } label: {
                HStack {
                    Image(systemName: "lock")
                        .frame(width: 24)
                    Text("Change Passcode")
                    Spacer()
                }
                .contentShape(Rectangle())
            }
            .padding(.vertical, 8)
            .foregroundStyle(.accent)
            
            Button {
                LazySplitService.shared.popDetail()
                
                showDeleteConfirmation = true
            } label: {
                HStack {
                    Image(systemName: "trash")
                        .frame(width: 24)
                    Text("Delete Account")
                    Spacer()
                } //: HStack
                .contentShape(Rectangle())
            }
            .padding(.vertical, 8)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 12) {
                Link("Terms of Service", destination: termsOfServiceURL)
                Link("Privacy Policy", destination: privacyPolicyURL)
            } //: VStack
            .font(.footnote)
            
            Text("© 2024 XAVware, LLC. All Rights Reserved.")
                .font(.caption2)
                .padding(.top, 24)
                .foregroundStyle(.accent)
                .opacity(0.6)
        } //: VStack
        .padding()
        .background(Color.gray.opacity(0.1))
        //        .clipShape(RoundedCorner(radius: 24, corners: [.topRight, .bottomLeft]))
        //        .ignoresSafeArea(.all)
        .alert("Are you sure?", isPresented: $showDeleteConfirmation) {
            Button("Go back", role: .cancel) { }
            Button("Yes, delete account", role: .destructive) {
                LazySplitService.shared.primaryRoot = .makeASale
                LazySplitService.shared.detailRoot =  nil
                LazySplitService.shared.primaryPath = .init()
                LazySplitService.shared.detailPath = .init()
                
                Task {
                    await settingsVM.deleteAccount()
                }
            }
        }
        
    } //: Body
    
}

#Preview {
    SettingsView()
        .environment(\.realm, DepartmentEntity.previewRealm)
}
