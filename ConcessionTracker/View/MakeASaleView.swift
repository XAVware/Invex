

import SwiftUI
import RealmSwift

struct MakeASaleView: View {
    @ObservedObject var cart: Cart
    @State var selectedTypeID: Int = 0
    
    let cartWidthPercentage: CGFloat = 0.40
    
//    var results: Results<Item> {
//        let predicate = NSPredicate(format: "itemType == %@", concessionTypes[selectedTypeID].type)
//        return try! Realm().objects(Item.self).filter(predicate).sorted(byKeyPath: "name", ascending: true)
//    }
    
    var results: Results<Item> {
        let predicate = NSPredicate(format: "itemType == %@", categoryList[selectedTypeID].name)
        return try! Realm().objects(Item.self).filter(predicate).sorted(byKeyPath: "name", ascending: true)
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                //MARK: - Make A Sale Item Button Dashboard
                if !self.cart.isConfirmation {
                    VStack(alignment: .center, spacing: 5) {
//                        TypePickerView(typeID: self.$selectedTypeID)
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 0) {
                                ForEach(self.getItems(), id: \.self) { item in
                                    ItemButton(cart: self.cart, item: item)
                                        .shadow(radius: 8)
                                }
                            }
                            .padding(.horizontal, 10)
                        } //: ScrollView
                        CategorySlider(categoryIndex: self.$selectedTypeID)
                    } //: VStack
                    .frame(width: geometry.size.width - (geometry.size.width * cartWidthPercentage))
                    Spacer().frame(width: geometry.size.width * cartWidthPercentage)
                }
            } //: HStack
        }
        
    } //: VStack used to keep header above all pages
    
    func getItems() -> [Item] {
        var tempList: [Item] = []
        for item in results {
            tempList.append(item)
        }
        return tempList
    }    
}
