//
//  NewAddInventoryView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/23/20.
//

import SwiftUI
import RealmSwift

struct NewAddInventoryView: View {
    let inventoryList: Results<Item> = try! Realm().objects(Item.self)
    let itemTypes: [String] = ["Food / Snack" , "Beverage", "Frozen"]
    
    @State var selectedItemType: String = "Food / Snack"
    @State var selectedItemName: String = ""
    
    @State var quantityPurchased: Int       = 24
    @State var isCustomQuantity: Bool       = false
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
//                Button(action: {
//
//                }) {
//                    Image(systemName: "line.horizontal.3")
//                        .resizable()
//                        .scaledToFit()
//                        .accentColor(.white)
//                        .font(.system(size: 24, weight: .medium))
//                        .frame(width: 35, height: 35)
//                }
//                .padding(10)
//                .background(Color(hex: "365cc4"))
//                .cornerRadius(9)
                
                Spacer().frame(width: 130)
                
                Text("Add Inventory")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(hex: "365cc4"))
                
                Button(action: {
                    
                }) {
                    Text("New Item +")
                        .frame(maxWidth: 130, alignment: .center)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "365cc4"))
                }
            } //: HStack - Header
            .padding()
            
            
            //MARK: - Item Selector
            HStack(spacing: 0) {
                List {
                    ForEach(self.itemTypes, id: \.self) { typeString in
                        Button(action: {
                            self.selectedItemType = typeString
                        }) {
                            HStack {
                                Text(typeString)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.system(size: 18, weight: self.selectedItemType == typeString ? .semibold : .light, design: .rounded))
                                
                                
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 10, height: 15)
                                    .font(.system(size: 18, weight: self.selectedItemType == typeString ? .semibold : .light, design: .rounded))
                            }
                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                        .background(
                            self.selectedItemType == typeString ? Color.gray.opacity(0.3) : Color.white
                        )
          
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                } //: List - Item Type
                .frame(width: UIScreen.main.bounds.width * 0.30)
                .background(Color.white)
                
                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.07), Color.black.opacity(0)]), startPoint: .leading, endPoint: .trailing)
                    .frame(maxWidth: 5, maxHeight: .infinity)
                
                Spacer().frame(width: 10)
                
                List {
                    ForEach(self.getItemsOfType(self.$selectedItemType.wrappedValue), id: \.self) { item in
                        
                        Button(action: {
                            self.selectedItemName = item.name
                        }) {
                            HStack(spacing: 25) {
                                Image(systemName: self.selectedItemName == item.name ? "checkmark.circle.fill" : "circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .font(.system(size: 18, weight: .light, design: .rounded))
                                    .foregroundColor(Color(hex: "365cc4"))
                                
                                Text(item.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.system(size: 18, weight: self.selectedItemName == item.name ? .semibold : .light, design: .rounded))
                            
                            }
                        }
                        .frame(height: 50)
                        .padding(.horizontal)
                        
                        
                        
                    } //: ForEach
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                } //: List - Item Name
                
            } //: HStack - Lists
            .frame(height: UIScreen.main.bounds.height * 0.30)
            .background(Color.white)
            .border(Color.black.opacity(0.07), width: 1)
            
            Text(self.selectedItemName == "" ? "Select an Item" : "Selected Item: \(self.selectedItemName)")
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(Color(hex: "365cc4"))
            
            if self.selectedItemName != "" {
                VStack(alignment: .center, spacing: 20) {
                    HStack {
                        Spacer().frame(width: 150)
                        
                        Text("Quantity Purchased:")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(hex: "365cc4"))
                        
                        
                    }
                    
                    
                    HStack(spacing: 15) {
                        QuantityButton(selectedQuantity: self.$quantityPurchased, value: 12) {
                            if self.isCustomQuantity { withAnimation { self.isCustomQuantity.toggle() } }
                        }
                        
                        QuantityButton(selectedQuantity: self.$quantityPurchased, value: 18) {
                            if self.isCustomQuantity { withAnimation { self.isCustomQuantity.toggle() } }
                        }
                        
                        QuantityButton(selectedQuantity: self.$quantityPurchased, value: 24) {
                            if self.isCustomQuantity { withAnimation { self.isCustomQuantity.toggle() } }
                        }
                        
                        QuantityButton(selectedQuantity: self.$quantityPurchased, value: 30) {
                            if self.isCustomQuantity { withAnimation { self.isCustomQuantity.toggle() } }
                        }
                        
                        QuantityButton(selectedQuantity: self.$quantityPurchased, value: 36) {
                            if self.isCustomQuantity { withAnimation { self.isCustomQuantity.toggle() } }
                        }
                        
                        Button(action: {
                            withAnimation { self.isCustomQuantity.toggle() }
                        }) {
                            Text("Custom")
                                .font(.system(size: 18, weight: self.isCustomQuantity ? .semibold : .light, design: .rounded))
                                .foregroundColor(.black)
                        }
                        .frame(width: 70)
                        
                    }//: HStack
                    
                    if self.isCustomQuantity {
                        QuantityStepper(selectedQuantity: self.$quantityPurchased)
                    }
                }
                .padding()
            }
            
            
            Spacer()
        } //: VStack
        
        
    } //: Body
    
    
    func getItemsOfType(_ type: String) -> Results<Item> {
        return try! Realm().objects(Item.self).filter(NSPredicate(format: "type CONTAINS %@", type))
    }
}

struct NewAddInventoryView_Previews: PreviewProvider {
    static var previews: some View {
        NewAddInventoryView().previewLayout(.fixed(width: 1024, height: 768))
    }
}
