//
//  InventoryListView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/9/20.
//

import SwiftUI

struct InventoryListView: View {
    @ObservedObject var appManager: AppStateManager
    
    var listWidth: CGFloat = 800
    var columnTitles: [String] = ["Item Name:", "Type:", "On-Hand Qty:", "Price:", "Cost / Unit:"]
    
    var body: some View {
        VStack {
            HeaderLabel(title: "Current Inventory")
            
            Spacer()
            
            VStack(alignment: .center, spacing: 0) {
                
                ListTitles(columnTitles: self.columnTitles, listWidth: self.listWidth)
                
                Divider().padding(.bottom, 10)
                
                List {
                    ForEach(self.appManager.itemList, id: \.self) { item in
                        InventoryListRowView(item: item) 
                    }
                    .onDelete(perform: { indexSet in
                        self.appManager.deleteItem(atOffsets: indexSet)
                    })
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .background(Color.white)
                    
                } //: List
                
                Spacer()
            } //: VStack
            .frame(maxWidth: self.listWidth)
        } //: VStack
        .background(Color.white)
    }
    
}
