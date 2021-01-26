

import SwiftUI
import RealmSwift

struct ItemSelectorView: View {
    @Binding var selectedItemType: String
    @Binding var selectedItemName: String
    @Binding var isShowingDetail: Bool
        
    var results: Results<Item> {
        let predicate = NSPredicate(format: "itemType == %@", selectedItemType)
        return try! Realm().objects(Item.self).filter(predicate)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(self.results, id: \.self) { item in
                    Button(action: {
                        self.selectedItemName = item.name
                        self.isShowingDetail = true
                    }) {
                        HStack {
                            Text(item.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            RightChevron()
                        } //: HStack
                        .font(.system(size: 18, weight: .light, design: .rounded))
                        .foregroundColor(.black)
                    } //: Button - Item
                    .padding(.horizontal)
                    .frame(height: 40)
                    
                    Divider()
                } //: ForEach
            } //: VStack
        } //: ScrollView
    } //: Body
    
}
