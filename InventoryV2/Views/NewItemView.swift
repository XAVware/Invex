//
//  NewItemView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/24/20.
//

import SwiftUI
import RealmSwift

struct NewItemView: View {
    @Binding var isShowingNewItemView: Bool
    @State private var keyboardHeight: CGFloat = 0
    
    @State var newItemName: String          = ""
    @State var itemSubtype: String          = ""
    var concessionTypes: [String]           = ["Food / Snack", "Beverage", "Frozen"]
    @State var hasSubtype: Bool             = false
    @State var newItemPrice: Double         = 1.00
    @State var quantityOptions: [Int] = [12, 18, 24, 30, 36]
    
    @State var isCustomQuantity: Bool       = false
    @State var quantityPurchased: Int       = 24
    @State var isShowingCostView: Bool      = false
    
    @State var typeExpanded: Bool           = false
    @State var priceExpanded: Bool          = false
    @State var quantityExpanded: Bool       = false
    
    @State var errorMessage: String         = ""
    
    @State var newItemType: String = "-Select Type-"
    
    var body: some View {
        
        LazyVStack(alignment: .center, spacing: 20) {
            
            VStack(alignment: .center, spacing: 5) {
                TextField("Item Name:", text: $newItemName)
                    .padding(10)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(UITextAutocapitalizationType.words)
                
                if self.hasSubtype {
                    TextField("Subtype:", text: $itemSubtype)
                        .padding(10)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .frame(maxWidth: 450)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(UITextAutocapitalizationType.words)
                }
                
                Button(action: {
                    if self.hasSubtype {
                        self.itemSubtype = ""
                    }
                    withAnimation { self.hasSubtype.toggle() }
                }) {
                    Text(self.hasSubtype ? "- Remove Subtype" : "+ Include Subtype")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "365cc4"))
                        .opacity(0.8)
                }
            } //: VStack - Item Name
            
            
            VStack(alignment: .center, spacing: 10) {
                Text("Item Type:")
                    .frame(maxWidth:.infinity, alignment: .leading)
                    .font(.footnote)
                    .foregroundColor(.black)
                
                GroupBox {
                    
                    DisclosureGroup(isExpanded: self.$typeExpanded) {
                        
                        VStack(spacing: 0) {
                            
                            ForEach(self.concessionTypes, id: \.self) { typeString in
                                
                                Button(action: {
                                    self.newItemType = typeString
                                    withAnimation {
                                        self.typeExpanded = false
                                    }
                                }) {
                                    HStack {
                                        
                                        Text(typeString)
                                            .font(.system(size: 18, design: .rounded))
                                            .foregroundColor(Color(hex: "365cc4"))
                                        
                                        Spacer()
                                        
                                        Image(systemName: self.newItemType == typeString ? "checkmark.circle.fill" : "circle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                            .font(.system(size: 18, weight: .light, design: .rounded))
                                            .foregroundColor(Color(hex: "365cc4"))
                                        
                                    } //: HStack - DisclosureBox Label
                                    
                                }
                                .frame(maxWidth: .infinity, maxHeight: 50)
                                .padding()
                                
                                if typeString != concessionTypes[concessionTypes.count - 1] {
                                    Divider()
                                }
                                
                            }
                            
                        } //: VStack
                        .background(Color.clear)
                        
                    } label: {
                        HStack {
                            Text("\(self.$newItemType.wrappedValue)")
                                .frame(maxWidth:.infinity, alignment: .leading)
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(Color(hex: "365cc4"))
                            
                            Text(self.typeExpanded ? "Confirm" : "Change")
                                .frame(maxWidth:.infinity, alignment: .trailing)
                                .font(.footnote)
                                .foregroundColor(Color(hex: "365cc4"))
                        }
                        .onTapGesture {
                            withAnimation { self.typeExpanded.toggle() }
                        }
                        
                        
                    } //: DisclosureGroup
                    .accentColor(Color(hex: "365cc4"))
                    
                } //: GroupBox - ItemType
                
                
            }
            
            VStack(spacing: 10) {
                Text("Retail Price:")
                    .frame(maxWidth:.infinity, alignment: .leading)
                    .font(.footnote)
                    .foregroundColor(.black)
                
                GroupBox {
                    
                    DisclosureGroup(isExpanded: self.$priceExpanded) {
                        Slider(value: $newItemPrice, in: 0.00 ... 5.00, step: 0.25)
                            .frame(width: 400)
                            .padding()
                    } label: {
                        HStack {
                            Spacer().frame(width: self.priceExpanded ? 100 : 0)
                            
                            Text("$\(String(format: "%.2f", self.newItemPrice))")
                                .frame(maxWidth:.infinity, alignment: self.priceExpanded ? .center : .leading)
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(Color(hex: "365cc4"))
                            
                            Text(self.priceExpanded ? "Confirm" : "Change")
                                .frame(maxWidth: 80, alignment: .trailing)
                                .font(.footnote)
                                .foregroundColor(Color(hex: "365cc4"))
                        } //: HStack
                        .onTapGesture {
                            withAnimation { self.priceExpanded.toggle() }
                        }
                        
                    } //: DisclosureGroup
                    .accentColor(Color(hex: "365cc4"))
                    
                } //: GroupBox - Price
                
            }
            
            VStack(spacing: 10) {
                Text("Quantity Purchased:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.footnote)
                    .foregroundColor(.black)
                
                GroupBox {
                    
                    DisclosureGroup(isExpanded: self.$quantityExpanded) {
                        VStack {
                            HStack(spacing: 0) {
                                Spacer()
                                
                                Toggle(isOn: self.$isCustomQuantity) {
                                    Text("Custom Qty")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(Color(hex: "365cc4"))
                                }
                                .frame(maxWidth: 150)
                                .padding(.horizontal)
                                
                            } //: HStack
                            
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
                        }
                    } label: {
                        HStack {
                            
                            Text("\(self.quantityPurchased)")
                                .frame(maxWidth:.infinity, alignment: .leading)
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(Color(hex: "365cc4"))
                            
                            Text(self.quantityExpanded ? "Confirm" : "Change")
                                .frame(maxWidth: 80, alignment: .trailing)
                                .font(.footnote)
                                .foregroundColor(Color(hex: "365cc4"))
                        } //: HStack
                        .onTapGesture {
                            withAnimation { self.quantityExpanded.toggle() }
                        }
                        
                    } //: DisclosureGroup
                    .accentColor(Color(hex: "365cc4"))
                    
                } //: GroupBox - Price
                
            }
            
            
            Text(self.$errorMessage.wrappedValue)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(.red)
            
            
            SaveItemButton(action: {
                self.errorMessage = ""
                self.newItemName = self.newItemName.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !self.newItemName.isEmpty else {
                    self.errorMessage = "Please Enter a Valid Item Name"
                    return
                }
                
                guard self.newItemType != "-Select Type-" else {
                    self.errorMessage = "Please Select an Item Type"
                    withAnimation {
                        self.typeExpanded = true
                    }
                    return
                }
                
                let newItem = Item()
                newItem.name = self.newItemName
                
                
                newItem.subtype = self.itemSubtype
                
                
                newItem.type = self.newItemType
                newItem.retailPrice = String(format: "%.2f", self.newItemPrice)
                
                let namePredicate = NSPredicate(format: "name CONTAINS %@", self.newItemName)
                
                
                
                do {
                    let realm = try! Realm()
                    let result = realm.objects(Item.self).filter(namePredicate)
                    
                    
                    for item in result {
                        guard item.subtype != self.itemSubtype else {
                            print(item)
                            self.errorMessage = "Item with name \(self.newItemName) - \(self.itemSubtype) already exists"
                            return
                        }
                    }

                    try realm.write ({
                        realm.add(newItem)
                    })
                } catch {
                    print(error.localizedDescription)
                }
                
                self.isShowingNewItemView = false
            }) //: Save Button
            .buttonStyle(PlainButtonStyle())
            .padding()
            
            Spacer()
        } //: LazyVStack
        .frame(maxWidth: 550)
        .padding()
        .padding(.top, self.$keyboardHeight.wrappedValue)
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (not) in
                let data = not.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
                let height = data.cgRectValue.height - (UIApplication.shared.windows.first?.safeAreaInsets.bottom)!
                self.keyboardHeight = height
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (not) in
                withAnimation {
                    self.keyboardHeight = 0
                }
            }
        }
    }
    
}
