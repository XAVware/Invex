//
//  RestockView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 5/1/23.
//

import SwiftUI
import RealmSwift

enum DetailViewType {
    case newItem, restockItem
}

struct RestockView: View {
    @State var activeSheet: DetailViewType      = .newItem
    @State var isShowingDetailView: Bool        = false
    @State var selectedItemName: String         = ""
    @State var selectedConcessionType: String = ""
    
    @ObservedResults(CategoryEntity.self) var categories
    @ObservedResults(InventoryItemEntity.self) var items
    
    @State var isShowingDetail: Bool = true
    @State var selectedItem: InventoryItemEntity?
    
    func itemTapped(itemId: ObjectId) {
        let itemResult = items.where {
            $0._id == itemId
        }
        
        guard let selectedItem = itemResult.first else { return }
        
        self.selectedItem = selectedItem
        
        withAnimation(.easeOut(duration: 0.3)) {
            isShowingDetail = true
        }
        
//        selectedItemName       = category.items.sorted(byKeyPath: "name", ascending: true)[index].name
//        selectedItemSubtype    = item.subtype
//        activeSheet            = .restockItem
//        isShowingDetailView    = true
    }
    
    func addItemTapped() {
        self.activeSheet = .newItem
        self.isShowingDetailView = true
    }
    

    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                listView
                    .padding()
                    .background(Color(XSS.S.color80))
                    .cornerRadius(20, corners: [.topLeft])
                    .fullScreenCover(isPresented: $isShowingDetailView, onDismiss: {
                        selectedItemName = ""
                    }) {
                        ItemDetailView(viewType: activeSheet, itemName: selectedItemName)
                    }
                    .onChange(of: activeSheet) { (sheet) in
                        isShowingDetailView = true
                    }
                    .edgesIgnoringSafeArea(.bottom)
                
                if isShowingDetail {
//                    if let selectedItem = selectedItem {
                    if let selectedItem = items.first {
                        Divider().background(darkTextColor)
                        RestockItemDetailView(selectedItem: selectedItem, isShowing: $isShowingDetail)
                            .frame(width: geo.size.width / 3)
                    }
                }
            } //: HStack

        }
    } //: Body
    
    
    private var listView: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Select an item below to restock.")
                    .modifier(TextMod(.footnote, .semibold, darkTextColor))
                
                Spacer()
                
                Button {
                    addItemTapped()
                } label: {
                    Text("New Item")
                        .modifier(TextMod(.footnote, .semibold, darkTextColor))
                    
                    Image(systemName: "plus")
                        .scaledToFit()
                        .foregroundColor(darkTextColor)
                        .bold()
                }
                .padding(8)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(darkTextColor, lineWidth: 3))
            } //: HStack
            .foregroundColor(Color(XSS.S.color20))
            
            Divider()
                .padding(.vertical, 14)
            
            ForEach(categories.sorted(byKeyPath: "name", ascending: true)) { category in
                VStack {
                    Text(category.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .modifier(TextMod(.title2, .semibold, darkTextColor))
                        .padding(.bottom, 8)
                    
                    VStack(spacing: 0) {
                        HStack {
                            Text("Item Name:")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("Qty. On-Hand:")
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            Text("Retail Price:")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 34)
                        } //: HStack
                        .modifier(TextMod(.body, .bold, .black))
                        .padding(.horizontal)
                        
                        Divider()
                        
                        ForEach(category.items.sorted(byKeyPath: "name", ascending: true).indices, id: \.self) { index in
                            HStack {
                                Text(category.items.sorted(byKeyPath: "name", ascending: true)[index].name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(category.items.sorted(byKeyPath: "name", ascending: true)[index].onHandQty.description)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                Text(String(format: "$ %.02f", category.items.sorted(byKeyPath: "name", ascending: true)[index].retailPrice))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.trailing)
                                
                                Image(systemName: "chevron.right")
                            } //: HStack
                            .frame(height: 30)
                            .padding(.horizontal)
                            .background(index % 2 == 0 ? Color(XSS.S.color90) : Color(XSS.S.color80))
                            .modifier(TextMod(.body, .regular, .black))
                            .onTapGesture {
                                itemTapped(itemId: category.items.sorted(byKeyPath: "name", ascending: true)[index]._id)
                            }
                        }
                    } //: VStack
                    .padding(.horizontal)
                } //: VStack
                .padding()
                .background(Color(XSS.S.color90))
                .cornerRadius(20, corners: [.allCorners])
                
                Spacer().frame(height: 16)
            } //: ForEach
            
            Spacer()
        } //: VStack
    } //: List View
}

struct RestockView_Previews: PreviewProvider {
    static var previews: some View {
        RestockView()
            .modifier(PreviewMod())
    }
}

struct RestockItemDetailView: View {
    @ObservedRealmObject var selectedItem: InventoryItemEntity
    @Binding var isShowing: Bool
    
    @State var restockQuantity: Int = 10
    
    func saveTapped() {
        
        isShowing.toggle()
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Restock Item")
                .modifier(TextMod(.title, .bold))
            
            HStack {
                Text("Item:")
                    .modifier(TextMod(.title3, .semibold))
                
                Text(selectedItem.name)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            Divider()
            
            HStack {
                Text("On-Hand:")
                    .modifier(TextMod(.title3, .semibold))
                
                Text("\(selectedItem.onHandQty)")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            Divider()
            
            
            
            
            Spacer()
            
            Button {
                saveTapped()
            } label: {
                Text("Save")
            }
            .modifier(RoundedButtonMod())

        } //: VStack
        .padding()
        .background(Color(XSS.S.color90))
    }
}


// MARK: - ITEM DETAIL VIEW

enum SaveResult {
    case success, failure
}

struct ItemDetailView: View {
    @Environment(\.dismiss) var dismiss
//    @Environment(\.presentationMode) var presentationMode
    @State var viewType: DetailViewType
    @State var itemName: String
    
    @State var newItemType: String          = "-Select Type-"
    @State var newItemPrice: Double         = 1.00
    @State var quantityPurchased: Int       = 24
    
    @State var typeExpanded: Bool           = false
    @State var priceExpanded: Bool          = false
    @State var quantityExpanded: Bool       = false
    
    @State var errorMessage: String         = ""
    @State var savedSuccessfully: Bool      = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer(minLength: 40)
                
                Text(self.viewType == .newItem ? "New Item" : "Restock Item")
                    .modifier(TitleModifier())
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 20, alignment: .center)
                }
            } //: HStack - Header
            .modifier(HeaderModifier())
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    if self.viewType == .newItem {
                        VStack {
                            Text(self.$errorMessage.wrappedValue)
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.red)
                            
                            TextField("Item Name:", text: $itemName)
                                .modifier(TextFieldModifier())
                            
                        } //: VStack
                        .padding(.vertical)
                        
                        GroupBox {
                            DisclosureGroup(isExpanded: self.$typeExpanded) {
                                Divider().padding(.top).padding(.bottom, 2)
                                VStack {
                                    ForEach(categoryList, id: \.self) { category in
                                        Button(action: {
                                            self.newItemType = category.name
                                        }) {
                                            HStack {
                                                Text(category.name)
                                                    .font(.system(size: 18, design: .rounded))
                                                    .foregroundColor(.black)
                                                
                                                Spacer()
                                                
                                                Image(systemName: self.newItemType == category.name ? "checkmark.circle.fill" : "circle")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 20, height: 20)
                                                    .foregroundColor(primaryColor)
                                            } //: HStack
                                        } //: Button - Concession Type
                                        if category.name != categoryList[categoryList.count - 1].name {
                                            Divider()
                                        }
                                    } //: ForEach
                                } // VStack
                            } label: {
                                HStack {
                                    Text("Item Type:")
                                        .frame(maxWidth:.infinity, alignment: .leading)
                                        .font(.callout)
                                    
                                    Text("\(self.$newItemType.wrappedValue)")
                                        .frame(maxWidth:.infinity, alignment: .center)
                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    
                                    Text(self.typeExpanded ? "Confirm" : "Change")
                                        .frame(maxWidth:.infinity, alignment: .trailing)
                                        .font(.footnote)
                                } //: HStack
                                .foregroundColor(.black)
                            } //: DisclosureGroup
                        } //: GroupBox - Item Type
                        .onTapGesture { withAnimation { self.typeExpanded.toggle() } }
                        
                        GroupBox {
                            DisclosureGroup(isExpanded: self.$priceExpanded) {
                                Divider().padding(.vertical)
                                Slider(value: $newItemPrice, in: 0.00 ... 5.00, step: 0.25)
                                    .frame(width: 400)
                                    .padding(.bottom)
                            } label: {
                                HStack {
                                    Text("Retail Price:")
                                        .frame(maxWidth:.infinity, alignment: .leading)
                                        .font(.callout)
                                    
                                    Text("$\(String(format: "%.2f", self.newItemPrice))")
                                        .frame(maxWidth:.infinity, alignment: .center)
                                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                                    
                                    Text(self.priceExpanded ? "Confirm" : "Change")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .font(.footnote)
                                } //: HStack
                            } //: DisclosureGroup
                            .foregroundColor(.black)
                            .onTapGesture { withAnimation { self.priceExpanded.toggle() } }
                        } //GroupBox - Price
                    } else {
                        GroupBox {
                            HStack {
                                Text("Item:")
                                    .frame(maxWidth:.infinity, alignment: .leading)
                                    .font(.title2)
                                
                                Text(itemName)
                                    .frame(maxWidth:.infinity, alignment: .center)
                                    .font(.title)
                                
                                Button {
                                    dismiss()
                                } label: {
                                    Text("Change")
                                        .frame(maxWidth:.infinity, alignment: .trailing)
                                        .font(.footnote)
                                }
                            } //: HStack
                            .foregroundColor(.black)
                        } //: GroupBox
                        
                        Spacer().frame(height: 20)
                        
                        Text("On-Hand Quantity:  \(self.getOnHandQuantity())")
                            .frame(maxWidth:.infinity, alignment: .leading)
                            .font(.callout)
                            .foregroundColor(.black)
                        
                    }
                    
                    GroupBox {
                        DisclosureGroup(isExpanded: self.$quantityExpanded) {
                            VStack {
                                Divider().padding(.vertical)
                                QuantitySelector(selectedQuantity: self.$quantityPurchased, showsCustomToggle: true)
                            }
                        } label: {
                            HStack {
                                Text("Quantity Purchased:")
                                    .frame(maxWidth:.infinity, alignment: .leading)
                                    .font(.callout)
                                
                                Text("\(self.quantityPurchased)")
                                    .frame(maxWidth:.infinity, alignment: .center)
                                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                                
                                Text(self.quantityExpanded ? "Confirm" : "Change")
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .font(.footnote)
                            } //: HStack
                            .onTapGesture { withAnimation { self.quantityExpanded.toggle() } }
                        } //: DisclosureGroup
                        .foregroundColor(.black)
                    } //: GroupBox
                    
                    SaveItemButton(action: {
                        self.typeExpanded = false
                        self.priceExpanded = false
                        self.quantityExpanded = false
                        
                        self.errorMessage = ""
                        
                        guard self.quantityPurchased >= 0 else {
                            self.errorMessage = "Please enter a valid quantity"
                            self.priceExpanded = false
                            self.typeExpanded = false
                            withAnimation { self.quantityExpanded = true }
                            return
                        }
                        
                        switch self.viewType {
                        case .newItem:
                            guard self.saveNewItem() == .success else {
                                return
                            }
                        case .restockItem:
                            guard self.restockItem() == .success else {
                                return
                            }
                        }
                        
                        self.savedSuccessfully = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            dismiss()
                        }
                        
                    }) //: Save Button
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                }
                .frame(maxWidth: 600, maxHeight: .infinity)
            }
        } //: VStack - Main Stack
        .padding()
        .overlay(
            ZStack {
                if self.savedSuccessfully {
                    Color.white.frame(maxWidth: .infinity, maxHeight: .infinity)
                    AnimatedCheckmarkView()
                }
            }
            
        )
        .onChange(of: self.typeExpanded, perform: { typeIsExpanded in
            if typeIsExpanded {
                self.priceExpanded = false
                self.quantityExpanded = false
            }
        })
        .onChange(of: self.priceExpanded, perform: { priceIsExpanded in
            if priceIsExpanded {
                self.typeExpanded = false
                self.quantityExpanded = false
            }
        })
        .onChange(of: self.quantityExpanded, perform: { quantityIsExpanded in
            if quantityIsExpanded {
                self.typeExpanded = false
                self.priceExpanded = false
            }
        })
    }
    
    func getOnHandQuantity() -> Int {
        let items: Results<InventoryItem> = try! Realm().objects(InventoryItem.self).filter(NSPredicate(format: "name == %@", self.itemName))
        var selectedItem: InventoryItem = InventoryItem()
        for item in items {
//            if item.subtype == self.itemSubtype {
//                selectedItem = item
//            }
        }
        return selectedItem.onHandQty
    }
    
    func saveNewItem() -> SaveResult {
        self.itemName = self.itemName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !self.itemName.isEmpty else {
            self.errorMessage = "Please Enter a Valid Item Name"
            return .failure
        }
        
        guard self.newItemType != "-Select Type-" else {
            self.errorMessage = "Please Select an Item Type"
            self.priceExpanded = false
            self.quantityExpanded = false
            withAnimation { self.typeExpanded = true }
            return .failure
        }
        
        let newItem = InventoryItem()
        newItem.name        = self.itemName
//        newItem.subtype     = self.itemSubtype
        newItem.itemType    = self.newItemType
        newItem.retailPrice = self.newItemPrice
        newItem.onHandQty   = self.quantityPurchased
        
        let namePredicate = NSPredicate(format: "name == %@", self.itemName)
        do {
            let realm = try! Realm()
            let result = realm.objects(InventoryItem.self).filter(namePredicate)
//            for item in result {
//                guard item.subtype != self.itemSubtype else {
//                    self.errorMessage = "Item with name \(self.itemName) - \(self.itemSubtype) already exists"
//                    return .failure
//                }
//            }
            
            try realm.write ({
                realm.add(newItem)
            })
            
            return .success
        } catch {
            print(error.localizedDescription)
            return .failure
        }
    }
    
    func restockItem() -> SaveResult {
        let predicate = NSPredicate(format: "name == %@", self.itemName)
        let config = Realm.Configuration(schemaVersion: 1)
        do {
            let realm = try Realm(configuration: config)
            let result = realm.objects(InventoryItem.self).filter(predicate)
            for item in result {
//                if item.subtype == self.itemSubtype {
//                    try realm.write ({
//                        item.onHandQty += self.quantityPurchased
//                        realm.add(item)
//                    })
//                    return .success
//                }
            }
        } catch {
            print(error.localizedDescription)
            return .failure
        }
        return .failure
    }
    

}


struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailView(viewType: .newItem, itemName: "Skittles")
            .modifier(PreviewMod())
    }
}
