//
//  NewItemView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/24/20.
//

import SwiftUI
import RealmSwift

enum ActiveSheet {
    case newItem, restockItem
}

struct NewItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var activeSheet: ActiveSheet
    @State var itemName: String             = ""
    @State var newItemName: String          = ""
    @State var hasSubtype: Bool             = false
    @State var itemSubtype: String          = ""
    @State var newItemType: String          = "-Select Type-"
    @State var newItemPrice: Double         = 1.00
    @State var quantityPurchased: Int       = 24
    
    @State var typeExpanded: Bool           = false
    @State var priceExpanded: Bool          = false
    @State var quantityExpanded: Bool       = false
    
    @State var errorMessage: String         = ""
    @State var savedSuccessfully: Bool      = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer(minLength: 40)
                
                Text(self.activeSheet == .newItem ? "New Item" : "Restock Item")
                    .modifier(TitleModifier())
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 20, alignment: .center)
                }
            } //: HStack - Header
            .modifier(HeaderModifier())
            
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    VStack {
                        TextField("Item Name:", text: $newItemName)
                            .modifier(TextFieldModifier())
                        
                        if self.hasSubtype {
                            TextField("Subtype:", text: $itemSubtype)
                                .modifier(TextFieldModifier())
                                .frame(maxWidth: 450)
                        }
                        
                        Button(action: {
                            if self.hasSubtype {
                                self.itemSubtype = ""
                            }
                            withAnimation { self.hasSubtype.toggle() }
                        }) {
                            Text(self.hasSubtype ? "- Remove Subtype" : "+ Add Subtype")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(Color("ThemeColor"))
                                .opacity(0.8)
                        }
                        
                    }
                    .padding(.vertical)
                    
                    GroupBox {
                            DisclosureGroup(isExpanded: self.$typeExpanded) {
                                Divider().padding(.top)
                                VStack {
                                    ForEach(concessionTypes) { concessionType in
                                        Button(action: {
                                            self.newItemType = concessionType.type
                                        }) {
                                            HStack {
                                                Text(concessionType.type)
                                                    .font(.system(size: 18, design: .rounded))
                                                    .foregroundColor(.black)
                                                
                                                Spacer()
                                                
                                                Image(systemName: self.newItemType == concessionType.type ? "checkmark.circle.fill" : "circle")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 20, height: 20)
                                                    .imageScale(.small)
                                                    .accentColor(Color("ThemeColor"))
                                                
                                            } //: HStack
                                        }
                                        if concessionType.type != concessionTypes[concessionTypes.count - 1].type {
                                            Divider()
                                        }
                                        
                                    } //: ForEach
                                } // VStack
                                
                            } label: {
                                HStack {
                                    Text("Item Type:")
                                        .frame(maxWidth:.infinity, alignment: .leading)
                                        .font(.callout)
                                        .foregroundColor(.black)
                                    
                                    Text("\(self.$newItemType.wrappedValue)")
                                        .frame(maxWidth:.infinity, alignment: .center)
                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    
                                    Text(self.typeExpanded ? "Confirm" : "Change")
                                        .frame(maxWidth:.infinity, alignment: .trailing)
                                        .font(.footnote)
                                        .foregroundColor(.black)
                                } //: HStack
                                
                            } //: DisclosureGroup
                    } //: GroupBox - Item Type
                    .onTapGesture { withAnimation { self.typeExpanded.toggle() } }
                    
                    GroupBox {
                        DisclosureGroup(isExpanded: self.$priceExpanded) {
                            Divider().padding(.vertical)
                            Slider(value: $newItemPrice, in: 0.00 ... 5.00, step: 0.25)
                                .frame(width: 400)
                                .padding(.bottom)
                        } label: {
                            HStack {
                                Text("Retail Price:")
                                    .frame(maxWidth:.infinity, alignment: .leading)
                                    .font(.callout)
                                
                                Text("$\(String(format: "%.2f", self.newItemPrice))")
                                    .frame(maxWidth:.infinity, alignment: .center)
                                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                                
                                Text(self.priceExpanded ? "Confirm" : "Change")
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .font(.footnote)
                            } //: HStack
                        } //: DisclosureGroup
                        .foregroundColor(.black)
                        .onTapGesture { withAnimation { self.priceExpanded.toggle() } }
                        
                    } //GroupBox - Price
                    
                    GroupBox {
                        DisclosureGroup(isExpanded: self.$quantityExpanded) {
                            VStack {
                                Divider().padding(.vertical)
                                QuantitySelector(selectedQuantity: self.$quantityPurchased, showsCustomToggle: true)
                            }
                        } label: {
                            HStack {
                                Text("Quantity Purchased:")
                                    .frame(maxWidth:.infinity, alignment: .leading)
                                    .font(.callout)
                                
                                Text("\(self.quantityPurchased)")
                                    .frame(maxWidth:.infinity, alignment: .center)
                                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                                
                                Text(self.quantityExpanded ? "Confirm" : "Change")
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .font(.footnote)
                            } //: HStack
                            .onTapGesture { withAnimation { self.quantityExpanded.toggle() } }
                        } //: DisclosureGroup
                        .foregroundColor(.black)
                    } //: GroupBox
                    
                    Text(self.$errorMessage.wrappedValue)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.red)
                    
                    SaveItemButton(action: {
                        self.typeExpanded = false
                        self.priceExpanded = false
                        self.quantityExpanded = false
                        
                        self.errorMessage = ""
                        self.newItemName = self.newItemName.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !self.newItemName.isEmpty else {
                            self.errorMessage = "Please Enter a Valid Item Name"
                            return
                        }
                        
                        guard self.newItemType != "-Select Type-" else {
                            self.errorMessage = "Please Select an Item Type"
                            self.priceExpanded = false
                            self.quantityExpanded = false
                            withAnimation { self.typeExpanded = true }
                            return
                        }
                        
                        guard self.quantityPurchased >= 0 else {
                            self.errorMessage = "Please enter a valid quantity"
                            self.priceExpanded = false
                            self.typeExpanded = false
                            withAnimation { self.quantityExpanded = true }
                            return
                        }
                        
                        let newItem = Item()
                        newItem.name        = self.newItemName
                        newItem.subtype     = self.itemSubtype
                        newItem.itemType    = self.newItemType
                        newItem.retailPrice = self.newItemPrice
                        newItem.onHandQty   = self.quantityPurchased
                        
                        
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
                            return
                        }
                        
                        self.savedSuccessfully = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        
                    }) //: Save Button
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                }
                .frame(maxWidth: 600, maxHeight: .infinity)
            }
            .edgesIgnoringSafeArea(.all)
        } //: VStack - Main Stack
        .overlay(
            ZStack {
                if self.savedSuccessfully {
                    Color.white.frame(maxWidth: .infinity, maxHeight: .infinity)
                    AnimatedCheckmarkView()
                }
            }
            
        )
        .onChange(of: self.typeExpanded, perform: { typeIsExpanded in
            if typeIsExpanded {
                self.priceExpanded = false
                self.quantityExpanded = false
            }
        })
        .onChange(of: self.priceExpanded, perform: { priceIsExpanded in
            if priceIsExpanded {
                self.typeExpanded = false
                self.quantityExpanded = false
            }
        })
        .onChange(of: self.quantityExpanded, perform: { quantityIsExpanded in
            if quantityIsExpanded {
                self.typeExpanded = false
                self.priceExpanded = false
            }
        })
        .onAppear {
            print(self.itemName)
        }
    }
    
}
