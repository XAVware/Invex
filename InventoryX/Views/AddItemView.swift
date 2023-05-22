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
    @ObservedResults(CategoryEntity.self) var categories
    @State var itemName: String = ""
    @State var quantity: String = ""
    @State var retailPrice: String = ""
    @State var unitCost: String = ""
    @State var category: CategoryEntity!
            
    func saveItem(completion: @escaping () -> Void) {
        guard let category = category else {
            print("Category is nil")
            return
        }
        guard itemName.isNotEmpty, quantity.isNotEmpty, retailPrice.isNotEmpty else { return }
        let newItem = InventoryItemEntity(name: itemName, retailPrice: Double(retailPrice) ?? 1.0, avgCostPer: Double(unitCost) ?? 0.5, onHandQty: Int(quantity) ?? 10)
        
        do {
            let realm = try Realm()
            guard let selectedCategory = realm.objects(CategoryEntity.self).where({ tempCategory in
                tempCategory._id == category._id
            }).first else {
                print("Error setting selected category.")
                return
            }
            
            let originalItems = selectedCategory.items
            
            print("Original Items: \(originalItems)")
            
            try realm.write {
                var newItemsList = originalItems
                newItemsList.append(newItem)
                
                print("New Items: \(newItemsList)")
                
                selectedCategory.items = newItemsList
                self.category = selectedCategory
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
                
                if let category = category {
                    HStack {
                        Text("Category:")
                        Spacer()
                        Picker(selection: $category) {
                            ForEach(categories) { category in
//                                Text(category.name).tag(category as CategoryEntity?)
                                Text(category.name).tag(category.name)
                            }
                        } label: {
                            Text("Category")
                        }
                        .tint(darkTextColor)
                    }
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
            category = categories.first
        }
    } //: Body
}


struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
            .modifier(PreviewMod())
    }
}
