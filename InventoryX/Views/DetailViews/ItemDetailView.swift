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
    @StateObject var vm: DetailViewModel = DetailViewModel()
    
    @State private var selectedDepartment: DepartmentEntity?
    @State private var itemName: String = ""
    @State private var attribute: String = ""
    @State private var quantity: String = ""
    @State private var retailPrice: String = ""
    @State private var unitCost: String = ""
    
    let selectedItem: ItemEntity?
    let detailType: DetailType
    
    @ObservedResults(ItemEntity.self) var items
    @ObservedResults(DepartmentEntity.self) var departments
    
    private enum Focus { case name, attribute, price, onHandQty, unitCost }
    @FocusState private var focus: Focus?
    
    @State var showDeleteConfirmation: Bool = false
    
    let onSuccess: (() -> Void)?
    
    init(item: ItemEntity?, detailType: DetailType, onSuccess: (() -> Void)? = nil) {
        self.selectedItem = item
        self.detailType = detailType
        self.onSuccess = onSuccess
    }
    
    private func continueTapped() {
        focus = nil
        let price = retailPrice.replacingOccurrences(of: "$", with: "")
        let cost = unitCost.replacingOccurrences(of: "$", with: "")
        
        
        Task {
            
            if detailType == .update {
                if let selectedItem = selectedItem {
                    await vm.updateItem(
                        item: selectedItem,
                        name: itemName,
                        att: attribute,
                        qty: quantity,
                        price: price,
                        cost: cost,
                        completion: { error in
                            guard error == nil else { return }
                            
                            if let onSuccess = onSuccess {
                                onSuccess()
                            } else {
                                dismiss()
                            }
                        })
                }
            } else {
                // Item was nil when passed to view. User is creating a new item.
                await vm.saveItem(
                    dept: selectedDepartment,
                    name: itemName,
                    att: attribute,
                    qty: quantity,
                    price: price,
                    cost: cost,
                    completion: { error in
                        guard error == nil else { return }
                        
                        if let onSuccess = onSuccess {
                            onSuccess()
                        } else {
                            dismiss()
                        }
                    })
            }
        }
    }
    
    var body: some View {
        FormX(title: "Item", containers: []) {
            ThemeFormSection(title: "Item Info") {
                ThemeTextField(boundTo: $itemName, placeholder: "i.e. Gatorade", title: "Item Name:", type: .text)
                    .focused($focus, equals: .name)
                    .submitLabel(.return)
                    .onSubmit { focus = nil }
                
                FieldDivider()
                
                HStack {
                    Text("Department:")
                    Spacer()
                    Picker("", selection: $selectedDepartment) {
                        ForEach(departments) { dept in
                            Text(dept.name)
                                .tag(DepartmentEntity?.none)
                                .font(.subheadline)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .foregroundStyle(Color.textPrimary)
                    .tint(Color.textPrimary)
                    .font(.subheadline)
                    //                .padding()
                }
                FieldDivider()
                
                ThemeTextField(boundTo: $attribute, placeholder: "i.e. Blue", title: "Attribute:", type: .text)
                    .focused($focus, equals: .attribute)
                    .submitLabel(.return)
                    .onSubmit { focus = nil }
            }
            
            ThemeFormSection(title: "Stock") {
                ThemeTextField(boundTo: $quantity, placeholder: "24", title: "On-hand quantity:", type: .integer)
                    .keyboardType(.numberPad)
                    .focused($focus, equals: .onHandQty)
                    .submitLabel(.return)
                    .onSubmit { focus = nil }
            }
            
            ThemeFormSection(title: "Pricing") {
                ThemeTextField(boundTo: $retailPrice, placeholder: "$ 2.00", title: "Retail Price:", type: .price)
                    .keyboardType(.numberPad)
                    .focused($focus, equals: .price)
                    .submitLabel(.return)
                    .onSubmit { focus = nil }
                
                FieldDivider()
                
                ThemeTextField(boundTo: $unitCost, placeholder: "$ 1.00", title: "Unit Cost:", type: .price)
                    .keyboardType(.numberPad)
                    .focused($focus, equals: .unitCost)
                    .submitLabel(.return)
                    .onSubmit { focus = nil }
            }
            .onChange(of: focus) { _, newValue in
                if !retailPrice.isEmpty {
                    if let price = Double(retailPrice) {
                        self.retailPrice = price.toCurrencyString()
                    }
                }
                
                if !unitCost.isEmpty {
                    if let cost = Double(unitCost) {
                        self.unitCost = cost.toCurrencyString()
                    }
                }
                
                if let qty = Int(quantity) {
                    self.quantity = String(describing: qty)
                }
            }
            
        }
        .onTapGesture {
            self.focus = nil
        }
        .onAppear {
            if let selectedItem = selectedItem {
                itemName = selectedItem.name
                attribute = selectedItem.attribute
                
                if selectedItem.onHandQty > 0 {
                    quantity = String(describing: selectedItem.onHandQty)
                }
                
                if selectedItem.retailPrice > 0 {
                    retailPrice = selectedItem.retailPrice.toCurrencyString()
                }
                
                if selectedItem.unitCost > 0 {
                    unitCost = selectedItem.unitCost.toCurrencyString()
                }
            }
        }
        .navigationTitle(detailType == .update ? "Edit item" : "Add item")
        .navigationBarTitleDisplayMode(.large)
        .overlay(
            Button(action: continueTapped) {
                Text("Continue")
                    .frame(maxWidth: .infinity)
            }
                .buttonStyle(ThemeButtonStyle())
                .padding()
            , alignment: .bottom)
        .alert("Are you sure? This can't be undone.", isPresented: $showDeleteConfirmation) {
            Button("Go back", role: .cancel) { }
            Button("Yes, delete Item", role: .destructive) {
                guard let selectedItem = selectedItem else {
                    print("Trying to delete item but item is nil")
                    return
                }
                
                Task {
                    await vm.deleteItem(withId: selectedItem._id) { error in
                        guard error == nil else { return }
                        dismiss()
                    }
                }
                
            }
        }
        .toolbar {
            if detailType == .update {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Delete item", systemImage: "trash", role: .destructive) {
                            showDeleteConfirmation = true
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22)
                    }
                    .foregroundStyle(.accent)
                    
                }
            }
        }
        
    } //: Body
    
    
}

#Preview {
    ItemDetailView(item: ItemEntity(), detailType: .create) {}
        .environment(\.realm, DepartmentEntity.previewRealm)
        .background(Color.bg)
}

