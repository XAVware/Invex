//
//  AddItemView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 6/24/23.
//

import SwiftUI
import RealmSwift


@MainActor class AddItemViewModel: ObservableObject {
    
    func saveItem(dept: DepartmentEntity?, name: String, att: String, qty: String, price: String, cost: String) throws {
        guard let dept = dept else { return }
        guard name.isNotEmpty, qty.isNotEmpty, price.isNotEmpty else { return }
        guard let thawedDept = dept.thaw() else { return }
        
        let newItem = ItemEntity(name: name, 
                                 retailPrice: Double(price) ?? 0,
                                 avgCostPer: Double(cost) ?? 0,
                                 onHandQty: Int(qty) ?? 0)
        do {
            
            let realm = try Realm()
            try realm.write {
                thawedDept.items.append(newItem)
            }
            LogService(self).info("Finished saving new item.")
        } catch {
            LogService(self).error("Error saving item to Realm: \(error.localizedDescription)")
        }
    } //: Save Item
    
    
    func updateItem(item: ItemEntity, name: String, att: String, qty: String, price: String, cost: String) throws {
        LogService(self).info("Item exists. Updating...")
        guard name.isNotEmpty, qty.isNotEmpty, price.isNotEmpty else { return }
        guard let qty = Int(qty) else { return }
        guard let price = Double(price) else { return }
        guard let cost = Double(cost) else { return }

        if let existingItem = item.thaw() {
            let realm = try Realm()
            try realm.write {
                existingItem.name = name
                //                existingItem.attribute = att
                existingItem.onHandQty = qty
                existingItem.retailPrice = price
                existingItem.avgCostPer = cost
            }
            
            LogService(self).info("Finished updating item.")
        } else {
            LogService(self).error("Error thawing item.")
        }
    }
    
    
}

enum DetailViewType { case create, modify }

// TODO: Error is thrown briefly from the department dropdown after an item was successfully added, therefore changing the department
struct AddItemView: View {
    @StateObject var vm: AddItemViewModel = AddItemViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedDepartment: DepartmentEntity?
    @State private var itemName: String = ""
    @State private var attribute: String = ""
    @State private var quantity: String = ""
    @State private var retailPrice: String = ""
    @State private var unitCost: String = ""
    
    let selectedItem: ItemEntity
    
    /// Used to hide the back button and title while onboarding.
    @State var showTitles: Bool
    
    /// Used in onboarding view to execute additional logic.
    let onSuccess: (() -> Void)?
    
    let detailType: DetailViewType
        
    init(item: ItemEntity, showTitles: Bool = true, onSuccess: (() -> Void)? = nil) {
        self.selectedItem = item
        self.showTitles = showTitles
        self.onSuccess = onSuccess
        self.detailType = item.department.first == nil ? .create : .modify
    }
    
    private func continueTapped() {
        do {
            if detailType == .modify {
                try vm.updateItem(item: selectedItem, name: itemName, att: attribute, qty: quantity, price: retailPrice, cost: unitCost)
                if let onSuccess = onSuccess {
                    // On success is only used by onboarding view which we don't want to dismiss.
                    onSuccess()
                } else {
                    dismiss()
                }

            } else {
                // Item was nil when passed to view. User is creating a new item.
                try vm.saveItem(dept: selectedDepartment, name: itemName, att: attribute, qty: quantity, price: retailPrice, cost: unitCost)
                if let onSuccess = onSuccess {
                    // On success is only used by onboarding view which we don't want to dismiss.
                    onSuccess()
                } else {
                    dismiss()
                }
            }
            
        } catch {
            LogService(self).error("Error while saving item: \(error.localizedDescription)")
        }
        
    }
    
    var body: some View {
            VStack(alignment: .center, spacing: 36) {
                if showTitles {
                    VStack(alignment: .leading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24)
                                .foregroundStyle(.black)
                        }
                        Text("Add an item")
                            .modifier(TitleMod())
                        
                    } //: VStack
                }
                
                    DepartmentPicker(selectedDepartment: $selectedDepartment, style: .dropdown)
                
                VStack(alignment: .leading, spacing: 16) {
                    ThemeTextField(boundTo: $itemName,
                                   placeholder: "i.e. Gatorade",
                                   title: "Item Name:",
                                   subtitle: nil,
                                   type: .text)
                    
                    ThemeTextField(boundTo: $attribute,
                                   placeholder: "i.e. Blue",
                                   title: "Attribute:",
                                   subtitle: nil,
                                   type: .text)
                    
                    ThemeTextField(boundTo: $quantity,
                                   placeholder: "24",
                                   title: "On-hand quantity:",
                                   subtitle: nil,
                                   type: .integer)
                    .keyboardType(.numberPad)
                    
                    ThemeTextField(boundTo: $retailPrice,
                                   placeholder: "$ 2.00",
                                   title: "Retail Price:",
                                   subtitle: nil,
                                   type: .price)
                    .keyboardType(.numberPad)
                    //                .onChange(of: retailPrice) { _ in
                    //                    let formattedPrice = retailPrice.replacingOccurrences( of:"[^0-9.]", with: "", options: .regularExpression)
                    //                    guard let price = Double(formattedPrice) else {
                    //                        print("Err")
                    //                        return
                    //                    }
                    //                    retailPrice = price.formatAsCurrencyString()
                    //                }
                    
                    ThemeTextField(boundTo: $unitCost,
                                   placeholder: "$ 1.00",
                                   title: "Unit Cost:",
                                   subtitle: nil,
                                   type: .price)
                    .keyboardType(.numberPad)
                }
//                Spacer()
                
                Button {
                    continueTapped()
                } label: {
                    Text("Save Item")
                }
                .modifier(PrimaryButtonMod())
                
                Spacer()
                
            } //: VStack
            .frame(maxWidth: 720)
            .padding()
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                if let dept = selectedItem.department.first {
                    print("Items department is \(dept)")
                    self.selectedDepartment = dept
                    self.itemName = selectedItem.name
        //            self.attribute = item.attribute
                    self.quantity = String(describing: selectedItem.onHandQty!)
                    self.retailPrice = String(describing: selectedItem.retailPrice!)
                    self.unitCost = String(describing: selectedItem.avgCostPer!)
                }
            }
    } //: Body
}

#Preview {
    AddItemView(item: ItemEntity())
}
