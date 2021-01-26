//
//  NewInventoryListView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/24/20.
//

import SwiftUI
import RealmSwift

struct InventoryListView: View {
    @State var selectedConcessionType: String       = concessionTypes[0].type
    @State var isShowingDetailView: Bool            = false
    
    @State var selectedItem: Item = Item()
    
    var results: Results<Item> {
        let predicate = NSPredicate(format: "itemType == %@", selectedConcessionType)
        return try! Realm().objects(Item.self).filter(predicate)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Text("Inventory List")
                    .modifier(TitleModifier())
                    .padding()
                
                Text("Tap an item to edit it.")
                    .font(.footnote)
                    .padding(.bottom)
                
                HStack(spacing: 0) {
                    Text("Item Type:")
                        .frame(width: geometry.size.width * 0.30, alignment: .leading)
                    
                    Text("Item:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("On-Hand Qty:")
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text("Retail Price:")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Spacer().frame(width: 16)
                }
                .padding(.horizontal)
                .padding(.bottom, 5)
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(Color.black)
                
                Divider()
                
                HStack(spacing: 0) {
                    TypeSelectorView(selectedType: self.$selectedConcessionType)
                        .frame(width: geometry.size.width * 0.30)
                    
                    Divider()
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            ForEach(self.results, id: \.self) { item in
                                Button(action: {
                                    self.selectedItem = item
                                    self.isShowingDetailView = true
                                }) {
                                    HStack {
                                        Text("\(item.name) \(item.subtype == "" ? "" : "- \(item.subtype)")")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.system(size: 18, weight: .light, design: .rounded))
                                        
                                        Text("\(item.onHandQty)")
                                            .frame(maxWidth: .infinity, alignment: .center)
                                            .font(.system(size: 18, weight:.light, design: .rounded))
                                        
                                        Text("$\(String(format: "%.2f", item.retailPrice))")
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                            .font(.system(size: 18, weight:.light, design: .rounded))
                                        
                                        Image(systemName: "chevron.right")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 10, height: 15)
                                            .font(.system(size: 18, weight: .light, design: .rounded))
                                    } //: HStack
                                    .foregroundColor(.black)
                                    
                                } //: Button - Item
                                .padding(.horizontal)
                                .frame(height: 40)
                                
                                Divider()
                            } //: ForEach
                        } //: VStack
                    } //: ScrollView
                    .frame(width: geometry.size.width * 0.70)
                    
                } //: HStack - Item Selector
            }
        }
        .fullScreenCover(isPresented: self.$isShowingDetailView, onDismiss: {
            self.selectedItem = Item()
        }) {
            EditItemView(selectedItem: self.$selectedItem)
        }
        
    } //: Body
    
    
}

