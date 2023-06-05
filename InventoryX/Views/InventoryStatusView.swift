//
//  InventoryStatusView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 6/4/23.
//

import SwiftUI
import RealmSwift

struct InventoryStatusView: View {
    @ObservedResults(CategoryEntity.self) var categories
    @ObservedResults(InventoryItemEntity.self) var items
    
    func getRestockStatus(for item: InventoryItemEntity) -> Bool {
        guard let category = item.category.first?.thaw() else { return true }
        let restockNum = category.restockNumber
        return item.onHandQty > restockNum ? false : true
    }
    
    var body: some View {
        VStack {
            List(items) { item in
                if getRestockStatus(for: item) {
                    Text(item.name)
                }
            } //: List
        } //: VStack
    }

}

struct InventoryStatusView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryStatusView()
            .modifier(PreviewMod())
    }
}
