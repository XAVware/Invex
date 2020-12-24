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
    @State var isIncludingCost: Bool        = false
    @State var isShowingNewItemView: Bool   = false
    @State var isShowingCostView: Bool      = false
    
    @State var quantityOptions: [Int] = [12, 18, 24, 30, 36]
    
    var body: some View {
        ZStack {
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
                        withAnimation {
                            self.isShowingNewItemView = true
                        }
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
                        
                        
                    } //: VStack
                    .padding()
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
                    

                })
                
                Spacer()
            } //: VStack -- Main Stack
            
            Color.black.opacity(self.isShowingCostView ? 0.3 : 0).edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation { self.isShowingCostView = false }
                }
            
            if self.isShowingCostView {
                DollarAmountView(closingAction: {
                    withAnimation { self.isShowingCostView = false }
                })
            }
            
            NewItemView(closingAction: {
                withAnimation { self.isShowingNewItemView = false }
            }).opacity(self.isShowingNewItemView ? 1 : 0)
            
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
