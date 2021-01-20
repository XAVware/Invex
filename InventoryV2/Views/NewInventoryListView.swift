//
//  NewInventoryListView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/24/20.
//

import SwiftUI
import RealmSwift

struct NewInventoryListView: View {
    let itemTypes: [String]                     = ["Food / Snack" , "Beverage", "Frozen"]
    
    @State var selectedItemType: String         = "Food / Snack"
    @State var selectedItemName: String         = ""
    @State var selectedItem: Item               = Item()
    @State var isShowingItemDetail: Bool        = false
        
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 5) {
                
                Text("Inventory List")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(hex: "365cc4"))
                
                Spacer(minLength: 30)
                
                HStack(spacing: 0) {
                    
                    Text("Item Type:")
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.30, alignment: .leading)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(Color.black)
                    
                    HStack {
                        Spacer(minLength: 15)
                        
                        Text("Item:")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 12, design: .rounded))
                            .foregroundColor(Color.black)
                        
                        Text("On-Hand Qty:")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.system(size: 12, design: .rounded))
                            .foregroundColor(Color.black)
                        
                        Text("Retail Price:")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.system(size: 12, design: .rounded))
                            .foregroundColor(Color.black)
                        
                        Spacer(minLength: 20)
                        
                    }
                    .frame(maxWidth: .infinity)
                    
                    

                }
                .padding(.horizontal)

                
                //MARK: - Item Selector
                HStack(spacing: 0) {
                    List {
                        ForEach(self.itemTypes, id: \.self) { typeString in
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
                                self.selectedItem = item
                                withAnimation {
                                    self.isShowingItemDetail = true
                                }
                            }) {
                                HStack(spacing: 16) {
                                    
                                    Text(item.subtype == "" ? item.name : "\(item.name) - \(item.subtype)")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.system(size: 18, weight: self.selectedItemName == item.name ? .semibold : .light, design: .rounded))
                                        .foregroundColor(Color.black)
                                    
                                    Text("\(item.onHandQty)")
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .font(.system(size: 18, weight: self.selectedItemName == item.name ? .semibold : .light, design: .rounded))
                                        .foregroundColor(Color.black)
                                    
                                    Text("$\(item.retailPrice)")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .font(.system(size: 18, weight: self.selectedItemName == item.name ? .semibold : .light, design: .rounded))
                                        .foregroundColor(Color.black)
                                    
                                    
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 10, height: 15)
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
                    .padding(.trailing)
                    
                } //: HStack - Lists
                .background(Color.white)
                .border(Color.black.opacity(0.07), width: 1)
                
            } //: VStack -- Main Stack
            .background(Color.white)
            
            HStack(spacing: 0) {
                Color.black.opacity(self.isShowingItemDetail ? 0.28 : 0)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {withAnimation { self.isShowingItemDetail = false }}
                
                ItemDetailView(item: self.$selectedItem) {
                    self.isShowingItemDetail = false
                }
                    .frame(width: 400)
                    .offset(x: self.isShowingItemDetail ? 0 : 400, y: 0)
            }
        }
            
    } //: Body
    
    func getItemsOfType(_ type: String) -> Results<Item> {
        return try! Realm().objects(Item.self).filter(NSPredicate(format: "type CONTAINS %@", type))
    }
    
    
}
