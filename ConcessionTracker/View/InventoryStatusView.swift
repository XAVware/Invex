

import SwiftUI
import RealmSwift

struct InventoryStatusView: View {
    @State var typeID: Int = 0

    var items: Results<Item> {
        let query = NSCompoundPredicate(type: .and, subpredicates: [NSPredicate(format: "itemType == %@", concessionTypes[typeID].type), NSPredicate(format: "onHandQty <= \(concessionTypes[typeID].restockNumber)")])
        return try! Realm().objects(Item.self).filter(query).sorted(byKeyPath: "name", ascending: true)
    }
    
    var body: some View {
        VStack {
            Text("Inventory Status")
                .modifier(TitleModifier())
            
            TypePickerView(typeID: self.$typeID)

            Text("Showing items of \(concessionTypes[typeID].restockNumber) or less")
                .font(.title3)
            
            VStack {
                HStack {
                    Text("Item:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    Text("On-Hand Qty:")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                } //: HStack - Titles
                .font(.footnote)
                .padding(.horizontal)
                
                List(self.items, id: \.self) { item in
                    HStack {
                        Text("\(item.name) \(item.subtype == "" ? "" : "- \(item.subtype)")")
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("\(item.onHandQty)")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .font(.title2)
                    .padding(.vertical, 5)
                    
                } //: List
                .frame(maxHeight: .infinity)
                
            } //: VStack
            .frame(maxWidth: 600)
            .padding()
            
        }
        
        
    }
}
