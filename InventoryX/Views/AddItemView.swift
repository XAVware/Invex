//
//  AddItemView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 5/2/23.
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
    
    private func setCategoryNames() {
        do {
            let realm = try Realm()
            let results = realm.objects(CategoryEntity.self)
            
            for index in 0 ..< results.count {
                let tempId: ObjectId = results[index]._id
                let tempName: String = results[index].name
                let tempCategory: CategoryModel = CategoryModel(_id: tempId, name: tempName)
                categoryModels.append(tempCategory)
                categoryNames.append(tempName)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveItem(completion: @escaping () -> Void) {
        guard itemName.isNotEmpty, quantity.isNotEmpty, retailPrice.isNotEmpty else { return }
        guard selectedCategoryName != categoryNames[0] else { return }
        
        let newItem = InventoryItemEntity(name: itemName, retailPrice: Double(retailPrice) ?? 1.0, avgCostPer: Double(unitCost) ?? 0.5, onHandQty: Int(quantity) ?? 10)
        
        RealmMinion.addNewItem(newItem: newItem, categoryName: selectedCategoryName) {
            completion()
        }
    } //: Save Item
}

struct AddItemView: View {
    @StateObject var vm: AddItemViewModel = AddItemViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color(XSS.S.color90)
            
            VStack(spacing: 16) {
                Text("New Item")
                    .modifier(TextMod(.largeTitle, .semibold))
                
                Spacer()
                
                AnimatedTextField(boundTo: $vm.itemName, placeholder: "Item Name")
                
                HStack {
                    Text("Category:")
                    
                    Spacer()
                    
                    Picker(selection: $vm.selectedCategoryName) {
                        ForEach(vm.categoryNames, id: \.self) { name in
                            Text(name)
                        }
                    } label: {
                        Text("Category")
                    }
                    .tint(darkTextColor)
                }
                
                AnimatedTextField(boundTo: $vm.quantity, placeholder: "Qty. On-Hand")
                
                AnimatedTextField(boundTo: $vm.retailPrice, placeholder: "Retail Price")
                
                AnimatedTextField(boundTo: $vm.unitCost, placeholder: "Unit Cost")
                
                Spacer()
                
                Button {
                    vm.saveItem() { }
                } label: {
                    Text("Save and Add Another")
                }
                .modifier(RoundedButtonMod())
                
                Button {
                    vm.saveItem() {
                        dismiss()
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
            .modifier(PreviewMod())
    }
}
