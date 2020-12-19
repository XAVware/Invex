//
//  RestockItemView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/13/20.
//

import SwiftUI

struct RestockItemView: View {
    @ObservedObject var appManager: AppStateManager
    
    @State var foodSnackIsExpanded: Bool = false
    @State var beverageIsExpanded: Bool = false
    @State var frozenIsExpanded: Bool = false
    
    @State var isShowingPurchaseItem: Bool = false
    @State var selectedItem: Item?
    
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 10) {
                DisclosureGroup("Food / Snack", isExpanded: $foodSnackIsExpanded) {
                    ForEach(self.appManager.beverageList, id: \.self) { item in
                        RestockItemRowView(item: item)
                            .onTapGesture {
                                self.selectedItem = item
                                self.isShowingPurchaseItem = true
                            }
                    }
                }
                .padding(.horizontal)
                .accentColor(.black)
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(.black)
                .background(Color.gray)
                .cornerRadius(8)
                
                
                DisclosureGroup("Beverages", isExpanded: $beverageIsExpanded) {
                    
                }
                
                DisclosureGroup("Frozen", isExpanded: $frozenIsExpanded) {
                    
                }
            }
            .frame(width: 600)
            .padding()
            
        }
    }
}

struct RestockItemView_Previews: PreviewProvider {
    static var previews: some View {
        RestockItemView(appManager: AppStateManager())
            .previewLayout(.fixed(width: 1024, height: 786))
    }
}
