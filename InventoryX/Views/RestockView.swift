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
    @State var selectedItemSubtype: String      = ""
    @State var isShowingDetailView: Bool        = false
    @State var selectedItemName: String         = ""
    @State var selectedConcessionType: String = ""
    
    @ObservedResults(CategoryEntity.self) var categories
    @ObservedResults(InventoryItemEntity.self) var items
    
    @State var isShowingDetail: Bool = false
    @State var selectedItem: InventoryItemEntity?
    
    func itemTapped(itemId: ObjectId) {
        let itemResult = items.where {
            $0._id == itemId
        }
        
        guard let selectedItem = itemResult.first else {
            print("Item not found")
            return
        }
        
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
                    .background(Color(XSS.S.color80))
                    .cornerRadius(20, corners: [.topLeft])
                    .fullScreenCover(isPresented: self.$isShowingDetailView, onDismiss: {
                        self.selectedItemName = ""
                        self.selectedItemSubtype = ""
                    }) {
                        ItemDetailView(viewType: self.activeSheet, itemName: self.selectedItemName, itemSubtype: self.selectedItemSubtype)
                    }
                    .onChange(of: self.activeSheet) { (sheet) in
                        self.isShowingDetailView = true
                    }
                    .edgesIgnoringSafeArea(.bottom)
                
                if isShowingDetail {
                    Divider().background(darkTextColor)
                    VStack {
                        Text(selectedItem?.name ?? "Err")
                            .frame(maxWidth: .infinity)
                        Spacer()
                    } //: VStack
                    .background(lightTextColor)
                    .frame(width: geo.size.width / 3)
                    
                }
            } //: HStack

        }
    } //: Body
    
    private var listView: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Restock")
                        .modifier(TextMod(.title, .bold, darkTextColor))
                    
                    Text("Select an item below to restock.")
                        .modifier(TextMod(.footnote, .semibold, darkTextColor))
                } //: VStack
                
                Spacer()
                
                Button {
                    addItemTapped()
                } label: {
                    Text("New Item")
                        .modifier(TextMod(.footnote, .semibold, darkTextColor))
                    
                    Image(systemName: "plus")
                        .scaledToFit()
                        .foregroundColor(darkTextColor)
                        .bold()
                    
                }
                .padding(8)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(darkTextColor, lineWidth: 3))
            } //: HStack
            .foregroundColor(Color(XSS.S.color20))
            
            Divider()
                .padding(.vertical, 14)
            
            ForEach(categories.sorted(byKeyPath: "name", ascending: true)) { category in
                VStack {
                    Text(category.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .modifier(TextMod(.title2, .semibold, darkTextColor))
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
                            .background(index % 2 == 0 ? Color(XSS.S.color90) : Color(XSS.S.color80))
                            .modifier(TextMod(.body, .regular, .black))
                            .onTapGesture {
                                itemTapped(itemId: category.items.sorted(byKeyPath: "name", ascending: true)[index]._id)
                            }
                        }
                    } //: VStack
                    .padding(.horizontal)
                } //: VStack
                .padding()
                .background(Color(XSS.S.color90))
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
    }
}
