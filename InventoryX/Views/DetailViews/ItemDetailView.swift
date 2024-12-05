//
//  AddItemView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 6/24/23.
//

import SwiftUI
import RealmSwift

struct DepartmentPickerX: View {
    @Environment(FormXViewModel.self) var formVM
    @ObservedResults(DepartmentEntity.self) var departments
    @Binding var selectedDepartment: DepartmentEntity?
    @State var title: String
    @State var description: String
    
    init(dept: Binding<DepartmentEntity?>, title: String, description: String) {
        self._selectedDepartment = dept
        self.title = title
        self.description = description
    }
    
    var body: some View {
        if formVM.expandedContainer == nil {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                    Text(description)
                        .opacity(0.5)
                    
                } //: VStack
                Spacer()
                Picker("", selection: $selectedDepartment) {
                    ForEach(departments) { dept in
                        Text(dept.name)
                            .tag(DepartmentEntity?.none)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .tint(Color.textPrimary)
            } //: HStack
            .padding(.vertical)
        }
    }
}

struct ItemDetailView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: DetailViewModel = DetailViewModel()
    
    /// If the entity's name is empty when it is initially passed to the view, `isNew` is set to true
    let isNew: Bool
        
    @ObservedRealmObject var item: ItemEntity
    @State var showDeleteConfirmation: Bool = false
    
    init(item: ItemEntity) {
        self._item = ObservedRealmObject(wrappedValue: item)
        self.isNew = item.name.isEmpty
    }
    
    func createDefaultItem() {
        do {
            let realm = try Realm()
            let items = realm.objects(ItemEntity.self)
            if items.count == 0 && isNew {
                try realm.write {
                    realm.add(item)
                }
            }
        } catch {
            print("Error creating default company: \(error)")
        }
    }
    
    func validateItemName(value: String) -> (Bool, String?) {
        if value.isEmpty {
            return (false, "Please enter a valid name.")
        } else {
            return (true, nil)
        }
    }
    
    func validateItemAttribute(value: String) -> (Bool, String?) {
        if value.isEmpty {
            return (false, "Please enter a valid attribue.")
        } else {
            return (true, nil)
        }
    }
    
    func saveItemName(validName: String) {
        do {
            let realm = try Realm()
            try realm.write {
                $item.wrappedValue.name = validName
            }
        } catch {
            print("Error saving name: \(error)")
        }
    }
    
    func saveRestockQuantity(validQty: Int) {
        do {
            let realm = try Realm()
            try realm.write {
//                $item.wrappedValue.restockNumber = validQty
            }
        } catch {
            print("Error saving restock quantity: \(error)")
        }
    }
    
    func saveOnHandQty(validQty: Int) {
        do {
            let realm = try Realm()
            try realm.write {
                $item.wrappedValue.onHandQty = validQty
            }
        } catch {
            print("Error saving markup: \(error)")
        }
    }
    
    func saveRetailPrice(validPrice: Double) {
        do {
            let realm = try Realm()
            try realm.write {
                $item.wrappedValue.retailPrice = validPrice
            }
        } catch {
            print("Error saving markup: \(error)")
        }
    }
    
    func saveUnitCost(validCost: Double) {
        do {
            let realm = try Realm()
            try realm.write {
                $item.wrappedValue.unitCost = validCost
            }
        } catch {
            print("Error saving markup: \(error)")
        }
    }
    
//    func saveMarkup(validMarkup: Double) {
//        do {
//            let realm = try Realm()
//            try realm.write {
//                $item.wrappedValue. = validMarkup
//            }
//        } catch {
//            print("Error saving markup: \(error)")
//        }
//    }
    
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
            
            DividerX()
            
            DepartmentPickerX(dept: $selectedDepartment, title: "Department:", description: "Which department is this item in?")
            
            DividerX()
            
            // Attribute Container
            ContainerX(data: containerData[1], value: item.attribute) {
                TextFieldX(value: item.attribute, validate: { value in
                    validateItemAttribute(value: value)
                }, save: { name in
                    Task {
                        saveItemName(validName: name)
                    }
                })
            }
            
            DividerX()
            
            // On hand quantity container
            ContainerX(data: containerData[2], value: item.onHandQty.description) {
                NumberPickerX(number: item.onHandQty) { value in
                    saveOnHandQty(validQty: value)
                }
            }
            
            DividerX()
            
            ContainerX(data: containerData[3], value: item.retailPrice.toCurrencyString()) {
                CurrencyFieldX(amount: item.retailPrice, save: { validPrice in
                    print("Attempting to save retail price: \(validPrice)")
                    saveRetailPrice(validPrice: validPrice)
                })
            }
            
            DividerX()
            
            ContainerX(data: containerData[4], value: item.unitCost.toCurrencyString()) {
                CurrencyFieldX(amount: item.unitCost, save: { validCost in
                    print("Attempting to save unit cost: \(validCost)")
                    saveUnitCost(validCost: validCost)
                })
            }
            
            
        } //: FormX
        .onAppear {
            createDefaultItem()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if !isNew {
                    Menu {
                        Button("Delete Item", systemImage: "trash", role: .destructive) {
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
            Button("Yes, delete item", role: .destructive) {
                Task {
//                    await vm.deleteAccount()
                }
            }
        }

        
    } //: Body
    
//    @Environment(\.dismiss) var dismiss
//    @StateObject var vm: DetailViewModel = DetailViewModel()
//    
    @State private var selectedDepartment: DepartmentEntity?
//    @State private var itemName: String = ""
//    @State private var attribute: String = ""
//    @State private var quantity: String = ""
//    @State private var retailPrice: String = ""
//    @State private var unitCost: String = ""
//    
//    let selectedItem: ItemEntity?
//    let detailType: DetailType
//    
//    @ObservedResults(ItemEntity.self) var items
    @ObservedResults(DepartmentEntity.self) var departments
//    
//    private enum Focus { case name, attribute, price, onHandQty, unitCost }
//    @FocusState private var focus: Focus?
//    
//    @State var showDeleteConfirmation: Bool = false
//    
//    let onSuccess: (() -> Void)?
//    
//    init(item: ItemEntity?, detailType: DetailType, onSuccess: (() -> Void)? = nil) {
//        self.selectedItem = item
//        self.detailType = detailType
//        self.onSuccess = onSuccess
//    }
//    
//    private func continueTapped() {
//        focus = nil
//        let price = retailPrice.replacingOccurrences(of: "$", with: "")
//        let cost = unitCost.replacingOccurrences(of: "$", with: "")
//        
//        
//        Task {
//            
//            if detailType == .update {
//                if let selectedItem = selectedItem {
//                    await vm.updateItem(
//                        item: selectedItem,
//                        name: itemName,
//                        att: attribute,
//                        qty: quantity,
//                        price: price,
//                        cost: cost,
//                        completion: { error in
//                            guard error == nil else { return }
//                            
//                            if let onSuccess = onSuccess {
//                                onSuccess()
//                            } else {
//                                dismiss()
//                            }
//                        })
//                }
//            } else {
//                // Item was nil when passed to view. User is creating a new item.
//                await vm.saveItem(
//                    dept: selectedDepartment,
//                    name: itemName,
//                    att: attribute,
//                    qty: quantity,
//                    price: price,
//                    cost: cost,
//                    completion: { error in
//                        guard error == nil else { return }
//                        
//                        if let onSuccess = onSuccess {
//                            onSuccess()
//                        } else {
//                            dismiss()
//                        }
//                    })
//            }
//        }
//    }
//    
//
//    
//    var body: some View {
//        FormX(title: "Item") {
//            ThemeFormSection(title: "Item Info") {
//                ThemeTextField(boundTo: $itemName, placeholder: "i.e. Gatorade", title: "Item Name:", type: .text)
//                    .focused($focus, equals: .name)
//                    .submitLabel(.return)
//                    .onSubmit { focus = nil }
//                
//                FieldDivider()
//                
//                HStack {
//                    Text("Department:")
//                    Spacer()
//                    Picker("", selection: $selectedDepartment) {
//                        ForEach(departments) { dept in
//                            Text(dept.name)
//                                .tag(DepartmentEntity?.none)
//                                .font(.subheadline)
//                        }
//                    }
//                    .pickerStyle(MenuPickerStyle())
//                    .foregroundStyle(Color.textPrimary)
//                    .tint(Color.textPrimary)
//                    .font(.subheadline)
//                    //                .padding()
//                }
//                FieldDivider()
//                
//                ThemeTextField(boundTo: $attribute, placeholder: "i.e. Blue", title: "Attribute:", type: .text)
//                    .focused($focus, equals: .attribute)
//                    .submitLabel(.return)
//                    .onSubmit { focus = nil }
//            }
//            
//            ThemeFormSection(title: "Stock") {
//                ThemeTextField(boundTo: $quantity, placeholder: "24", title: "On-hand quantity:", type: .integer)
//                    .keyboardType(.numberPad)
//                    .focused($focus, equals: .onHandQty)
//                    .submitLabel(.return)
//                    .onSubmit { focus = nil }
//            }
//            
//            ThemeFormSection(title: "Pricing") {
//                ThemeTextField(boundTo: $retailPrice, placeholder: "$ 2.00", title: "Retail Price:", type: .price)
//                    .keyboardType(.numberPad)
//                    .focused($focus, equals: .price)
//                    .submitLabel(.return)
//                    .onSubmit { focus = nil }
//                
//                FieldDivider()
//                
//                ThemeTextField(boundTo: $unitCost, placeholder: "$ 1.00", title: "Unit Cost:", type: .price)
//                    .keyboardType(.numberPad)
//                    .focused($focus, equals: .unitCost)
//                    .submitLabel(.return)
//                    .onSubmit { focus = nil }
//            }
//            .onChange(of: focus) { _, newValue in
//                if !retailPrice.isEmpty {
//                    if let price = Double(retailPrice) {
//                        self.retailPrice = price.toCurrencyString()
//                    }
//                }
//                
//                if !unitCost.isEmpty {
//                    if let cost = Double(unitCost) {
//                        self.unitCost = cost.toCurrencyString()
//                    }
//                }
//                
//                if let qty = Int(quantity) {
//                    self.quantity = String(describing: qty)
//                }
//            }
//            
//        }
//        .onTapGesture {
//            self.focus = nil
//        }
//        .onAppear {
//            if let selectedItem = selectedItem {
//                itemName = selectedItem.name
//                attribute = selectedItem.attribute
//                
//                if selectedItem.onHandQty > 0 {
//                    quantity = String(describing: selectedItem.onHandQty)
//                }
//                
//                if selectedItem.retailPrice > 0 {
//                    retailPrice = selectedItem.retailPrice.toCurrencyString()
//                }
//                
//                if selectedItem.unitCost > 0 {
//                    unitCost = selectedItem.unitCost.toCurrencyString()
//                }
//            }
//        }
//        .navigationTitle(detailType == .update ? "Edit item" : "Add item")
//        .navigationBarTitleDisplayMode(.large)
//        .overlay(
//            Button(action: continueTapped) {
//                Text("Continue")
//                    .frame(maxWidth: .infinity)
//            }
//                .buttonStyle(ThemeButtonStyle())
//                .padding()
//            , alignment: .bottom)
//        .alert("Are you sure? This can't be undone.", isPresented: $showDeleteConfirmation) {
//            Button("Go back", role: .cancel) { }
//            Button("Yes, delete Item", role: .destructive) {
//                guard let selectedItem = selectedItem else {
//                    print("Trying to delete item but item is nil")
//                    return
//                }
//                
//                Task {
//                    await vm.deleteItem(withId: selectedItem._id) { error in
//                        guard error == nil else { return }
//                        dismiss()
//                    }
//                }
//                
//            }
//        }
//        .toolbar {
//            if detailType == .update {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Menu {
//                        Button("Delete item", systemImage: "trash", role: .destructive) {
//                            showDeleteConfirmation = true
//                        }
//                    } label: {
//                        Image(systemName: "ellipsis.circle")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 22)
//                    }
//                    .foregroundStyle(.accent)
//                    
//                }
//            }
//        }
//        
//    } //: Body
    
    
}

#Preview {
    ItemDetailView(item: ItemEntity())
        .environment(\.realm, DepartmentEntity.previewRealm)
        .background(Color.bg)
}

