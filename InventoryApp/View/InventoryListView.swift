//
//  InventoryListView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/9/20.
//

import SwiftUI

struct InventoryListView: View {
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Image(systemName: "newspaper")
                    .resizable()
                    .scaledToFit()
                    .font(.system(size: 36, weight: .semibold))
                    .frame(width: 40, height: 40)
                
                Text("Current Inventory")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                
                Spacer()
            } //: HStack - Title
            .padding()
            
            Spacer()
        }
    }
}

struct InventoryListView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryListView()
            .previewLayout(.fixed(width: 1024, height: 786))
    }
}
