//
//  InventoryListView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/9/20.
//

import SwiftUI

struct InventoryListView: View {
    @ObservedObject var appManager: AppStateManager
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Image(systemName: "newspaper")
                    .resizable()
                    .scaledToFit()
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 40, height: 40)
                
                Text("Current Inventory")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                
                Spacer()
                
            } //: HStack - Title
            .padding()
            
            Spacer()
            
            VStack(alignment: .center, spacing: 0) {
                
                HStack(alignment: .center, spacing: 0) {
                    
                    Text("Item Name:")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .opacity(0.7)
                        .frame(width: 160, alignment: .leading)
                    
                    Text("Type:")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .opacity(0.7)
                        .frame(width: 160)
                    
                    Text("On-Hand Qty:")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .opacity(0.7)
                        .frame(width: 160)
                    
                    Text("Price:")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .opacity(0.7)
                        .frame(width: 160)
                    
                    Text("Cost / Unit:")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .opacity(0.7)
                        .frame(width: 160, alignment: .trailing)
                    
                } //: HStack
                .padding(.horizontal)
                .frame(height: 40)
                
                Divider()
                
                
                List {
                    ForEach(self.appManager.itemList, id: \.self) { item in
                        InventoryListRowView(item: item)
                            
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                } //: List
                    
                
                
                Spacer()
            } //: VStack
            .frame(maxWidth: 800)
            
        } //: VStack
        .padding()
        .background(Color.white)
    }
    
    init(appManager: AppStateManager) {
        self.appManager = appManager
        
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
}

struct InventoryListView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryListView(appManager: AppStateManager())
            .previewLayout(.fixed(width: 1024, height: 786))
    }
}
