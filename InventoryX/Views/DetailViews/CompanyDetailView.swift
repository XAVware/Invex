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
//    @State var formVM: XAVFormViewModel = XAVFormViewModel()
    let isOnboarding: Bool
    
    let onSuccess: (() -> Void)?
    
    @ObservedRealmObject var company: CompanyEntity
    @State var showDeleteConfirmation: Bool = false
    
    init(company: CompanyEntity, onSuccess: (() -> Void)? = nil) {
        self._company = ObservedRealmObject(wrappedValue: company)
        self.onSuccess = onSuccess
        self.isOnboarding = company.name.count <= 0
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
    
    let containerData: [ContainerXModel] = [
        ContainerXModel(title: "Business Name", description: "Your company name will appear on sales receipts."),
        ContainerXModel(title: "Tax Rate", description: "We'll use this to calculate the tax on each sale.")
    ]
    
    var body: some View {
        FormX(title: "Company Info", containers: containerData) {
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if !isOnboarding {
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
    CompanyDetailView(company: CompanyEntity(name: "Preview Company", taxRate: 0.078)) {}
        .environment(\.realm, DepartmentEntity.previewRealm)
        .environment(XAVFormViewModel())
}
