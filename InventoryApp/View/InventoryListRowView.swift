//
//  InventoryListRowView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/9/20.
//

import SwiftUI

struct InventoryListRowView: View {
    @State var item: Item
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(item.name)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.black)
                .frame(width: 160, alignment: .leading)
            
            Text(item.type)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.black)
                .frame(width: 160)
            
            Text("\(item.onHandQty)")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.black)
                .frame(width: 160)
            
            Text("$ \(item.retailPrice)")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.black)
                .frame(width: 160)
            
            Text("$ \(String(format: "%.2f", item.avgCostPer))")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.black)
                .frame(width: 160, alignment: .trailing)
        }
        .background(
            Color.white
        )
        .frame(maxWidth: 800, maxHeight: 40)
    }
}

struct InventoryListRowView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryListRowView(item: Item())
            .previewLayout(.sizeThatFits)
    }
}
