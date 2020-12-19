//
//  AddInventoryView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/9/20.
//

import SwiftUI

struct AddInventoryView: View {
    @ObservedObject var appManager: AppStateManager
    
    @State var newItemName: String             = ""
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
    
    @State var itemID: Int                  = 0
    
    
    var body: some View {
        
        ScrollView {
            VStack {
                HStack(spacing: 20) {
                    Image(systemName: "dollarsign.square")
                        .resizable()
                        .scaledToFit()
                        .font(.system(size: 36, weight: .semibold))
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                    
                    Text("Add Inventory")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text("Item Type:")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                    
                    
                    Picker(selection: $concessionTypeID, label: Text("")) {
                        ForEach(0 ..< concessionTypes.count) { index in
                            Text(self.concessionTypes[index]).foregroundColor(.black).tag(index)
                            
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 400)
                    
                } //: HStack - Title
                .padding(.horizontal, 30)
                .padding(.top)
                
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
                            Picker(selection: $itemID, label: Text("")) {
                                ForEach(self.appManager.itemList, id: \.self) { item in
                                    if item.type == concessionTypes[concessionTypeID] {
                                        Text("\(item.name)").foregroundColor(.black)
                                    }
                                }
                            }
                            .frame(width: 400, height: 180)
                            .foregroundColor(.black)
                            .accentColor(.black)
                            
                        }
                    } //: HStack - Title Field
                    .frame(height: restockTypeID == 0 ? 180 : 70)
                    
                    Divider()
                    
                    //MARK: - Quantity Purchased Field
                    HStack {
                        Text("Quantity Purchased:")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        //MARK: - Quantity Buttons
                        HStack {
                            Spacer(minLength: 0)
                            
                            Button(action: {
                                if self.isCustomQuantity { withAnimation { self.isCustomQuantity.toggle() } }
                                self.quantityPurchased = 12
                            }) {
                                Text("12")
                                    .font(.system(size: 18, weight: quantityPurchased == 12 ? .semibold : .light, design: .rounded))
                                    .foregroundColor(.black)
                            }
                            .frame(width: 30)
                            
                            Button(action: {
                                if self.isCustomQuantity { withAnimation { self.isCustomQuantity.toggle() } }
                                self.quantityPurchased = 18
                            }) {
                                Text("18")
                                    .font(.system(size: 18, weight: quantityPurchased == 18 ? .semibold : .light, design: .rounded))
                                    .foregroundColor(.black)
                            }
                            .frame(width: 30)
                            
                            Button(action: {
                                if self.isCustomQuantity { withAnimation { self.isCustomQuantity.toggle() } }
                                self.quantityPurchased = 24
                            }) {
                                Text("24")
                                    .font(.system(size: 18, weight: quantityPurchased == 24 ? .semibold : .light, design: .rounded))
                                    .foregroundColor(.black)
                            }
                            .frame(width: 30)
                            
                            Button(action: {
                                if self.isCustomQuantity { withAnimation { self.isCustomQuantity.toggle() } }
                                self.quantityPurchased = 30
                            }) {
                                Text("30")
                                    .font(.system(size: 18, weight: quantityPurchased == 30 ? .semibold : .light, design: .rounded))
                                    .foregroundColor(.black)
                            }
                            .frame(width: 30)
                            
                            Button(action: {
                                if self.isCustomQuantity { withAnimation { self.isCustomQuantity.toggle() } }
                                self.quantityPurchased = 36
                            }) {
                                Text("36")
                                    .font(.system(size: 18, weight: quantityPurchased == 36 ? .semibold : .light, design: .rounded))
                                    .foregroundColor(.black)
                            }
                            .frame(width: 30)
                            
                            Button(action: {
                                self.quantityPurchased = 0
                                withAnimation {
                                    self.isCustomQuantity.toggle()
                                }
                            }) {
                                Text("Custom")
                                    .font(.system(size: 18, weight: self.isCustomQuantity ? .semibold : .light, design: .rounded))
                                    .foregroundColor(.black)
                            }
                            .frame(width: 70)
                            
                            
                            if self.isCustomQuantity {
                                HStack(spacing: 10) {
                                    Button(action: {
                                        
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                            .accentColor(Color.blue.opacity(0.8))
                                    }
                                    
                                    TextField("", text: $customValue)
                                        .padding()
                                        .foregroundColor(.black)
                                        .background(
                                            Color(UIColor.tertiarySystemFill)
                                                .cornerRadius(9)
                                                .frame(height: 30, alignment: .center)
                                        )
                                        .frame(width: 80, height: 40, alignment: .center)
                                        .multilineTextAlignment(.center)
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                    
                                    
                                    Button(action: {
                                        
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                            .accentColor(Color.blue.opacity(0.8))
                                    }
                                }
                                
                            }
                            
                        }//: HStack
                        .frame(width: 410, height: 30)
                        
                        
                    } //: HStack - Quantity Purchased
                    .frame(height: 50)
                    
                    Divider()
                    
                    //MARK: - Package Price Field
                    HStack {
                        Text("Cost of Package:")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
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
                        Text("Retail Price:")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .multilineTextAlignment(.leading)
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
                        print("Restock Item Save Triggered")
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
            .padding()
        } //: Scroll
        .background(Color.white)
        .navigationBarHidden(true)
        
        
    } //: Body
    
    init(appManager: AppStateManager) {
        self.appManager = appManager
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(named: "ColorWatermelonDark")
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        
        UITextField.appearance().attributedText = NSAttributedString(string: "Ex. Mt. Dew", attributes: [NSAttributedString.Key.foregroundColor: Color.black])
        
    }
}

struct AddInventoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddInventoryView(appManager: AppStateManager())
            .previewLayout(.fixed(width: 1024, height: 786))
    }
}
