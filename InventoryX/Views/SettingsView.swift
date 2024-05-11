//
//  SettingsView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 6/4/23.
//

import SwiftUI
import RealmSwift

struct SettingsView: View {
    let termsOfServiceURL: URL = URL(string: "https://xavware.com/invex/termsOfService")!
    let privacyPolicyURL: URL = URL(string: "https://xavware.com/invex/privacyPolicy")!
    
    @StateObject var settingsVM: SettingsViewModel = SettingsViewModel()
    
    @State var showingCompanyDetail: Bool = false
    @State var showPasscodeView: Bool = false
    @State var showDeleteConfirmation: Bool = false
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Settings")
                .modifier(TitleMod())
            
            
            VStack {
                
                VStack {
                    
                    Button {
                        showingCompanyDetail = true
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
                    .sheet(isPresented: $showingCompanyDetail, onDismiss: {
                        settingsVM.fetchCompanyData()
                    }, content: {
                        CompanyDetailView(company: CompanyEntity(name: settingsVM.companyName, taxRate: Double(settingsVM.taxRateStr) ?? 0.0))
                    })
                    
                    Divider()
                    
                    Button {
                        showPasscodeView = true
                    } label: {
                        HStack {
                            Image(systemName: "lock")
                                .frame(width: 24)
                            Text("Change Passcode")
                            Spacer()
                        } //: HStack
                        .contentShape(Rectangle())
                    }
                    .padding(.vertical, 8)
                    .sheet(isPresented: $showPasscodeView) {
                        PasscodeView(processes: [.confirm, .set]) {
                            showPasscodeView = false
                        }
                    }
                    
                    Divider()
                    
                    Button {
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
                } //: VStack
                .font(.title3)
                .frame(maxWidth: 360)
                .foregroundStyle(Color("TextColor"))
                .modifier(PaneOutlineMod())
                
                Spacer()
                
                VStack {
                    Link("Terms of Service", destination: termsOfServiceURL)
                        .font(.title3)
                        .padding(.vertical, 8)
                    Divider()
                    Link("Privacy Policy", destination: privacyPolicyURL)
                        .padding(.vertical, 8)
                } //: VStack
                .font(.title3)
                .frame(maxWidth: 360)
                .foregroundStyle(Color("TextColor"))
                .modifier(PaneOutlineMod())
            } //: VStack
            .padding()
            .alert("Are you sure?", isPresented: $showDeleteConfirmation) {
                Button("Go back", role: .cancel) { }
                Button("Yes, delete account", role: .destructive) {
                    Task {
                        await settingsVM.deleteAccount()
                    }
                }
            }
            
        } //: VStack
        .padding()
        .background(Color("bgColor"))
    } //: Body
    
}


#Preview {
    SettingsView()
        .environment(\.realm, DepartmentEntity.previewRealm)
}
