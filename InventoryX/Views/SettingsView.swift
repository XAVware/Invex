//
//  SettingsView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 6/4/23.
//

import SwiftUI
import RealmSwift

@MainActor class SettingsViewModel: ObservableObject {
    @Published var company: CompanyEntity?
    
    init() {
        fetchCompanyData()
    }
    
    func fetchCompanyData() {
        do {
            let realm = try Realm()
            self.company = realm.objects(CompanyEntity.self).first
        } catch {
            print("Settings VM err")
        }
    }
}

struct SettingsView: View {
    @StateObject var vm: SettingsViewModel = SettingsViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            Spacer()
            
            HStack {
                VStack {
                    VStack(alignment: .leading, spacing: 24) {
                        HStack(spacing: 16) {
                            Image(systemName: "case.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24)
                                .foregroundStyle(Color("Purple800"))
                            Text("Company Info")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .fontDesign(.rounded)
                            Spacer()
                            Image(systemName: "pencil")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 16)
                        } //: HStack
                        
                        VStack(spacing: 12) {
                            HStack {
                                Text("Name:")
                                    .font(.headline)
                                    .foregroundStyle(.gray)
                                Spacer()
                                Text(vm.company?.name ?? "")
                            } //: HStack
                            
                            HStack {
                                Text("Tax:")
                                    .font(.headline)
                                    .foregroundStyle(.gray)
                                Spacer()
                                Text("\(vm.company?.taxRate ?? 0 * 100) %")
                            } //: HStack
                        } //: VStack
                    } //: VStack
                    .padding(24)
                    .frame(maxWidth: 360, maxHeight: 140)
                    .background(Color("Purple050"))
                    .modifier(GlowingOutlineMod())
//                    .onReceive(vm.$company) { newValue in
//                        guard let company = newValue else { return }
//                    }
                    
                    Spacer()
                } //: VStack
            } //: HStack
            .padding()
        } //: VStack
        .padding()
    }
     
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}


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
