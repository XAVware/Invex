//
//  AddItemView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 6/24/23.
//

import SwiftUI
import RealmSwift

@MainActor class AddItemViewModel: ObservableObject {
    @Published var itemName: String = ""
    @Published var quantity: String = ""
    @Published var retailPrice: String = ""
    @Published var unitCost: String = ""
    @Published var selectedCategoryName: String = "Select Category"
    @Published var categoryModels: [CategoryModel] = []
    @Published var categoryNames: [String] = ["Select Category"]
    @Published var errorMessage: String = ""
    @Published var savedSuccessfully: Bool = false
    
    func setup() {
        setCategoryNames()
    }
    
    func reset() {
        itemName = ""
        quantity = ""
        retailPrice = ""
        unitCost = ""
        selectedCategoryName = "Select Category"
    }
    
    private func setCategoryNames() {
        do {
            let realm = try Realm()
            let results = realm.objects(DepartmentEntity.self)
            
            for index in 0 ..< results.count {
                let tempId: ObjectId = results[index]._id
                let tempName: String = results[index].name
                let tempCategory: CategoryModel = CategoryModel(_id: tempId, name: tempName)
                categoryModels.append(tempCategory)
                categoryNames.append(tempName)
            }
        } catch {
            LogService(self).error("Error setting category names: \(error.localizedDescription)")
        }
    }
    
    func saveItem(completion: @escaping () -> Void) {
        guard itemName.isNotEmpty, quantity.isNotEmpty, retailPrice.isNotEmpty else { return }
        guard selectedCategoryName != categoryNames[0] else { return }
        
        let newItem = ItemEntity(name: itemName, retailPrice: Double(retailPrice) ?? 1.0, avgCostPer: Double(unitCost) ?? 0.5, onHandQty: Int(quantity) ?? 10)
        
        Task {
            do {
                guard let departmentResult = try await DataService.fetchDepartment(named: selectedCategoryName) else { return }
                
                try await DataService.add(newItem, to: departmentResult)
                completion()
                
            } catch {
                LogService(self).error("Error saving item to Realm: \(error.localizedDescription)")
            }
        }
    } //: Save Item
}

struct AddItemView: View {
    @StateObject var vm: AddItemViewModel = AddItemViewModel()
    @EnvironmentObject var navMan: NavigationManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Theme.secondaryBackground
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 32) {
                Text("New Item")
                    .modifier(TextMod(.largeTitle, .semibold))
                
                Spacer()
                
                Picker(selection: $vm.selectedCategoryName) {
                    ForEach(vm.categoryNames, id: \.self) { name in
                        Text(name)
                    }
                } label: { }
                .padding(.horizontal)
                .tint(Theme.darkFgColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 10).stroke(Theme.darkFgColor, lineWidth: 1)
                )
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Item Name")
                        .modifier(TextMod(.body, .regular, Theme.darkFgColor))
                    
                    TextField("", text: $vm.itemName)
                        .frame(height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6).stroke(Theme.darkFgColor, lineWidth: 1)
                        )
                } //: VStack
                
                HStack {
                    Text("On-Hand Qty.")
                        .modifier(TextMod(.body, .regular, Theme.darkFgColor))
                    
                    Spacer()
                    
                    TextField("", text: $vm.quantity)
                        .frame(width: 120, height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8).stroke(Theme.darkFgColor, lineWidth: 1)
                        )
                } //: HStack

                HStack {
                    Text("Retail Price")
                        .modifier(TextMod(.body, .regular, Theme.darkFgColor))
                    
                    Spacer()
                    
                    Text("$")
                        .modifier(TextMod(.body, .regular, Theme.darkFgColor))
                    
                    TextField("", text: $vm.retailPrice)
                        .frame(width: 120, height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8).stroke(Theme.darkFgColor, lineWidth: 1)
                        )
                } //: HStack
                
                HStack {
                    Text("Unit Cost")
                        .modifier(TextMod(.body, .regular, Theme.darkFgColor))
                    
                    Spacer()
                    
                    Text("$")
                        .modifier(TextMod(.body, .regular, Theme.darkFgColor))
                    
                    TextField("", text: $vm.unitCost)
                        .frame(width: 120, height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8).stroke(Theme.darkFgColor, lineWidth: 1)
                        )
                } //: HStack
                
                Spacer()
                
                Button {
                    vm.saveItem() {
                        vm.reset()
                    }
                } label: {
                    Text("Save and Add Another")
                }
                .modifier(RoundedButtonMod())
                
                Button {
                    vm.saveItem() {
                        navMan.hideDetail(animation: .easeOut)
                    }
                } label: {
                    Text("Save and Finish")
                }
                .modifier(RoundedButtonMod())
                .frame(width: 250)
                
            } //: VStack
            .frame(maxWidth: 400)
            .padding(.bottom)
        } //: ZStack
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            vm.setup()
        }
    } //: Body
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}
