//
//  CompanyDetailView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/25/24.
//

import SwiftUI
import RealmSwift


struct ContainerXModel {
    let id: UUID = UUID()
    let title: String
    let description: String
}

struct CompanyDetailView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: DetailViewModel = DetailViewModel()
    
    /// If the entity's name is empty when it is initially passed to the view, `isNew` is set to true
    let isNew: Bool
        
    @ObservedRealmObject var company: CompanyEntity
    @State var showDeleteConfirmation: Bool = false
    
    init(company: CompanyEntity) {
        self._company = ObservedRealmObject(wrappedValue: company)
        self.isNew = company.name.isEmpty
    }
    
    func validateCompanyName(value: String) -> (Bool, String?) {
        if value.isEmpty {
            return (false, "Please enter a valid name.")
        } else {
            return (true, nil)
        }
    }
    
    func saveCompanyName(validName: String) {
        do {
            let realm = try Realm()
            try realm.write {
                $company.wrappedValue.name = validName
            }
        } catch {
            print("Error saving name: \(error)")
        }
    }
    
    func saveTaxRate(validRate: Double) {
        do {
            let realm = try Realm()
            try realm.write {
                $company.wrappedValue.taxRate = validRate
            }
        } catch {
            print("Error saving: \(error)")
        }
    }
    
    func createDefaultCompany() {
        do {
            let realm = try Realm()
            let companies = realm.objects(CompanyEntity.self)
            if companies.count == 0 && isNew {
                try realm.write {
                    realm.add(company)
                }
            }
        } catch {
            print("Error creating default company: \(error)")
        }
    }
    
    let containerData: [ContainerXModel] = [
        ContainerXModel(title: "Business Name", description: "Your company name will appear on sales receipts."),
        ContainerXModel(title: "Tax Rate", description: "We'll use this to calculate the tax on each sale.")
    ]
    
    var body: some View {
        FormX(title: "Company Info") {
            // Company name container
            ContainerX(data: containerData[0], value: company.name) {
                
                TextFieldX(value: company.name, validate: { value in
                    validateCompanyName(value: value)
                }, save: { name in
                    Task {
                        saveCompanyName(validName: name)
                    }
                })
                
            }
            
            // Tax rate container
            ContainerX(data: containerData[1], value: company.taxRate.toPercentageString()) {
                PercentagePickerX(tax: company.taxRate) { value in
                    Task {
                        saveTaxRate(validRate: value)
                    }
                }
            }
            
        } //: FormX
        .onAppear {
            createDefaultCompany()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if !isNew {
                    Menu {
                        Button("Delete Account", systemImage: "trash", role: .destructive) {
                            showDeleteConfirmation = true
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(Angle(degrees: 90))
                    }
                    .foregroundStyle(.accent)
                } else {
                    Spacer()
                }
            }
        }
        .alert("Are you sure?", isPresented: $showDeleteConfirmation) {
            Button("Go back", role: .cancel) { }
            Button("Yes, delete account", role: .destructive) {
                Task {
                    await vm.deleteAccount()
                }
            }
        }

        
    } //: Body
    
}


#Preview {
    CompanyDetailView(company: CompanyEntity(name: "Preview Company", taxRate: 0.078))
        .environment(\.realm, DepartmentEntity.previewRealm)
        .environment(FormXViewModel())
}
