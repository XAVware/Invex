//
//  MakeASaleView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/11/20.
//

import SwiftUI
import RealmSwift

struct MakeASaleView: View {
    @ObservedObject var cart: Cart
    
    @State var selectedTypeID: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                
                //MARK: - Make A Sale Item Button Dashboard
                VStack(alignment: .center, spacing: 5) {
                    
                    TypePickerView(typeID: self.$selectedTypeID)
                    
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 10) {
                            ForEach(self.getItemsOfType(concessionTypes[selectedTypeID].type), id: \.self) { item in
                                ItemButton(cart: self.cart, item: item)
                                    .shadow(radius: 8)
                            }
                        }
                        .padding(.horizontal, 10)
                    } //: ScrollView
                    
                } //: VStack
                .padding(.vertical)
                .frame(width: geometry.size.width - (geometry.size.width * 0.40))
                
                Spacer().frame(width: geometry.size.width * 0.40)
                
            } //: HStack
            .background(Color.white)
        }
        
        
    } //: VStack used to keep header above all pages
    
    
    
    func getItemsOfType(_ type: String) -> [Item] {
        var tempList: [Item] = []
        let predicate = NSPredicate(format: "itemType CONTAINS %@", type)
        let results = try! Realm().objects(Item.self).filter(predicate)
        for item in results {
            tempList.append(item)
        }
        return tempList
    }
    
    
}
