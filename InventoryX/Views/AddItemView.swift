//
//  AddItemView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 6/24/23.
//

import SwiftUI
import RealmSwift


@MainActor class AddItemViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    
    func saveItem(dept: DepartmentEntity?, name: String, att: String, qty: String, price: String, cost: String) async {
        do {
            try await RealmActor().saveItem(dept: dept, name: name, att: att, qty: qty, price: price, cost: cost)
            print("Successfully saved item")
        } catch {
            errorMessage = error.localizedDescription
            debugPrint(error.localizedDescription)
        }
    } //: Save Item
    
    
    func updateItem(item: ItemEntity, name: String, att: String, qty: String, price: String, cost: String) async {
        do {
            try await RealmActor().updateItem(item: item, name: name, att: att, qty: qty, price: price, cost: cost)
            debugPrint("Successfully updated item")
        } catch {
            errorMessage = error.localizedDescription
            print(error.localizedDescription)
        }
    }
    
   
}

enum DetailViewType { case create, modify }

struct AddItemView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: AddItemViewModel = AddItemViewModel()
//    @StateObject var uiFeedback = UIFeedbackService.shared
    
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
    
    private enum Focus { case name, attribute, price, onHandQty, unitCost }
    @FocusState private var focus: Focus?
    
    @State var errorMessage: String = ""
    
    @State var showDeleteConfirmation: Bool = false
    
    // TODO: Display and update/save attribute
    init(item: ItemEntity, showTitles: Bool = true, onSuccess: (() -> Void)? = nil) {
        self.selectedItem = item
        self.showTitles = showTitles
        self.onSuccess = onSuccess
        /// Detail type is set based on whether or not the item had a department when initially passed to view.
        self.detailType = item.department.first == nil ? .create : .modify
    }
    
    private func continueTapped() {
        focus = nil
//        do {
            let price = retailPrice.replacingOccurrences(of: "$", with: "")
            let cost = retailPrice.replacingOccurrences(of: "$", with: "")
            
            Task {
                
                if detailType == .modify {
                    await vm.updateItem(item: selectedItem, name: itemName, att: attribute, qty: quantity, price: price, cost: cost)
                    finish()
                    
                } else {
                    // Item was nil when passed to view. User is creating a new item.
                    await vm.saveItem(dept: selectedDepartment, name: itemName, att: attribute, qty: quantity, price: price, cost: cost)
                    finish()
                }
            }
            
//        } catch let error as AppError {
////            UIFeedbackService.shared.showAlert(.error, error.localizedDescription)
//            errorMessage = error.localizedDescription
//        } catch {
////            UIFeedbackService.shared.showAlert(.error, error.localizedDescription)
//            errorMessage = error.localizedDescription
//        }
        
    }
    
    private func finish() {
        if let onSuccess = onSuccess {
            // On success is only used by onboarding view which we don't want to dismiss.
            onSuccess()
        } else {
            dismiss()
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 24) {
                // MARK: - HEADER
                if showTitles {
                    VStack(alignment: .leading, spacing: 8) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                        .font(.title)
                        
                        Text(detailType == .modify ? "Edit item" : "Add item")
                            .font(.largeTitle)
                        
                    } //: VStack
                    .fontDesign(.rounded)
                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .modifier(TitleMod())
                }
                
                // MARK: - FORM FIELDS
                VStack(alignment: .center, spacing: 24) {
                    DepartmentPicker(selectedDepartment: $selectedDepartment, style: .dropdown)
                    Divider()
                    ThemeTextField(boundTo: $itemName,
                                   placeholder: "i.e. Gatorade",
                                   title: "Item Name:",
                                   subtitle: nil,
                                   type: .text)
                    .focused($focus, equals: .name)
                    
                    ThemeTextField(boundTo: $attribute,
                                   placeholder: "i.e. Blue",
                                   title: "Attribute:",
                                   subtitle: nil,
                                   type: .text)
                    .focused($focus, equals: .attribute)
                    
                    ThemeTextField(boundTo: $quantity,
                                   placeholder: "24",
                                   title: "On-hand quantity:",
                                   subtitle: nil,
                                   type: .integer)
                    .keyboardType(.numberPad)
                    .focused($focus, equals: .onHandQty)
                    
                    ThemeTextField(boundTo: $retailPrice,
                                   placeholder: "$ 2.00",
                                   title: "Retail Price:",
                                   subtitle: nil,
                                   type: .price)
                    .keyboardType(.numberPad)
                    .focused($focus, equals: .price)
                    
                    ThemeTextField(boundTo: $unitCost,
                                   placeholder: "$ 1.00",
                                   title: "Unit Cost:",
                                   subtitle: nil,
                                   type: .price)
                    .keyboardType(.numberPad)
                    .focused($focus, equals: .unitCost)
                } //: VStack
                .onChange(of: focus) { _, newValue in
                    if !retailPrice.isEmpty {
                        if let price = Double(retailPrice) {
                            self.retailPrice = price.formatAsCurrencyString()
                        }
                    }
                    
                    if !unitCost.isEmpty {
                        if let cost = Double(unitCost) {
                            self.unitCost = cost.formatAsCurrencyString()
                        }
                    }
                    
                    if let qty = Int(quantity) {
                        self.quantity = String(describing: qty)
                    }
                }
                
                Text(errorMessage)
                    .foregroundStyle(.red)
                
                Button {
                    continueTapped()
                } label: {
                    Spacer()
                    Text("Save Item")
                    Spacer()
                }
                .modifier(PrimaryButtonMod())
                
                
                Spacer()
                
            } //: VStack
            .frame(maxWidth: 720)
            .padding()
            .onTapGesture {
                self.focus = nil
            }
            .onAppear {
                itemName = selectedItem.name
                attribute = selectedItem.attribute
                
                if selectedItem.onHandQty > 0 {
                    quantity = String(describing: selectedItem.onHandQty)
                }
                
                if selectedItem.retailPrice > 0 {
                    retailPrice = selectedItem.retailPrice.formatAsCurrencyString()
                }
                
                if selectedItem.unitCost > 0 {
                    unitCost = selectedItem.unitCost.formatAsCurrencyString()
                }
            }
        } //: ScrollView
        .navigationTitle(detailType == .modify ? "Edit item" : "Add item")
        .navigationBarTitleDisplayMode(.large)
        .overlay(detailType == .modify ? deleteButton : nil, alignment: .topTrailing)
    } //: Body
    
    private var deleteButton: some View {
        Menu {
            Button("Delete item", systemImage: "trash", role: .destructive) {
                showDeleteConfirmation = true
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
        .font(.title)
        .padding()
        .foregroundStyle(.primary)
        .alert("Are you sure? This can't be undone.", isPresented: $showDeleteConfirmation) {
            Button("Go back", role: .cancel) { }
            Button("Yes, delete Item", role: .destructive) {                
                do {
                    let realm = try Realm()
                    try realm.write {
                        guard let dept = realm.object(ofType: DepartmentEntity.self, forPrimaryKey: selectedDepartment?._id) else {
                            print("No department found")
                            return
                        }
                        
                        guard let item = realm.object(ofType: ItemEntity.self, forPrimaryKey: selectedItem._id) else {
                            print("No item found")
                            return
                        }
                        
                        if let indexToDelete = dept.items.firstIndex(where: { $0._id == item._id }) {
                            print("Index found: \(indexToDelete)")
                            dept.items.remove(at: indexToDelete)
                            realm.delete(item)
                        } else {
                            print("Couldn't delete")
                        }
                        
                    }
                    dismiss()
                } catch {
                    print("Error deleting account: \(error.localizedDescription)")
                }
            }
        }

    } //: Delete Button
    
}

#Preview {
    AddItemView(item: ItemEntity())
}
