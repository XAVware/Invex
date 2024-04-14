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
            print("Current passcode hash is nil")
            passHash = ""
            
        }
        fetchCompanyData()
    }
    
    func fetchCompanyData() {
        do {
            let realm = try Realm()
            if let result = realm.objects(CompanyEntity.self).first {
                self.companyName = result.name
                self.taxRateStr = String(format: "%.2f%", Double(result.taxRate))
            }
        } catch {
            LogService(String(describing: self)).error("Settings VM err")
        }
    }
}

struct SettingsView: View {
    @StateObject var vm: SettingsViewModel = SettingsViewModel()
    
    @State var showingCompanyDetail: Bool = false
    @State var showPasscodeView: Bool = false
    @State var showDeleteConfirmation: Bool = false
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Settings")
                .modifier(TitleMod())
            
            Spacer()
            
            HStack {
                VStack {
                    VStack(alignment: .leading, spacing: 24) {
                        HStack(spacing: 16) {
                            Image(systemName: "case.fill")
                            Text("Company Info")
                            Spacer()
                            Image(systemName: "pencil")
                        } //: HStack
                        //                        .padding()
                        .frame(maxWidth: 360, maxHeight: 70)
                        .background(Color("Purple050"))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                        .foregroundStyle(.accent)
                        //                        .modifier(GlowingOutlineMod())
                        
                        VStack(spacing: 12) {
                            HStack {
                                Text("Name:")
                                    .font(.headline)
                                    .foregroundStyle(.gray)
                                
                                Spacer()
                                
                                Text(vm.companyName)
                            } //: HStack
                            
                            HStack {
                                Text("Tax:")
                                    .font(.headline)
                                    .foregroundStyle(.gray)
                                Spacer()
                                
                                Text("\(vm.taxRateStr) %")
                            } //: HStack
                        } //: VStack
                        
                    } //: VStack
                    .padding()
                    .frame(maxWidth: 360, maxHeight: 140)
                    .background(Color("Purple050"))
                    .modifier(GlowingOutlineMod())
                    .onTapGesture {
                        showingCompanyDetail = true
                    }
                    
                    
                    Spacer()
                    
                    Button {
                        showPasscodeView = true
                    } label: {
                        HStack(spacing: 16) {
                            Image(systemName: "lock")
                            Text("Change Passcode")
                            Spacer()
                        } //: HStack
                        .padding()
                        .frame(maxWidth: 360, maxHeight: 70)
                        .background(Color("Purple050"))
                    }
                    .font(.title3)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .foregroundStyle(.accent)
                    .modifier(GlowingOutlineMod())
                    .sheet(isPresented: $showPasscodeView) {
                        PasscodeView(processes: [.confirm, .set]) {
                            showPasscodeView = false
                        }
                    }
                    
                    Button {
                        showDeleteConfirmation = true
                    } label: {
                        HStack(spacing: 16) {
                            Image(systemName: "trash")
                            Text("Delete Account")
                            Spacer()
                        } //: HStack
                        .padding()
                        .frame(maxWidth: 360, maxHeight: 70)
                        .background(Color("Purple050"))
                    }
                    .font(.title3)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .foregroundStyle(.accent)
                    .modifier(GlowingOutlineMod())
                    
                    
                    Link(destination: URL(string: "https://drive.google.com/file/d/1cYNlzO-RS9K3cc_4Oi0n56RfPR-7Y7Mp/view?usp=sharing")!, label: {
                        HStack(spacing: 16) {
                            Image(systemName: "lock")
                            Text("Terms of Service")
                            Spacer()
                        } //: HStack
                        .padding()
                        .frame(maxWidth: 360, maxHeight: 70)
                        .background(Color("Purple050"))
                    })
                    .font(.title3)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .foregroundStyle(.accent)
                    .modifier(GlowingOutlineMod())
                    
                    Link(destination: URL(string: "https://drive.google.com/file/d/1ITsWigHuvCGupSyLpJTeYl9k7T-y161S/view?usp=sharing")!, label: {
                        HStack(spacing: 16) {
                            Image(systemName: "lock")
                            Text("Privacy Policy")
                            Spacer()
                        } //: HStack
                        .padding()
                        .frame(maxWidth: 360, maxHeight: 70)
                        .background(Color("Purple050"))
                    })
                    .font(.title3)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .foregroundStyle(.accent)
                    .modifier(GlowingOutlineMod())
                    
                } //: HStack
            } //: VStack
            .padding()
            .alert("Are you sure?", isPresented: $showDeleteConfirmation, actions: {
                Button("Go back", role: .cancel) { }
                Button("Yes, delete account", role: .destructive) {
                    Task {
                        do {
                            let realm = try await Realm()
                            try await realm.asyncWrite {
                                realm.deleteAll()
                            }
                            AuthService.shared.deleteAll()
                            
                        } catch {
                            print("Error deleting account: \(error.localizedDescription)")
                        }
                    }
                }
            })
            .sheet(isPresented: $showingCompanyDetail, onDismiss: {
                vm.fetchCompanyData()
            }, content: {
                CompanyDetailView(company: CompanyEntity(name: vm.companyName, taxRate: Double(vm.taxRateStr) ?? 0.0))
            })
        } //: HStack
        .padding()
        
    } //: Body
    
}


#Preview {
    SettingsView()
    //    ResponsiveView { props in
    //        RootView(uiProperties: props, currentDisplay: .settings)
        .environment(\.realm, DepartmentEntity.previewRealm) 
    //            .onAppear {
    //                let realm = try! Realm()
    //                try! realm.write {
    //                    realm.deleteAll()
    //                    realm.add(CompanyEntity(name: "Preview Co", taxRate: 0.06))
    //
    //                }
    //            }
    //    }
}
