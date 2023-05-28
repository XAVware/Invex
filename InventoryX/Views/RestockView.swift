//
//  RestockView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 5/1/23.
//

import SwiftUI
import RealmSwift

enum DetailViewType {
    case newItem, restockItem
}

struct RestockView: View {
    @State var activeSheet: DetailViewType      = .newItem
    @State var isShowingDetailView: Bool        = false
    @State var selectedItemName: String         = ""
    @State var selectedConcessionType: String = ""
    
    @ObservedResults(CategoryEntity.self) var categories
    @ObservedResults(InventoryItemEntity.self) var items
    
    @State var isShowingDetail: Bool = true
    @State var selectedItem: InventoryItemEntity?
    
    
    func itemTapped(itemId: ObjectId) {
        let itemResult = items.where {
            $0._id == itemId
        }
        
        guard let selectedItem = itemResult.first else { return }
        
        self.selectedItem = selectedItem
        
        withAnimation(.easeOut(duration: 0.3)) {
            isShowingDetail = true
        }
        
        //        selectedItemName       = category.items.sorted(byKeyPath: "name", ascending: true)[index].name
        //        selectedItemSubtype    = item.subtype
        //        activeSheet            = .restockItem
        //        isShowingDetailView    = true
    }
    
    func addItemTapped() {
        self.activeSheet = .newItem
        self.isShowingDetailView = true
    }
    
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                listView
                    .padding()
                    .background(secondaryBackground)
                    .cornerRadius(20, corners: [.topLeft])
                
                    .fullScreenCover(isPresented: $isShowingDetailView, onDismiss: {
                        selectedItemName = ""
                    }) {
                        Text("Detail")
                        //                        ItemDetailView(viewType: activeSheet, itemName: selectedItemName)
                    }
                    .onChange(of: activeSheet) { (sheet) in
                        isShowingDetailView = true
                    }
                    .edgesIgnoringSafeArea(.bottom)
                
                if isShowingDetail {
                    //                    if let selectedItem = selectedItem {
                    if let selectedItem = items.first {
                        Divider().background(darkFgColor)
                        RestockItemDetailView(selectedItem: selectedItem, isShowing: $isShowingDetail)
                            .frame(width: geo.size.width / 3)
                    }
                }
            } //: HStack
        }
    } //: Body
    
    private var listView: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Select an item below to restock.")
                    .modifier(TextMod(.footnote, .semibold, darkFgColor))
                
                Spacer()
                
                AddItemButton()
            } //: HStack
            .foregroundColor(primaryBackground)
            
            Divider()
                .padding(.vertical, 14)
            
            ForEach(categories.sorted(byKeyPath: "name", ascending: true)) { category in
                VStack {
                    Text(category.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .modifier(TextMod(.title2, .semibold, darkFgColor))
                        .padding(.bottom, 8)
                    
                    VStack(spacing: 0) {
                        HStack {
                            Text("Item Name:")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("Qty. On-Hand:")
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            Text("Retail Price:")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 34)
                        } //: HStack
                        .modifier(TextMod(.body, .bold, .black))
                        .padding(.horizontal)
                        
                        Divider()
                        
                        ForEach(category.items.sorted(byKeyPath: "name", ascending: true).indices, id: \.self) { index in
                            HStack {
                                Text(category.items.sorted(byKeyPath: "name", ascending: true)[index].name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(category.items.sorted(byKeyPath: "name", ascending: true)[index].onHandQty.description)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                Text(String(format: "$ %.02f", category.items.sorted(byKeyPath: "name", ascending: true)[index].retailPrice))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.trailing)
                                
                                Image(systemName: "chevron.right")
                            } //: HStack
                            .frame(height: 30)
                            .padding(.horizontal)
                            .background(index % 2 == 0 ? lightFgColor : secondaryBackground)
                            .modifier(TextMod(.body, .regular, .black))
                            .onTapGesture {
                                itemTapped(itemId: category.items.sorted(byKeyPath: "name", ascending: true)[index]._id)
                            }
                        }
                    } //: VStack
                    .padding(.horizontal)
                } //: VStack
                .padding()
                .background(lightFgColor)
                .cornerRadius(20, corners: [.allCorners])
                
                Spacer().frame(height: 16)
            } //: ForEach
            
            Spacer()
        } //: VStack
    } //: List View
}

struct RestockView_Previews: PreviewProvider {
    static var previews: some View {
        RestockView()
            .modifier(PreviewMod())
    }
}

struct RestockItemDetailView: View {
    @ObservedRealmObject var selectedItem: InventoryItemEntity
    @Binding var isShowing: Bool
    
    @State var restockQuantity: Int = 10
    
    func saveTapped() {
        
        isShowing.toggle()
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Restock Item")
                .modifier(TextMod(.title, .bold))
            
            HStack {
                Text("Item:")
                    .modifier(TextMod(.title3, .semibold))
                
                Text(selectedItem.name)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            Divider()
            
            HStack {
                Text("On-Hand:")
                    .modifier(TextMod(.title3, .semibold))
                
                Text("\(selectedItem.onHandQty)")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            Divider()
            
            Spacer()
            
            Button {
                saveTapped()
            } label: {
                Text("Save")
            }
            .modifier(RoundedButtonMod())
            
        } //: VStack
        .padding()
        .background(lightFgColor)
    }
}
