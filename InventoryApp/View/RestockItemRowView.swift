//
//  RestockItemRowView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/13/20.
//

import SwiftUI

struct RestockItemRowView: View {
    @State var item: Item
    
    var body: some View {
        HStack(spacing: 0) {
            Text(item.name)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.black)
                .frame(width: 200, alignment: .leading)
            
            HStack {
                Text("On-hand qty: ")
                    .font(.system(size: 14, weight: .light, design: .rounded))
                    .foregroundColor(.black)
                
                Text("\(item.onHandQty)")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.black)
            }
            .frame(width: 200)
            
            HStack {
                Text("Add More")
                    .font(.system(size: 18, weight: .light, design: .rounded))
                    .foregroundColor(.black)
                
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .accentColor(.black)
                    .font(.system(size: 18, weight: .light, design: .rounded))
                    .frame(width: 20, height: 20)
            }
            .frame(width: 200, alignment: .trailing)
            
        }
        .frame(width: 600, height: 50)
        .padding(.horizontal)
    }
}

struct RestockItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        RestockItemRowView(item: Item())
            .previewLayout(.sizeThatFits)
    }
}
