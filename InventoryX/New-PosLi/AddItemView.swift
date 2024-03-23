//
//  AddItemView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 6/24/23.
//

import SwiftUI
import RealmSwift

@MainActor class AddItemViewModel: ObservableObject {

    func saveItem(dept: DepartmentEntity, name: String, att: String, qty: String, price: String, cost: String, completion: @escaping () -> Void) async {
        guard name.isNotEmpty, qty.isNotEmpty, price.isNotEmpty else { return }
        
        let newItem = ItemEntity(name: name, retailPrice: Double(price) ?? 1.0, avgCostPer: Double(cost) ?? 0.5, onHandQty: Int(qty) ?? 10)
        do {
            try await DataService.add(newItem, to: dept)
            completion()
            
        } catch {
            LogService(self).error("Error saving item to Realm: \(error.localizedDescription)")
        }
    } //: Save Item
    
    
}

// TODO: Error is thrown briefly from the department dropdown after an item was successfully added, therefore changing the department
struct AddItemView: View {
    @StateObject var vm: AddItemViewModel = AddItemViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State var selectedDepartment: DepartmentEntity?
    @State var itemName: String = ""
    @State var attribute: String = ""
    @State var quantity: String = ""
    @State var retailPrice: String = ""
    @State var unitCost: String = ""
    
    var body: some View {
        
        VStack(spacing: 32) {
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
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
            } //: VStack
            .frame(maxWidth: 720)
            
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
            
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    InputFieldLabel(title: "Item Name:", subtitle: nil)
                        .frame(maxWidth: 420, alignment: .leading)
                    
                    
                    TextField("i.e. Gatorade", text: $itemName)
                        .modifier(ThemeFieldMod())
                        .frame(maxWidth: 280)
                    
                } //: VStack
                
                VStack(alignment: .leading, spacing: 12) {
                    InputFieldLabel(title: "Attribute:", subtitle: nil)
                        .frame(maxWidth: 420, alignment: .leading)
                    
                    
                    TextField("i.e. Blue", text: $attribute)
                        .modifier(ThemeFieldMod())
                        .frame(minWidth: 240, maxWidth: 280)
                    
                } //: VStack
            } //: HStack
            .frame(maxWidth: 720)
            
            Divider()
            
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    InputFieldLabel(title: "On-hand quantity:", subtitle: nil)
                        .frame(maxWidth: 420, alignment: .leading)
                    
                    
                    TextField("2.00", text: $quantity)
                        .modifier(ThemeFieldMod(overlayText: "123"))
                        .frame(maxWidth: 280)
                    
                } //: VStack
                
                VStack(alignment: .leading, spacing: 12) {
                    InputFieldLabel(title: "Retail Price:", subtitle: nil)
                        .frame(maxWidth: 420, alignment: .leading)
                    
                    
                    TextField("2.00", text: $retailPrice)
                        .modifier(ThemeFieldMod(overlayText: "$"))
                        .frame(maxWidth: 280)
                    
                } //: VStack
            } //: HStack
            .frame(maxWidth: 720)
            
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    InputFieldLabel(title: "Unit Cost:", subtitle: nil)
                        .frame(maxWidth: 420, alignment: .leading)
                    
                    
                    TextField("1.00", text: $unitCost)
                        .modifier(ThemeFieldMod(overlayText: "$"))
                        .frame(minWidth: 240, maxWidth: 280)
                    
                } //: VStack
                
                Spacer()
            } //: HStack
            .frame(maxWidth: 720)
            
            
            Spacer()
            
            Button {
                guard let dept = selectedDepartment else { return }
                Task {
                    await vm.saveItem(dept: dept, name: itemName, att: attribute, qty: quantity, price: retailPrice, cost: unitCost) {
                        dismiss()
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
//        .onAppear {
//            vm.setup()
//        }
    } //: Body
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
//            .frame(width: 400)
    }
}
