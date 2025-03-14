//
//  AddDepartmentView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/21/24.
//

import SwiftUI
import RealmSwift

struct DepartmentDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    /// If the entity's name is empty when it is initially passed to the view, `isNew` is set to true
    // TODO: In createDefaultDepartment() save the department if it doesn't already exist instead of using isNew
    @State var isNew: Bool
        
    @ObservedRealmObject var department: DepartmentEntity
    @State var showDeleteConfirmation: Bool = false
    @Environment(NavigationService.self) var navService

    
    init(department: DepartmentEntity?) {
        let newDept = department ?? DepartmentEntity()
        self._department = ObservedRealmObject(wrappedValue: newDept)
        self.isNew = newDept.realm == nil
    }
    
    func createDefaultDepartment() {
        do {
            let realm = try Realm()
            if isNew {
                try realm.write {
                    realm.add(department)
                }
            }
        } catch {
            print("Error creating default department: \(error)")
        }
    }
    
    func validateDepartmentName(value: String) -> (Bool, String?) {
        if value.isEmpty {
            return (false, "Please enter a valid name.")
        } else {
            return (true, nil)
        }
    }
    
    private func saveDepartmentName(validName: String) {
        guard !validName.isEmpty else { return }
        
        do {
            let realm = try Realm()
            
            try realm.write {
                if isNew && department.realm == nil {
                    realm.add(department)
                    isNew = false
                }
                $department.wrappedValue.name = validName
            }
        } catch {
            print("Error saving name: \(error)")
        }
    }
    
    func saveRestockQuantity(validQty: Int) {
        do {
            let realm = try Realm()
            try realm.write {
                $department.wrappedValue.restockNumber = validQty
            }
        } catch {
            print("Error saving restock quantity: \(error)")
        }
    }
    
    func saveMarkup(validMarkup: Double) {
        do {
            let realm = try Realm()
            try realm.write {
                $department.wrappedValue.defMarkup = validMarkup
            }
        } catch {
            print("Error saving markup: \(error)")
        }
    }
    
    let containerData: [ContainerXModel] = [
        ContainerXModel(title: "Department Name", description: "Your items will be grouped into departments."),
        ContainerXModel(title: "Restock Quantity", description: "When an item's stock is less than this number, you will be notified."),
        ContainerXModel(title: "Markup", description: "Automatically markup items in this department by this percentage.")
    ]
    
    var body: some View {
        FormX(title: "Department") {
            // Department Name Container
            ContainerX(data: containerData[0], value: department.name) {
                
                TextFieldX(value: department.name, validate: { value in
                    validateDepartmentName(value: value)
                }, save: { name in
                    Task {
                        saveDepartmentName(validName: name)
                    }
                })
                
            }
                        
            // Restock Quantity Container
            ContainerX(data: containerData[1], value: department.restockNumber.description) {
                NumberPickerX(number: department.restockNumber) { value in
                    saveRestockQuantity(validQty: value)
                }
            }

//            // Markup Container
//            ContainerX(data: containerData[2], value: department.defMarkup.toPercentageString()) {
//                PercentagePickerX(tax: department.defMarkup) { value in
//                    Task {
//                        saveMarkup(validMarkup: value)
//                    }
//                }
//            }
        } //: FormX
        .onAppear {
            createDefaultDepartment()
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) { 
                Button("Back", systemImage: "chevron.left") { 
                    back()
                }
                .fontWeight(.semibold)
            }
            
            ToolbarItem(placement: .topBarTrailing) { 
                Button("Done") { 
                    back()
                }
                .fontWeight(.semibold)
            }
        }
    } //: Body
    
    private func back() {
        if department.name.isEmpty && department.realm != nil {
            do {
                let realm = try Realm()
                if let thawedDept = department.thaw() {
                    try realm.write {
                        realm.delete(thawedDept)
                    }
                }
            } catch {
                print("Error deleting empty department: \(error)")
            }
        }
        
        if !navService.path.isEmpty {
            navService.path.removeLast()
        } else {
            dismiss()
        }
    }
          
}

#Preview {
    DepartmentDetailView(department: DepartmentEntity())
        .background(Color.bg100)
}

