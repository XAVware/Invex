//
//  ItemSelectorView.swift
//  InventoryV2
//
//  Created by Ryan Smetana on 12/27/20.
//

import SwiftUI
import RealmSwift

struct ItemSelectorView: View {
    
    let concessionTypes: [String] = ["Food / Snack" , "Beverage", "Frozen"]
    
    @Binding var selectedItemType: String
    @Binding var selectedItemName: String
  
    var body: some View {
        HStack(spacing: 0) {
            List {
                ForEach(self.concessionTypes, id: \.self) { typeString in
                    ZStack {
                        Color.gray
                            .opacity(self.selectedItemType == typeString ? 0.4 : 0)
                            .frame(maxWidth: .infinity)
                        Button(action: {
                            self.selectedItemType = typeString
                        }) {


                            HStack {
                                Text(typeString)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.system(size: 18, weight: self.selectedItemType == typeString ? .semibold : .light, design: .rounded))
                                    .foregroundColor(Color.black)


                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 10, height: 15)
                                    .font(.system(size: 18, weight: self.selectedItemType == typeString ? .semibold : .light, design: .rounded))
                                    .foregroundColor(Color.black)
                            }


                        }
                        .frame(height: 50)
                        .padding(.horizontal)

                    }

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
                        if item.subtype != "" {
                            self.selectedItemName.append(" - \(item.subtype)")
                        }
                    }) {
                        HStack(spacing: 25) {
                            Image(systemName: self.selectedItemName == item.name ? "checkmark.circle.fill" : "circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .font(.system(size: 18, weight: .light, design: .rounded))
                                .foregroundColor(Color(hex: "365cc4"))

                            Text(item.subtype == "" ? item.name : "\(item.name) - \(item.subtype)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 18, weight: self.selectedItemName == item.name ? .semibold : .light, design: .rounded))
                                .foregroundColor(Color.black)

                        }
                    }
                    .frame(height: 50)
                    .padding(.horizontal)

                } //: ForEach
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            } //: List - Item Name
            
        } //: HStack - Lists
        .background(Color.white)
        .border(Color.black.opacity(0.07), width: 1)
    }
    
    func getItemsOfType(_ type: String) -> Results<Item> {
        return try! Realm().objects(Item.self).filter(NSPredicate(format: "type CONTAINS %@", type))
    }
}
