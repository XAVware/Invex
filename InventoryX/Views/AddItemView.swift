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
    
    
    func saveItem() {
        
        guard itemName.isNotEmpty, quantity.isNotEmpty, retailPrice.isNotEmpty else { return }
        let newItem = InventoryItemEntity(name: itemName, retailPrice: Double(retailPrice) ?? 1.0, avgCostPer: Double(unitCost) ?? 0.5, onHandQty: Int(quantity) ?? 10)
        
        do {
            let realm = try Realm()
            try realm.write {
                if let category = self.category {
                    category.$items.append(newItem)
                }
                
            }
        } catch {
            print(error.localizedDescription)
        }
        
    
    }
    
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
                                Text(category.name).tag(category as CategoryEntity?) 
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
                    saveItem()
                } label: {
                    Text("Save and Add Another")
                }
                .modifier(RoundedButtonMod())
                
                Button {
                    //
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
