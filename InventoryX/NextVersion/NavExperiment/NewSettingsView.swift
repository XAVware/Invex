//
//  NewSettingsView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/21/24.
//

import SwiftUI





struct NewSettingsView: View {
    let termsOfServiceURL: URL = URL(string: "https://xavware.com/invex/termsOfService")!
    let privacyPolicyURL: URL = URL(string: "https://xavware.com/invex/privacyPolicy")!
    
    @StateObject var settingsVM: SettingsViewModel = SettingsViewModel()
    
    @State var showingCompanyDetail: Bool = false
    @State var showPasscodeView: Bool = false
    @State var showDeleteAccountConfirmation: Bool = false
//    @Binding var currentDisplay: NewDisplayState
    var body: some View {

            VStack {
                
                VStack {
                    NavigationLink {
                        CompanyDetailView(company: CompanyEntity(name: settingsVM.companyName, taxRate: Double(settingsVM.taxRateStr) ?? 0.0))
                    } label: {
                        HStack {
                            Image(systemName: "case")
                                .frame(width: 24)
                            Text("Company Info")
                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                    
                    
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
                        showDeleteAccountConfirmation = true
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
                .font(.subheadline)
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color("TextColor"))
                .modifier(PaneOutlineMod())
                
                Spacer()
                
                VStack {
                    Link("Terms of Service", destination: termsOfServiceURL)
                        .padding(.vertical, 8)
                    Divider()
                    Link("Privacy Policy", destination: privacyPolicyURL)
                        .padding(.vertical, 8)
                } //: VStack
                .font(.subheadline)
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color("TextColor"))
                .modifier(PaneOutlineMod())
            } //: VStack
            .padding()
            .alert("Are you sure?", isPresented: $showDeleteAccountConfirmation) {
                Button("Go back", role: .cancel) { }
                Button("Yes, delete account", role: .destructive) {
                    Task {
                        await settingsVM.deleteAccount()
                    }
                }
            }

        
        
    } 
//                        .padding()
//                        .background(Color("bgColor").opacity(0.2))
    
}

//#Preview {
//    NavigationSplitView {
//        
//    } content: {
//        NewSettingsView()
//    } detail: {
//        
//    }
//}
