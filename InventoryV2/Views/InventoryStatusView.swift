//
//  InventoryStatusView.swift
//  InventoryV2
//
//  Created by Ryan Smetana on 1/19/21.
//

import SwiftUI
import RealmSwift

struct InventoryStatusView: View {
    @State var typeID: Int = 0
    var types = ["Food / Snack", "Beverage", "Frozen"]
    
    var restockNumber: Int {
        switch typeID {
        case 0:
            return 10
        case 1:
            return 15
        case 2:
            return 10
        default:
            return 100
        }
    }
    
    var items: Results<Item> {
        let query = NSCompoundPredicate(type: .and, subpredicates: [NSPredicate(format: "type == %@", types[typeID]), NSPredicate(format: "onHandQty <= \(restockNumber)")])
        return try! Realm().objects(Item.self).filter(query)
    }
    
    var body: some View {
        VStack {
            Text("Inventory Status")
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.system(size: 32, weight: .semibold, design: .rounded))
                .foregroundColor(Color(hex: "365cc4"))
                .padding()
            
            Picker(selection: $typeID, label: Text("")) {
                ForEach(0 ..< types.count) { index in
                    Text(self.types[index]).foregroundColor(.black).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.vertical)
            .frame(maxWidth: 400)
            
            Text("Showing items of \(self.restockNumber) or less")
                .font(.title3)
            
            
            
            VStack {
                HStack {
                    Text("Item:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.footnote)
                    
                    Text("On-Hand Qty:")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .font(.footnote)
                } //: HStack - Titles
                .padding(.horizontal)
                
                List(self.items, id: \.self) { item in
                    HStack {
                        Text(item.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title2)
                        
                        Text("\(item.onHandQty)")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.title2)
                    }
                    .padding(.vertical, 5)
                    
                    
                } //: List
                .frame(maxHeight: .infinity)
                
            } //: VStack
            .frame(maxWidth: 600)
            .padding()
            
        }
        
        
    }
}
