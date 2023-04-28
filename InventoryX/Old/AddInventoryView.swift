

import SwiftUI
import RealmSwift

enum DetailViewType {
    case newItem, restockItem
}

struct AddInventoryView: View {
    @State var activeSheet: DetailViewType      = .newItem
//    @State var selectedConcessionType: String   = concessionTypes[0].type
//    @State var selectedConcessionType: String   = categoryList[0].name
    @State var selectedItemSubtype: String      = ""
    @State var isShowingDetailView: Bool        = false
    @State var selectedItemName: String         = ""
    
    @ObservedResults(CategoryEntity.self) var categories
    @ObservedResults(InventoryItemEntity.self) var results
    @State var selectedConcessionType: String = ""
    
    init() {
        let category = CategoryEntity(name: "Food")
        let category2 = CategoryEntity(name: "Drinks")
        do {
            let realm = try Realm()
            try realm.write ({
                realm.add(category)
                realm.add(category2)
            })
        } catch {
            print("Error saving category to Realm: \(error.localizedDescription)")
            
        }
        selectedConcessionType = "Food"
    }
//    var results: Results<InventoryItem> {
//        let predicate = NSPredicate(format: "itemType == %@", selectedConcessionType)
//        return try! Realm().objects(InventoryItem.self).filter(predicate).sorted(byKeyPath: "name", ascending: true)
//    }
    
//    var results: Results<InventoryItemEntity> {
//        let predicate = NSPredicate(format: "category == %@", selectedConcessionType)
//        return try! Realm().objects(InventoryItemEntity.self).filter(predicate).sorted(byKeyPath: "name", ascending: true)
//    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack {
                    Spacer().frame(width: 40)

                    Text("Add Inventory")
                        .modifier(TitleModifier())

                    Button(action: {
                        self.activeSheet = .newItem
                        self.isShowingDetailView = true
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 20, alignment: .center)
                            .foregroundColor(primaryColor)

                    }
                } //: HStack - Header
                .padding(.horizontal)

                Text("Select an item below to restock, or tap the '+' to add a new item.")
                    .font(.system(size: 16))
                    .padding(.bottom)

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
                                        self.selectedItemName       = item.name
//                                        self.selectedItemSubtype    = item.subtype
                                        self.activeSheet            = .restockItem
                                        self.isShowingDetailView    = true
                                    }) {
                                        HStack {
//                                            Text("\(item.name) \(item.subtype == "" ? "" : "- \(item.subtype)")")
//                                                .frame(maxWidth: .infinity, alignment: .leading)

                                            Image(systemName: "chevron.right")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 10, height: 15)
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
                        .frame(width: geometry.size.width * 0.70)
                    } else {
                        Spacer().frame(width: geometry.size.width * 0.70)
                    }
                } //: HStack - Item Selector

            } //: VStack -- Main Stack
            .fullScreenCover(isPresented: self.$isShowingDetailView, onDismiss: {
                self.selectedItemName = ""
                self.selectedItemSubtype = ""
            }) {
                ItemDetailView(viewType: self.activeSheet, itemName: self.selectedItemName, itemSubtype: self.selectedItemSubtype)
            }
            .onChange(of: self.activeSheet) { (sheet) in
                self.isShowingDetailView = true
            }

        }
    } //: Body
    
}

struct AddInventoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddInventoryView()
    }
}
