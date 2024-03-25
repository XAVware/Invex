//
//  AddItemView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 6/24/23.
//

import SwiftUI
import RealmSwift


@MainActor class AddItemViewModel: ObservableObject {
    
    func saveItem(dept: DepartmentEntity, name: String, att: String, qty: String, price: String, cost: String) {
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
    
    let selectedItem: ItemEntity?
    
    @State var selectedDepartment: DepartmentEntity?
    @State var itemName: String = ""
    @State var attribute: String = ""
    @State var quantity: String = ""
    @State var retailPrice: String = ""
    @State var unitCost: String = ""
    
    @State var isOnboarding: Bool = false
    let completion: (() -> Void)?
    
    var body: some View {
        
        VStack(spacing: 32) {
            VStack(alignment: .leading) {
                if !isOnboarding {
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
                Task {
                    vm.saveItem(dept: dept, name: itemName, att: attribute, qty: quantity, price: retailPrice, cost: unitCost)
                    
                    if !isOnboarding {
                        dismiss()
                    } else {
                        completion?()
                    }
                    
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

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView(selectedItem: nil) {}
        //            .frame(width: 400)
    }
}
