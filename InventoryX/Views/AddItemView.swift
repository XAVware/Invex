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
        
        let newItem = ItemEntity(name: name, retailPrice: Double(price) ?? 1.0, avgCostPer: Double(cost) ?? 0.5, onHandQty: Int(qty) ?? 10)
        do {
//            try await DataService.add(newItem, to: dept)
            
            let realm = try Realm()
            try realm.write {
                thawedDept.items.append(newItem)
            }
            
//            let realm = try await Realm()
//            try await realm.asyncWrite {
//                thawedDept.items.append(newItem)
//            }
            
//            if let thawedDepartment = department.thaw() {
//                try await realm.asyncWrite {
//                    thawedDepartment.items.append(item)
//                    
//                }
//            } else {
//                LogService(self).error("Error thawing department")
//            }
            
        } catch {
            LogService(self).error("Error saving item to Realm: \(error.localizedDescription)")
        }
    } //: Save Item
    
    
}

enum DetailViewType { case create, view, modify }

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

    let selectedItem: ItemEntity?
    
    /// Used to hide the back button and title while onboarding.
    @State var showTitles: Bool
    
    /// Used in onboarding view to execute additional logic.
    let onSuccess: (() -> Void)?
    
    @State var detailState: DetailViewType
    
    init(item: ItemEntity?, showTitles: Bool = true, onSuccess: (() -> Void)? = nil) {
        if let item = item {
            self.selectedDepartment = item.department.first
            self.itemName = item.name
//            self.attribute = item.attribute
            self.quantity = String(describing: item.onHandQty)
            self.retailPrice = String(describing: item.retailPrice)
            self.unitCost = String(describing: item.avgCostPer)
            detailState = .modify
        } else {
            detailState = .create
        }
        self.selectedItem = item
        self.showTitles = showTitles
        self.onSuccess = onSuccess
    }
    
    private func continueTapped() {
        switch detailState {
        case .create:
            do {
                try vm.saveItem(dept: selectedDepartment, name: itemName, att: attribute, qty: quantity, price: retailPrice, cost: unitCost)
                if showTitles {
                    dismiss()
                }
                onSuccess?()
            } catch {
                print("Error while saving company: \(error.localizedDescription)")
            }
        case .view:
            return
        case .modify:
            return
        }
    }
    
    var body: some View {
        
        VStack(spacing: 32) {
            VStack(alignment: .leading) {
                if showTitles {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24)
                            .foregroundStyle(.black)
                    }
                }
                
                Text("Add an item")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
            } //: VStack
            .frame(maxWidth: 720)
            
            if selectedItem == nil {
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        InputFieldLabel(title: "Department:", subtitle: nil)
                            .frame(maxWidth: 420, alignment: .leading)
                        
                        
                        DepartmentPicker(selectedDepartment: $selectedDepartment, style: .dropdown)
                            .modifier(ThemeFieldMod())
                            .frame(maxWidth: 280)
                    } //: VStack - Department
                    
                    Spacer()
                } //: HStack
                .frame(maxWidth: 720)
            }
            
            HStack {
                ThemeTextField(boundTo: $itemName,
                               placeholder: "i.e. Gatorade",
                               title: "Item Name:",
                               subtitle: nil,
                               type: .text,
                               layout: .vertical)
                .frame(maxWidth: 280)
                
                Spacer()
                
                ThemeTextField(boundTo: $attribute, placeholder: "i.e. Blue", title: "Attribute:", subtitle: nil, type: .text, layout: .vertical)
                .frame(maxWidth: 280)
                
            } //: HStack
            .frame(maxWidth: 720)
            
            Divider()
            
            HStack {
                ThemeTextField(boundTo: $quantity,
                               placeholder: "24",
                               title: "On-hand quantity:",
                               subtitle: nil,
                               type: .integer,
                               layout: .vertical)
                .frame(maxWidth: 220)
                
                Spacer()
                
                ThemeTextField(boundTo: $retailPrice,
                               placeholder: "$ 2.00",
                               title: "Retail Price:",
                               subtitle: nil,
                               type: .price,
                               layout: .vertical)
                .frame(maxWidth: 220)
//                .onChange(of: retailPrice) { _ in
//                    let formattedPrice = retailPrice.replacingOccurrences( of:"[^0-9.]", with: "", options: .regularExpression)
//                    guard let price = Double(formattedPrice) else {
//                        print("Err")
//                        return
//                    }
//                    retailPrice = price.formatAsCurrencyString()
//                }
                
                
            } //: HStack
            .frame(maxWidth: 720)
            
            HStack {
                ThemeTextField(boundTo: $unitCost,
                               placeholder: "$ 1.00",
                               title: "Unit Cost:",
                               subtitle: nil,
                               type: .price,
                               layout: .vertical)
                .frame(maxWidth: 220)
                
                Spacer()
            } //: HStack
            .frame(maxWidth: 720)
            
            Spacer()
            
            Button {
                guard let dept = selectedDepartment else { return }
                do {
                    try vm.saveItem(dept: dept, name: itemName, att: attribute, qty: quantity, price: retailPrice, cost: unitCost)
                    
                    if showTitles {
                        dismiss()
                    }
                    onSuccess?()
                    
                }
                catch {
                   print(error.localizedDescription)
               }
            } label: {
                Text("Save Item")
            }
            .modifier(PrimaryButtonMod())
            
            Spacer()
            
        } //: VStack
        .padding()
        .toolbar(.hidden, for: .navigationBar)
        .background(Color("Purple050").opacity(0.3))
        .onAppear {
            if let item = selectedItem {
                itemName = item.name
                quantity = String(describing: item.onHandQty!)
                retailPrice = String(describing: item.retailPrice!)
                unitCost = String(describing: item.avgCostPer!)
            }
        }
    } //: Body
}

//struct AddItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddItemView(selectedItem: nil) {}
//        //            .frame(width: 400)
//    }
//}
