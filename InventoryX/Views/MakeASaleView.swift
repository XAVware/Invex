//
//  MakeASaleView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 5/1/23.
//

import SwiftUI
import RealmSwift

class MakeASaleViewModel: ObservableObject {
    @Published var cartItems: [InventoryItemModel] = []
//    @Published var cartItems: [InventoryItemModel] = [InventoryItemModel(id: InventoryItemEntity.item1._id, name: InventoryItemEntity.item1.name, retailPrice: 1.00, qtyInCart: 2)]
    @Published var isConfirmingSale: Bool = false
    
    var cartSubtotal: Double {
        var tempTotal: Double = 0
        for item in cartItems {
            guard let retailPrice = item.retailPrice else { return -2 }
            guard let qtyInCart = item.qtyInCart else { return -3 }
            tempTotal += retailPrice * Double(qtyInCart)
        }
        return tempTotal
    }
    
    func itemTapped(item: InventoryItemEntity) {
        if let _ = cartItems.first(where: { $0.id == item._id }) {
            // Item is already in cart, adjust quantity
            adjustQuantityInCart(item: item, by: 1)
        } else {
            //Item is not already in cart, append
            addItem(item)
        }
    }
    
    func checkoutTapped() {
        //Remove items from cart if the quantity is 0 and check that there are still items in cart.
        cartItems.removeAll (where: { $0.qtyInCart == 0 })
        guard !cartItems.isEmpty else { return }
        
        //Display Confirmation Page in View
        //View listens for change of isConfirming and hides/shows the menu.
        isConfirmingSale.toggle()
    }
    
    func finalizeTapped() {
        finalizeSale()
    }
    
    func cancelTapped() {
        returnToMakeASale()
    }
    
    func getColumns(gridWidth: CGFloat) -> [GridItem] {
        let itemSize = gridWidth * 0.20
        //        let numberOfColums = 4
        let itemSpacing = gridWidth * 0.05
        
        let columns = [
            GridItem(.fixed(itemSize), spacing: itemSpacing),
            GridItem(.fixed(itemSize), spacing: itemSpacing),
            GridItem(.fixed(itemSize), spacing: itemSpacing),
            GridItem(.fixed(itemSize), spacing: itemSpacing)
        ]
        return columns
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func addItem(_ item: InventoryItemEntity) {
        let tempCartItem = InventoryItemModel(id: item._id, name: item.name, retailPrice: item.retailPrice, qtyInCart: 1)
        cartItems.append(tempCartItem)
    }
    
    private func adjustQuantityInCart(item: InventoryItemEntity, by amount: Int) {
        guard let existingItem = cartItems.first(where: { $0.id == item._id }) else { return }
        guard let index = cartItems.firstIndex(where: { $0.id == item._id }) else { return }
        let newQty = (existingItem.qtyInCart ?? -2) + 1
        //FOR TESTING
        let tempCartItem = InventoryItemModel(id: item._id, name: item.name, retailPrice: item.retailPrice, qtyInCart: newQty)
        cartItems[index] = tempCartItem
    }
    
    private func finalizeSale() {
        //Subtract the number sold from the original on hand quantity and update the item in Realm
        cartItems.forEach({ item in
            
            // When Checkout is first tapped, all items that have a nil or 0 qtyInCart are removed from cartItems array. This line should not be necessary. Maybe use closure to pass $0 to funtion.
            guard let qtySold = item.qtyInCart else { return }
            
            do {
                let realm = try Realm()
                guard let result = realm.object(ofType: InventoryItemEntity.self, forPrimaryKey: item.id) else {
                    print("Error getting result")
                    return
                }
                
                try realm.write {
                    result.onHandQty = result.onHandQty - qtySold
                }
                print("Finished saving sale. New Qty should be \(result.onHandQty - qtySold)")
            } catch {
                print(error.localizedDescription)
            }
        })
        
        //Create and save sale in Realm
        let saleTotal = cartItems
            .map({ Double($0.retailPrice! * Double($0.qtyInCart!)) })
            .reduce(into: 0.0, { $0 += $1 })
        
        let newSale = SaleEntity(timestamp: Date(), total: saleTotal)
        cartItems.forEach({ item in
            guard let name = item.name, let qtySold = item.qtyInCart, let price = item.retailPrice else { return }
            let saleItem = SaleItemEntity(name: name, qtyToPurchase: qtySold, unitPrice: price)
            newSale.items.append(saleItem)
        })
        
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.add(newSale)
            }
            print("New Sale Item Count: \(newSale.items.count)")
        } catch {
            print(error.localizedDescription)
        }
        
        //Show success message, reset cart
        cartItems.removeAll()
        returnToMakeASale()
    }
    
    private func returnToMakeASale() {
        isConfirmingSale.toggle()
    }
    
}

struct MakeASaleView: View {
    @ObservedResults(CategoryEntity.self) var categories
    @StateObject var vm: MakeASaleViewModel = MakeASaleViewModel()
    @State var selectedCategory: CategoryEntity = .init()
    @Binding var menuIsHidden: Bool
    
    private func setDefaultCategory() {
        guard let defaultCategory = categories.first else { return }
        selectedCategory = defaultCategory
    }
    
    var body: some View {
        VStack {
            switch vm.isConfirmingSale {
            case true:
                confirmSaleView
                    .background(primaryBackground)
            case false:
                makeASaleView
                    .background(primaryBackground)
            }
        } //: VStack
        .onChange(of: vm.isConfirmingSale, perform: { _ in
            withAnimation(.easeOut, {
                menuIsHidden.toggle()
            })
        })
        .onAppear {
            setDefaultCategory()
        }
    } //: Body
    
    private var makeASaleView: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        searchBar
                        
                        Divider()
                        
                        buttonPanel
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(secondaryBackground)
                    .cornerRadius(20, corners: [.topLeft, .topRight, .bottomRight])
                    
                    categorySelector
                } //: VStack
                
                cartView
                    .frame(width: geo.size.width * 0.25)
            } //: HStack
        } //: Geometry Reader
    } //: Make A Sale View
    
    private var confirmSaleView: some View {
        GeometryReader { geo in
            VStack(spacing: 32) {
                VStack(spacing: 8) {
                    Text("Amount Due:")
                        .modifier(TextMod(.largeTitle, .semibold, lightFgColor))
                    
                    Text(vm.cartSubtotal.formatAsCurrencyString())
                        .modifier(TextMod(.system(size: 48), .semibold, lightFgColor))
                } //: VStack
                
                VStack {
                    HStack {
                        Text("Item")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Quantity")
                            .frame(maxWidth: .infinity)
                        
                        Text("Price")
                            .frame(maxWidth: .infinity)
                        
                        Text("Subtotal")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    } //: HStack
                    .modifier(TextMod(.callout, .regular, lightFgColor))
                    
                    Divider().background(lightFgColor)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            ForEach(vm.cartItems, id: \.id) { item in
                                HStack {
                                    Text(item.name ?? "Error")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text("\(item.qtyInCart ?? -1)")
                                        .frame(maxWidth: .infinity)
                                    
                                    Text(item.retailPrice?.formatAsCurrencyString() ?? "Error")
                                        .frame(maxWidth: .infinity)
                                    
                                    Text(item.cartItemSubtotal.formatAsCurrencyString())
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                } //: HStack
                                .modifier(TextMod(.callout, .semibold, lightFgColor))
                                .frame(height: 30)
                                
                                Divider().background(secondaryBackground).opacity(0.3)
                            } //: ForEach
                        } //: VStack
                    } //: ScrollView
                } //: VStack
                .frame(width: 0.4 * geo.size.width)
                
                VStack {
                    Button {
                        vm.finalizeTapped()
                    } label: {
                        Text("Finalize Sale")
                    }
                    .modifier(RoundedButtonMod())
                    
                    Button {
                        vm.cancelTapped()
                    } label: {
                        Text("Cancel Sale")
                            .underline()
                            .modifier(TextMod(.body, .regular, lightFgColor))
                            .padding()
                    }
                } //: VStack

            } //: VStack
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical)
        } //: Geometry Reader
    } //: Confirm Sale View
    
    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 16)
                .bold()
            
            Text("Search...")
                .modifier(TextMod(.title3, .semibold, .gray))
            
            Spacer()
        } //: HStack
        .padding(.horizontal)
        .frame(height: 40)
        .foregroundColor(.gray)
    } //: Search Bar
    
    private var buttonPanel: some View {
        GeometryReader { geo in
            if selectedCategory.items.count > 0 {
                VStack(spacing: geo.size.width * 0.05) {
                    LazyVGrid(columns: vm.getColumns(gridWidth: geo.size.width), spacing: 0) {
                        ForEach(selectedCategory.items) { item in
                            Button {
                                vm.itemTapped(item: item)
                            } label: {
                                Text(item.name)
                                    .modifier(TextMod(.title3, .semibold, .black))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            .frame(height: 80)
                            .background(itemButtonColor)
                            .cornerRadius(9)
                            .shadow(radius: 8)
                        } //: ForEach
                    } //: LazyVGrid
                    .padding()
                    
                    Spacer()
                } //: VStack
            } else {
                VStack {
                    Spacer()
                    
                    Text("No Items Yet!")
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } //: If - Else
        } //: Geometry Reader
    } //: Button Panel
    
    private var cartView: some View {
        VStack {
            HStack {
                Spacer()
                
                Image(systemName: "cart")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                    .foregroundColor(lightFgColor)
                    .fontWeight(.semibold)
            }
            
            ScrollView {
                VStack {
                    ForEach(vm.cartItems, id: \.id) { item in
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text(item.name ?? "Empty")
                                    .modifier(TextMod(.title2, .semibold, .white))
                                
                                Spacer()
                                
                                Image(systemName: "trash")
                                    .foregroundColor(.white)
                            } //: HStack
                            
                            HStack {
                                Text((item.retailPrice ?? -5).formatAsCurrencyString())
                                    .modifier(TextMod(.body, .semibold, .white))
                                
                                Text("x")
                                    .modifier(TextMod(.callout, .regular, .white))
                                
                                Text("\(item.qtyInCart ?? -4)")
                                    .modifier(TextMod(.body, .semibold, .white))
                                
                            } //: HStack
                        } //: VStack
                        .padding(.vertical, 8)
                        .background(.clear)
                        .frame(maxWidth: 350, alignment: .leading)
                        
                        Divider().background(.white)
                    } //: For Each
                } //: VStack
                .frame(maxHeight: .infinity)
            } //: ScrollView
            
            Divider().background(.white)
            
            HStack {
                Text("Subtotal:")
                    .modifier(TextMod(.title3, .semibold, lightFgColor))
                
                Spacer()
                
                Text(vm.cartSubtotal.formatAsCurrencyString())
                    .modifier(TextMod(.title2, .semibold, lightFgColor))
            } //: HStack
            .padding(.vertical, 8)
            .frame(maxWidth: 350)
            
            Button {
                vm.checkoutTapped()
            } label: {
                Text("Check Out")
                    .frame(maxWidth: .infinity)
            }
            .modifier(RoundedButtonMod())
            
        } //: VStack
        .padding(.horizontal)
        .background(primaryBackground)
        .frame(maxWidth: 350)
//        .onAppear {
//            for item in CategoryEntity.foodCategory.items {
//                vm.addItem(item)
//            }
//        }
    } //: CartView
    
    private var categorySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 2) {
                ForEach(categories) { category in
                    Button {
                        selectedCategory = category
                    } label: {
                        Text(category.name)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .foregroundColor(selectedCategory == category ? darkFgColor : lightFgColor)
                    }
                    .frame(minWidth: 150)
                    .background(selectedCategory == category ? secondaryBackground : selectedButtonColor)
                    .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
                }
            } //: HStack
        } //: Scroll
        .frame(maxWidth: .infinity, maxHeight: 40)
        .background(.clear)
    } //: Category Selector
    
}

struct MakeASaleView_Previews: PreviewProvider {
    @StateObject static var vm: MakeASaleViewModel = MakeASaleViewModel()
    @State static var category: CategoryEntity = CategoryEntity.foodCategory
    @State static var hidden: Bool = false
    static var previews: some View {
        
        MakeASaleView(vm: vm, selectedCategory: category, menuIsHidden: $hidden)
            .modifier(PreviewMod())
    }
}
