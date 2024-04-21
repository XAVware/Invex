//
//  SettingsView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 6/4/23.
//

import SwiftUI
import RealmSwift

@MainActor class SettingsViewModel: ObservableObject {
    @Published var companyName: String = ""
    @Published var taxRateStr: String = ""
    
    @Published var passHash: String
    
    init() {
        if let currentPassHash = AuthService.shared.getCurrentPasscode()  {
            passHash = currentPassHash
        } else {
            passHash = ""
        }
        fetchCompanyData()
    }
    
    func fetchCompanyData() {
        do {
            if let company = try RealmActor().fetchCompany() {
                self.companyName = company.name
                self.taxRateStr = String(format: "%.2f%", Double(company.taxRate))
            }
        } catch {
            LogService(String(describing: self)).error("Settings VM err")
        }
    }
    
    func deleteAccount() async {
        do {
            try await RealmActor().deleteAll()
            AuthService.shared.deleteAll()
        } catch {
            print("Error deleting account: \(error.localizedDescription)")
        }
    }
}

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
                .foregroundStyle(.black)
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
                .foregroundStyle(.black)
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
        .background(Color("Purple050").opacity(0.2))
    } //: Body
    
}


#Preview {
    SettingsView()
        .environment(\.realm, DepartmentEntity.previewRealm)
}
