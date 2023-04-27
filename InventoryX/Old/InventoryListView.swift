

import SwiftUI
import RealmSwift

struct InventoryListView: View {
//    @State var selectedConcessionType: String       = concessionTypes[0].type
    @State var selectedConcessionType: String       = categoryList[0].name
    @State var isShowingDetailView: Bool            = false
    
    @State var selectedItem: InventoryItem = InventoryItem()
    
    var results: Results<InventoryItem> {
        let predicate = NSPredicate(format: "itemType == %@", selectedConcessionType)
        return try! Realm().objects(InventoryItem.self).filter(predicate).sorted(byKeyPath: "name", ascending: true)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Text("Inventory List")
                    .modifier(TitleModifier())
                
                Text("Tap an item to edit it.")
                    .modifier(TitleDetailModifier())
                
                HStack(spacing: 0) {
                    Text("Item Type:")
                        .frame(width: geometry.size.width * 0.30, alignment: .leading)
                    
                    Text("Name:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("On-Hand Qty:")
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text("Retail Price:")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Spacer().frame(width: 16)
                }
                .modifier(DetailTextModifier(textColor: .black))
                
                Divider()
                
                HStack(spacing: 0) {
                    TypeSelectorView(selectedType: self.$selectedConcessionType)
                        .frame(width: geometry.size.width * 0.30)
                    
                    Divider()
                    
                    if !self.isShowingDetailView {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 0) {
                                ForEach(self.results, id: \.self) { item in
                                    Button(action: {
                                        self.selectedItem = item
                                        self.isShowingDetailView = true
                                    }) {
                                        HStack {
                                            Text("\(item.name) \(item.subtype == "" ? "" : "- \(item.subtype)")")
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            Text("\(item.onHandQty)")
                                                .frame(maxWidth: .infinity, alignment: .center)
                                            
                                            Text("$\(String(format: "%.2f", item.retailPrice))")
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                            
                                            Image(systemName: "chevron.right")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 10, height: 15)
                                        } //: HStack
                                    } //: Button - Item
                                    .modifier(DetailTextModifier(textColor: .black))
                                    .frame(height: 40)
                                    
                                    Divider()
                                } //: ForEach
                            } //: VStack
                        } //: ScrollView
                        .frame(width: geometry.size.width * 0.70)
                    } else {
                        Spacer().frame(width: geometry.size.width * 0.70)
                    }
                } //: HStack - Item Selector
            }
        }
        .fullScreenCover(isPresented: self.$isShowingDetailView, onDismiss: {
            self.selectedItem = InventoryItem()
        }) {
            EditItemView(selectedItem: self.$selectedItem)
        }
        
    } //: Body
    
    
}

