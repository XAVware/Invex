//
//  AddItemView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 5/2/23.
//

import SwiftUI
import RealmSwift

struct AddItemView: View {
    @State var errorMessage: String = ""
    @State var savedSuccessfully: Bool = false
    
    //New
    @Environment(\.dismiss) var dismiss
    @State var itemName: String = ""
    @State var quantity: String = ""
    @State var retailPrice: String = ""
    @State var unitCost: String = ""
    
    @State var selectedCategoryName: String = "Select Category"
    @State var categoryModels: [CategoryModel] = []
    
    @State var categoryNames: [String] = ["Select Category"]
    
    func setCategoryNames() {
        do {
            let realm = try Realm()
            let results = realm.objects(CategoryEntity.self)
            
            for index in 0 ..< results.count {
                let tempId: ObjectId = results[index]._id
                let tempName: String = results[index].name
                var tempCategory: CategoryModel = CategoryModel(_id: tempId, name: tempName)
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
        
        do {
            let realm = try Realm()
            guard let selectedCategory = realm.objects(CategoryEntity.self).where({ tempCategory in
                tempCategory.name == selectedCategoryName
            }).first else {
                print("Error setting selected category.")
                return
            }
            
            let originalItems = selectedCategory.items
            
            try realm.write {
                var newItemsList = originalItems
                newItemsList.append(newItem)
                selectedCategory.items = newItemsList
            }
            
            completion()
        } catch {
            print(error.localizedDescription)
        }
    } //: Save Item
    
    var body: some View {
        ZStack {
            Color(XSS.S.color90)
            
            VStack(spacing: 16) {
                Text("New Item")
                    .modifier(TextMod(.largeTitle, .semibold))
                
                Spacer()
                
                AnimatedTextField(boundTo: $itemName, placeholder: "Item Name")
                
                HStack {
                    Text("Category:")
                    
                    Spacer()
                    
                    Picker(selection: $selectedCategoryName) {
                        ForEach(categoryNames, id: \.self) { name in
                            Text(name)
                        }
                    } label: {
                        Text("Category")
                    }
                    .tint(darkTextColor)
                }
                
                AnimatedTextField(boundTo: $quantity, placeholder: "Qty. On-Hand")
                
                AnimatedTextField(boundTo: $retailPrice, placeholder: "Retail Price")
                
                AnimatedTextField(boundTo: $unitCost, placeholder: "Unit Cost")
                
                Spacer()
                
                Button {
                    saveItem() { }
                } label: {
                    Text("Save and Add Another")
                }
                .modifier(RoundedButtonMod())
                
                Button {
                    saveItem() {
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
            setCategoryNames()
        }
    } //: Body
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
            .modifier(PreviewMod())
    }
}
