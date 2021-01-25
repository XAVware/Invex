//
//  RestockItemView.swift
//  ConcessionTracker
//
//  Created by Ryan Smetana on 1/21/21.
//

import SwiftUI
import RealmSwift

struct RestockItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var item: Item
    
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
                
                Text("Restock Item")
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
                    GroupBox {
                        HStack {
                            Text("Item:")
                                .frame(maxWidth:.infinity, alignment: .leading)
                                .font(.title2)
                                .foregroundColor(.black)
                            
                            Text(item.name)
                                .frame(maxWidth:.infinity, alignment: .center)
                                .font(.title)
                                .foregroundColor(.black)
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Change")
                                    .frame(maxWidth:.infinity, alignment: .trailing)
                                    .font(.footnote)
                                    .foregroundColor(.black)
                            }
                            
                            
                        }
                    }
                    
                    QuantitySelector(selectedQuantity: self.$quantityPurchased, showsCustomToggle: true)
                    
                    SaveItemButton(action: {
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
    }
    
}

