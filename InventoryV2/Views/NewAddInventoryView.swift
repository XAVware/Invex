//
//  NewAddInventoryView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/23/20.
//

import SwiftUI
import RealmSwift

struct NewAddInventoryView: View {
    let concessionTypes: [String] = ["Food / Snack" , "Beverage", "Frozen"]
    
    @State var selectedItemType: String = "Food / Snack"
    @State var selectedItemName: String = ""
    
    @State var quantityPurchased: Int       = 24
    @State var isCustomQuantity: Bool       = false
    @State var isIncludingCost: Bool        = false
    @State var isShowingNewItemView: Bool   = false
    @State var isShowingCostView: Bool      = false
    
    @State var quantityOptions: [Int] = [12, 18, 24, 30, 36]
    
    @State var newItemName: String          = ""
    @State var itemSubtype: String          = ""
    @State var concessionTypeID: Int        = 0
    @State var isIncludingSubtype: Bool     = false
    
    @State var newItemPrice: Double                = 1.00
    
    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                HStack {
                    Spacer().frame(width: 130)
                    
                    Text(self.isShowingNewItemView ? "Add New Item" : "Add Inventory")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "365cc4"))
                    
                    Button(action: {
                        withAnimation {
                            self.isShowingNewItemView.toggle()
                        }
                    }) {
                        Text(self.isShowingNewItemView ? "" : "New Item +")
                            .frame(maxWidth: 130, alignment: .center)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(hex: "365cc4"))
                    }
                } //: HStack - Header
                .padding()
                .background(Color.white)
                
                if self.isShowingNewItemView {
                    NewItemView(isShowingNewItemView: self.$isShowingNewItemView)
                } else {
                    ItemSelectorView(selectedItemType: self.$selectedItemType, selectedItemName: self.$selectedItemName)
                    
                    Text(self.selectedItemName == "" ? "Select an Item" : "Selected Item: \(self.selectedItemName)")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "365cc4"))
                    
                    if self.selectedItemName != "" {
                        VStack(alignment: .center, spacing: 30) {
                            HStack(spacing: 0) {
                                Spacer().frame(width: 180)
                                
                                Text("Quantity Purchased:")
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    .foregroundColor(Color(hex: "365cc4"))
                                
                                Toggle(isOn: self.$isCustomQuantity) {
                                    Text("Custom Qty")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(Color(hex: "365cc4"))
                                }
                                .frame(width: 150, alignment: .trailing)
                            } //: HStack Quantity Purchased Title Row
                            .padding(.horizontal)
                            
                            if !self.isCustomQuantity {
                                
                                HStack(spacing: 15) {
                                    ForEach(self.quantityOptions, id: \.self) { value in
                                        Button(action: {
                                            self.quantityPurchased = value
                                        }) {
                                            Text("\(value)").underline(self.quantityPurchased == value ? true : false)
                                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                                .foregroundColor(Color(hex: "365cc4"))
                                                .opacity(self.quantityPurchased == value ? 1.0 : 0.7)
                                        }
                                        .frame(width: 60)
                                    }
                                }//: HStack
                                
                            } else {
                                QuantityStepper(selectedQuantity: self.$quantityPurchased)
                                    .frame(maxWidth: 400)
                            }
                            
                            Button(action: {
                                withAnimation { self.isShowingCostView.toggle() }
                            }) {
                                Text("+ Add Cost of Package")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(Color(hex: "365cc4"))
                                    .opacity(0.8)
                            }
                            
                            SaveItemButton(action: {
                                let predicate = NSPredicate(format: "name CONTAINS %@", self.selectedItemName)
                                let config = Realm.Configuration(schemaVersion: 1)
                                do {
                                    let realm = try Realm(configuration: config)
                                    let result = realm.objects(Item.self).filter(predicate)
                                    for item in result {
                                        try realm.write ({
                                            item.onHandQty += self.quantityPurchased
                                            realm.add(item)
                                        })
                                    }
                                } catch {
                                    print(error.localizedDescription)
                                }
                                
                                self.selectedItemName = ""
                            })
                            
                            
                        } //: VStack
                        .padding()
                        .background(Color.white)
                    }
                    
                    Spacer()
                }
                
                
            } //: VStack -- Main Stack
            .background(Color.white)
            
            if self.isShowingCostView {
                DollarAmountView(closingAction: {
                    withAnimation { self.isShowingCostView = false }
                })
            }
            
        }
        .onChange(of: self.selectedItemType) { (xav) in
            self.selectedItemName = ""
        }
        
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
