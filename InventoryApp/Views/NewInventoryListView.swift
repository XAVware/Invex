//
//  NewInventoryListView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/24/20.
//

import SwiftUI
import RealmSwift

struct NewInventoryListView: View {
    let inventoryList: Results<Item> = try! Realm().objects(Item.self)
    let itemTypes: [String] = ["Food / Snack" , "Beverage", "Frozen"]
    
    @State var selectedItemType: String = "Food / Snack"
    @State var selectedItemName: String = ""
    
    @State var selectedItem: Item = Item()
    
    @State var quantityPurchased: Int       = 24
    @State var isCustomQuantity: Bool       = false
    @State var isIncludingCost: Bool        = false
    @State var isShowingNewItemView: Bool   = false
    @State var isShowingCostView: Bool      = false
    @State var isShowingItemDetail: Bool    = false
    
    @State var quantityOptions: [Int] = [12, 18, 24, 30, 36]
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 5) {
                
                Text("Inventory List")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(hex: "365cc4"))
                
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
                    .background(Color.white)
                    .frame(width: UIScreen.main.bounds.width * 0.30)
                    
                    LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.07), Color.black.opacity(0)]), startPoint: .leading, endPoint: .trailing)
                        .frame(maxWidth: 5, maxHeight: .infinity)
                    
                    Spacer().frame(width: 10)
                    
                    List {
                        ForEach(self.getItemsOfType(self.$selectedItemType.wrappedValue), id: \.self) { item in
                            
                            Button(action: {
                                guard self.selectedItemName != item.name else {
                                    withAnimation {
                                        self.selectedItemName = ""
                                        self.selectedItem = Item()
                                        self.isShowingItemDetail = false
                                    }
                                    return
                                }
                                withAnimation {
                                    self.selectedItemName = item.name
                                    self.selectedItem = item
                                    self.isShowingItemDetail = true
                                    
                                }
                            }) {
                                HStack(spacing: 25) {

                                    Text(item.name)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.system(size: 18, weight: self.selectedItemName == item.name ? .semibold : .light, design: .rounded))
                                    
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 10, height: 15)
                                        .font(.system(size: 18, weight: self.selectedItemType == item.name ? .semibold : .light, design: .rounded))

                                }
                            }
                            .frame(height: 50)
                            .padding(.horizontal)
                            .background(
                                self.selectedItemName == item.name ? Color.gray.opacity(0.3) : Color.white
                            )


                        } //: ForEach
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    } //: List - Item Name
                    .frame(width: UIScreen.main.bounds.width * 0.70)
                    
                    
                    
                } //: HStack - Lists
                .background(Color.white)
                .border(Color.black.opacity(0.07), width: 1)
                
            } //: VStack -- Main Stack
            
            
        
            HStack(spacing: 0) {
                Color.black.opacity(self.isShowingItemDetail ? 0.30 : 0)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            self.selectedItemName = ""
                            self.selectedItem = Item()
                            self.isShowingItemDetail = false
                        }
                    }
                
                ItemDetailView(item: self.$selectedItem)
                    .offset(x: self.isShowingItemDetail ? 0 : 500, y: 0)
            }
            
        } //:ZStack
    } //: Body
    
    func getItemsOfType(_ type: String) -> Results<Item> {
        return try! Realm().objects(Item.self).filter(NSPredicate(format: "type CONTAINS %@", type))
    }
    
    
}
