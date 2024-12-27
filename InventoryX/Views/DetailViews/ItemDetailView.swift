//
//  AddItemView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 6/24/23.
//

import SwiftUI
import RealmSwift

struct ItemDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.verticalSizeClass) var vSize
    @ObservedResults(DepartmentEntity.self) var departments
    @State private var selectedDepartment: DepartmentEntity?
    /// If the entity's name is empty when it is initially passed to the view, `isNew` is set to true
    let isNew: Bool
        
    @ObservedRealmObject var item: ItemEntity
    
    init(item: ItemEntity) {
        self._item = ObservedRealmObject(wrappedValue: item)
        self.isNew = item.name.isEmpty
    }
    
    let containerData: [ContainerXModel] = [
        ContainerXModel(title: "Item Name", description: "What's the name of the item?"),
        ContainerXModel(title: "Attribute", description: "Attributes may include an items size, color, or other information."),
        ContainerXModel(title: "In-Stock Qty", description: "How many do you have in stock?"),
        ContainerXModel(title: "Retail Price", description: "How much do you sell it for?"),
        ContainerXModel(title: "Unit Cost", description: "How much does it cost?")
    ]
    
    var body: some View {
        FormX(title: "Item") {
            // Item Name Container
            ContainerX(data: containerData[0], value: item.name) {
                TextFieldX(value: item.name, validate: { value in
                    validateItemName(value: value)
                }, save: { name in
                    Task {
                        saveItemName(validName: name)
                    }
                })
            }
                        
            MenuX(dept: $selectedDepartment, title: "Department:", description: "Which department is this item in?") { newDept in
                selectedDepartment = newDept
                saveDepartment(department: newDept)
            }
                
            // Attribute Container
            ContainerX(data: containerData[1], value: item.attribute) {
                TextFieldX(value: item.attribute, validate: { value in
                    validateItemAttribute(value: value)
                }, save: { attribute in
                    Task {
                        saveItemAttribute(validAttribute: attribute)
                    }
                })
            }
                        
            // On hand quantity container
            ContainerX(data: containerData[2], value: item.onHandQty.description) {
                NumberPickerX(number: item.onHandQty) { value in
                    saveOnHandQty(validQty: value)
                }
            }
                        
            ContainerX(data: containerData[3], value: item.retailPrice.toCurrencyString()) {
                CurrencyFieldX(amount: item.retailPrice, save: { validPrice in
                    saveRetailPrice(validPrice: validPrice)
                })
            }
                  
//            ContainerX(data: containerData[4], value: item.unitCost.toCurrencyString()) {
//                CurrencyFieldX(amount: item.unitCost, save: { validCost in
//                    saveUnitCost(validCost: validCost)
//                })
//            }
        } //: FormX
        .onAppear {
            createDefaultItem()
        }
        
    } //: Body
    
    private var rotatePrompt: some View {
        ZStack {
            Color.bg.ignoresSafeArea()
            Image(systemName: "rectangle.landscape.rotate")
        }
    }
    
    // MARK: - Functions
    private func createDefaultItem() {
        do {
            let realm = try Realm()
            let items = realm.objects(ItemEntity.self)
            if items.count == 0 || isNew {
                try realm.write {
                    realm.add(item)
                }
            }
        } catch {
            print("Error creating default company: \(error)")
        }
    }
    
    private func validateItemName(value: String) -> (Bool, String?) {
        if value.isEmpty {
            return (false, "Please enter a valid name.")
        } else {
            return (true, nil)
        }
    }
    
    private func validateItemAttribute(value: String) -> (Bool, String?) {
        if value.isEmpty {
            return (false, "Please enter a valid attribue.")
        } else {
            return (true, nil)
        }
    }
    
    private func saveItemName(validName: String) {
        do {
            let realm = try Realm()
            try realm.write {
                $item.wrappedValue.name = validName
            }
        } catch {
            print("Error saving name: \(error)")
        }
    }
    
    private func saveDepartment(department: DepartmentEntity?) {
        guard let thawedItem = item.thaw() else { return }
        
        do {
            let realm = try Realm()
            try realm.write {
                if let currentDept = thawedItem.department.first {
                    if let index = currentDept.items.index(of: thawedItem) {
                        currentDept.items.remove(at: index)
                    }
                }
                
                if let newDept = department?.thaw() {
                    newDept.items.append(thawedItem)
                }
            }
        } catch {
            print("Error saving department: \(error)")
        }
    }
    
    private func saveItemAttribute(validAttribute: String) {
        do {
            let realm = try Realm()
            try realm.write {
                $item.wrappedValue.attribute = validAttribute
            }
        } catch {
            print("Error saving name: \(error)")
        }
    }
    
    private func saveOnHandQty(validQty: Int) {
        do {
            let realm = try Realm()
            try realm.write {
                $item.wrappedValue.onHandQty = validQty
            }
        } catch {
            print("Error saving markup: \(error)")
        }
    }
    
    private func saveRetailPrice(validPrice: Double) {
        do {
            let realm = try Realm()
            try realm.write {
                $item.wrappedValue.retailPrice = validPrice
            }
        } catch {
            print("Error saving markup: \(error)")
        }
    }
    
    private func saveUnitCost(validCost: Double) {
        do {
            let realm = try Realm()
            try realm.write {
                $item.wrappedValue.unitCost = validCost
            }
        } catch {
            print("Error saving markup: \(error)")
        }
    }
}

#Preview {
//    ItemDetailView(item: ItemEntity())
    ItemDetailView(item: ItemEntity.item2) 
        .environment(\.realm, DepartmentEntity.previewRealm)
        .background(Color.bg)
}
