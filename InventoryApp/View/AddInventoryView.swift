//
//  AddInventoryView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/9/20.
//

import SwiftUI

struct AddInventoryView: View {
    @ObservedObject var appManager: AppStateManager
    
    @State var newItemName: String          = ""
    @State var quantityPurchased: Int       = 24
    @State var isCustomQuantity: Bool       = false
    @State var customValue: String          = "10"
    @State var cost: String                 = "10.00"
    @State var retailPrice: String          = "1.00"
    
    @State var restockTypeID: Int           = 0
    var restockTypes: [String]              = ["Restock Item", "New Item"]
    
    @State var concessionTypeID: Int        = 0
    var concessionTypes: [String]           = ["Food / Snack", "Beverage", "Frozen"]
    
    var quantities: [String]                = ["12", "18", "24", "30", "36", "Custom"]
    
    @State var selectedItemIndex: Int = 0
    
    var body: some View {
        
        ScrollView {
            VStack {
                //MARK: - Title Section
                HStack(spacing: 20) {
                    HeaderLabel(title: "Add Inventory")
                    
                    Spacer()
                    
                    AddInventoryDetailLabel(title: "Item Type:")
                    
                    Picker(selection: $concessionTypeID, label: Text("")) {
                        ForEach(0 ..< concessionTypes.count) { index in
                            Text(self.concessionTypes[index]).foregroundColor(.black).tag(index)
                        }
                    }
                    .padding(.trailing)
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 400)
                    .onChange(of: concessionTypeID, perform: { value in
                        for item in self.appManager.itemList {
                            if item.type == concessionTypes[concessionTypeID] {
                                self.selectedItemIndex = self.appManager.itemList.firstIndex(of: item)!
                                return
                            }
                        }
                    })
                } //: HStack - Title Section
                
                Divider()
                
                
                Picker(selection: $restockTypeID, label: Text("")) {
                    ForEach(0 ..< restockTypes.count) { index in
                        Text(self.restockTypes[index]).foregroundColor(.black).tag(index)
                    }
                }
                .padding(.vertical, 20)
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 400)
                

                //MARK: Item Info Stack
                VStack(alignment: .center, spacing: 0) {
                    //MARK: - Title Field
                    HStack(alignment: .center, spacing: 10) {
                        
                        Text(restockTypeID == 1 ? "Item Name:" : "Select Item:")
                            .padding(.horizontal, 3)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                        
                        if restockTypeID == 1 {
                            TextField("Ex. Mt. Dew", text: $newItemName)
                                .padding()
                                .background(Color(UIColor.tertiarySystemFill))
                                .cornerRadius(9)
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                        } else {
                            Picker(selection: $selectedItemIndex, label: Text("")) {
                                ForEach(0 ..< self.appManager.itemList.count) { itemIndex in
                                    let tempItem = self.appManager.itemList[itemIndex]
                                    if tempItem.type == concessionTypes[concessionTypeID] {
                                        Text("\(tempItem.name)").foregroundColor(.black)
                                    }
                                }
                            }
                            .frame(width: 400, height: 180)
                            
                        }
                    } //: HStack - Title Field
                    .frame(height: withAnimation { restockTypeID == 0 ? 180 : 70 })
                    
                    Divider()
                    
                    HStack {
                        AddInventoryDetailLabel(title: "Quantity Purchased: ")
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        QuantityPicker(selectedQuantity: $quantityPurchased)
                    }
                    .frame(height: 50)
                    
                    
                    Divider()
                    
                    //MARK: - Package Price Field
                    HStack {
                        AddInventoryDetailLabel(title: "Cost of Package:")
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("$")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                        
                        TextField("19.99", text: $cost)
                            .padding()
                            .multilineTextAlignment(.center)
                            .background(
                                Color(UIColor.tertiarySystemFill)
                                    .frame(height: 35)
                                    .cornerRadius(9)
                            )
                            .cornerRadius(9)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .frame(width: 100, height: 40)
                            .foregroundColor(.black)
                        
                        
                        
                    } //: HStack - Package Cost
                    .frame(height: 50)
                    
                    Divider()
                    
                    //MARK: - Retail Price Field
                    HStack {
                        AddInventoryDetailLabel(title: "Retail Price:")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.black)
                        
                        Text("$")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                        
                        TextField("1.00", text: $retailPrice)
                            .padding()
                            .multilineTextAlignment(.center)
                            .background(
                                Color(UIColor.tertiarySystemFill)
                                    .frame(height: 35)
                                    .cornerRadius(9)
                            )
                            .cornerRadius(9)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .frame(width: 100, height: 40)
                    } //: HStack - Type
                    .frame(height: 50)
                    
                    Divider()
                } //: VStack - Item Info Stack
                .frame(width: 800)
                
                Spacer().frame(height: 40)
                
                SaveItemButton(action: {
                    if restockTypeID == 0 {
                        self.appManager.restockItem(itemIndex: self.selectedItemIndex, quantity: self.quantityPurchased)
                    } else {
                        let tempAvgCost = Double(cost)! / Double(quantityPurchased)
                        let formattedAvgCost = Double(String(format: "%.2f", tempAvgCost))!

                        //This should return a success/failure result in case they try and add a new item that already exists
                        let newItem = Item()
                        newItem.name = self.newItemName
                        newItem.type = self.concessionTypes[self.concessionTypeID]
                        newItem.onHandQty += Int(self.quantityPurchased)
                        newItem.avgCostPer = formattedAvgCost
                        newItem.retailPrice = self.retailPrice

                        self.appManager.createNewItem(newItem: newItem)
                    }
                })
                
                Spacer()
                
            } //: VStack
            
        } //: Scroll
        .background(Color.white)
        .navigationBarHidden(true)
        
        
        
    } //: Body
    
    init(appManager: AppStateManager) {
        self.appManager = appManager
        UITextField.appearance().attributedText = NSAttributedString(string: "Ex. Mt. Dew", attributes: [NSAttributedString.Key.foregroundColor: Color.black])
    }
}
