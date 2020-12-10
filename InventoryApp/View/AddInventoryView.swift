//
//  AddInventoryView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/9/20.
//

import SwiftUI

struct AddInventoryView: View {
    @ObservedObject var appManager: AppStateManager
    
    @State var itemName: String = ""
    @State var typeID: Int = 0
    @State var quantityPurchased: Int = 24
    @State var isCustomQuantity: Bool = false
    @State var customValue: String = "10"
    @State var cost: String = "10.00"
    @State var retailPrice: String = "1.00"
    
    var types = ["Food / Snack", "Beverage", "Frozen"]
    var quantities = ["12", "18", "24", "30", "36", "Custom"]
    
    
    var body: some View {
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
            } //: HStack - Title
            .padding()
            
            VStack(spacing: 0) {
                //MARK: - Title Field
                VStack(alignment: .leading, spacing: 5) {
                    
                    Spacer().frame(height: 15)
                    Text("Item Name:")
                        .padding(.horizontal, 3)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                    
                    
                    TextField("Ex. Mt. Dew", text: $itemName)
                        .padding()
                        .background(Color(UIColor.tertiarySystemFill))
                        .cornerRadius(9)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                } //: VStack - Title Field
                
                
                //MARK: - Type Field
                HStack {
                    Text("Type:")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.black)
                    
                    
                    Picker(selection: $typeID, label: Text("")) {
                        ForEach(0..<types.count) { index in
                            Text(self.types[index]).foregroundColor(.black).tag(index)
                                
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 400)
                    .foregroundColor(.black)
                    .accentColor(.black)
                    
                    
                } //: HStack - Type
                .frame(height: 50)
                
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
            } //: VStack - Input Fields
            .frame(width: 800)
            
            Spacer().frame(height: 40)
            
            Button(action: {
                let tempAvgCost = Double(cost)! / Double(quantityPurchased)
                let formattedAvgCost = Double(String(format: "%.2f", tempAvgCost))!

                
                //This should return a success/failure result in case they try and add a new item that already exists
                let newItem = Item()
                newItem.name = self.itemName
                newItem.type = self.types[self.typeID]
                newItem.onHandQty += Int(self.quantityPurchased)
                newItem.avgCostPer = formattedAvgCost
                newItem.retailPrice = self.retailPrice
                
                self.appManager.createNewItem(newItem: newItem)
                
            }) {
                Text("Save")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            .padding()
            .frame(width: 400, height: 60)
            .background(
                RadialGradient(gradient: Gradient(colors: [Color(hex: "237a30").opacity(1), Color(hex: "237a30").opacity(0.7), Color(hex: "4ac29a").opacity(0.9)]), center: .center, startRadius: 50, endRadius: 250)
            )
            .cornerRadius(30)
            .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .accentColor(.black)
    }
    
    
    
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
