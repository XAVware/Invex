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
    
    @State var typeID: Int = 0
    var types = ["Food / Snack", "Beverage", "Frozen"]
    
    var body: some View {
        GeometryReader { geometry in
        HStack(spacing: 0) {
            
            //MARK: - Make A Sale Item Button Dashboard
            VStack(alignment: .center, spacing: 5) {
                
                
                Picker(selection: $typeID, label: Text("")) {
                    ForEach(0 ..< types.count) { index in
                        Text(self.types[index]).foregroundColor(.black).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(maxWidth: 400)
                .padding(.top)
                .padding(.bottom, 10)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 10) {
                        ForEach(self.getItemsOfType(self.types[typeID]), id: \.self) { item in
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
    
    init(cart: Cart) {
        self.cart = cart
        
//        let distinctTypes = try! Array(Set(Realm().objects(Item.self).value(forKey: "type") as! [String]))
        
    }
    
    
    func getItemsOfType(_ type: String) -> [Item] {
        var tempList: [Item] = []
        let predicate = NSPredicate(format: "type CONTAINS %@", type)
        let results = try! Realm().objects(Item.self).filter(predicate)
        for item in results {
            tempList.append(item)
        }
        return tempList
    }
    
    
}
