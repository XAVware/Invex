//
//  InventoryListRowView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/9/20.
//

import SwiftUI

struct InventoryListRowView: View {
    var body: some View {
        HStack {
            Text("Pepsi")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .padding(.horizontal)
            
            Text("")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .padding(.horizontal)
            
            Text("Pepsi")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .padding(.horizontal)
        }
        .background(
            Color.white
        )
        .frame(height: 40)
    }
}

struct InventoryListRowView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryListRowView()
            .previewLayout(.sizeThatFits)
    }
}
