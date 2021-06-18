

import SwiftUI
import RealmSwift

enum SaveResult {
    case success, failure
}

struct ItemDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var viewType: DetailViewType
    @State var itemName: String
    @State var itemSubtype: String
    
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
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
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
                            
                            TextField("Subtype: (Optional)", text: $itemSubtype)
                                .modifier(TextFieldModifier())
                                .frame(maxWidth: 450)
                            
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
                                                    .foregroundColor(Color("ThemeColor"))
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
                                
                                Text("\(itemName) \(itemSubtype == "" ? "" : "- \(itemSubtype)")")
                                    .frame(maxWidth:.infinity, alignment: .center)
                                    .font(.title)
                                
                                Button(action: {
                                    self.presentationMode.wrappedValue.dismiss()
                                }) {
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
                            self.presentationMode.wrappedValue.dismiss()
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
        let items: Results<Item> = try! Realm().objects(Item.self).filter(NSPredicate(format: "name == %@", self.itemName))
        var selectedItem: Item = Item()
        for item in items {
            if item.subtype == self.itemSubtype {
                selectedItem = item
            }
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
        
        let newItem = Item()
        newItem.name        = self.itemName
        newItem.subtype     = self.itemSubtype
        newItem.itemType    = self.newItemType
        newItem.retailPrice = self.newItemPrice
        newItem.onHandQty   = self.quantityPurchased
        
        let namePredicate = NSPredicate(format: "name == %@", self.itemName)
        do {
            let realm = try! Realm()
            let result = realm.objects(Item.self).filter(namePredicate)
            for item in result {
                guard item.subtype != self.itemSubtype else {
                    self.errorMessage = "Item with name \(self.itemName) - \(self.itemSubtype) already exists"
                    return .failure
                }
            }
            
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
            let result = realm.objects(Item.self).filter(predicate)
            for item in result {
                if item.subtype == self.itemSubtype {
                    try realm.write ({
                        item.onHandQty += self.quantityPurchased
                        realm.add(item)
                    })
                    return .success
                }
            }
        } catch {
            print(error.localizedDescription)
            return .failure
        }
        return .failure
    }
    

}
