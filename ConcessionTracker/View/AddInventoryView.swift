//
//  NewAddInventoryView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/23/20.
//

import SwiftUI
import RealmSwift

enum DetailViewType {
    case newItem, restockItem
}

struct AddInventoryView: View {
    @State var activeSheet: DetailViewType = .newItem
    @State var selectedConcessionType: String = concessionTypes[0].type
    @State var selectedItemName: String = ""
    @State var selectedItemSubtype: String = ""
    @State var isShowingDetailView: Bool = false
    
    
    var results: Results<Item> {
        let predicate = NSPredicate(format: "itemType == %@", selectedConcessionType)
        return try! Realm().objects(Item.self).filter(predicate)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack {
                    Spacer().frame(width: 40)
                    
                    Text("Add Inventory")
                        .modifier(TitleModifier())
                    
                    Button(action: {
                        self.activeSheet = .newItem
                        self.isShowingDetailView = true
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 20, alignment: .center)
                            .foregroundColor(Color("ThemeColor"))
                        
                    }
                } //: HStack - Header
                .padding()
                
                Text("Select an item below to restock, or tap the '+' to add a new item.")
                    .font(.footnote)
                    .padding(.bottom)
                
                Divider()
                
                HStack(spacing: 0) {
                    TypeSelectorView(selectedType: self.$selectedConcessionType)
                        .frame(width: geometry.size.width * 0.30)
                    
                    Divider()
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            ForEach(self.results, id: \.self) { item in
                                Button(action: {
                                    self.selectedItemName = item.name
                                    self.selectedItemSubtype = item.subtype
                                    self.activeSheet = .restockItem
                                    self.isShowingDetailView = true
                                }) {
                                    HStack {
                                        Text("\(item.name) \(item.subtype == "" ? "" : "- \(item.subtype)")")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.system(size: 18, weight: .light, design: .rounded))
                                        
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
                }
                
            } //: VStack -- Main Stack
            .fullScreenCover(isPresented: self.$isShowingDetailView, onDismiss: {
                self.selectedItemName = ""
                self.selectedItemSubtype = ""
                
            }) {
                ItemDetailView(viewType: self.activeSheet, itemName: self.selectedItemName, itemSubtype: self.selectedItemSubtype)
            }
            .onChange(of: self.activeSheet) { (sheet) in
                self.isShowingDetailView = true
            }
            
        }
        
        
        
    } //: Body

}
