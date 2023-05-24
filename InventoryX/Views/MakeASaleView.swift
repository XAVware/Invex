//
//  MakeASaleView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 5/1/23.
//

import SwiftUI
import RealmSwift

class MakeASaleViewModel: ObservableObject {
    @Published var cartItems: [InventoryItemModel] = [InventoryItemModel(id: InventoryItemEntity.item1._id, name: InventoryItemEntity.item1.name)]
    
    var cartSubtotal: Double {
        var tempTotal: Double = 0
        for item in cartItems {
            guard let retailPrice = item.retailPrice else { return -2 }
            guard let qtyInCart = item.qtyInCart else { return -3 }
            tempTotal += retailPrice * Double(qtyInCart)
        }
        return tempTotal
    }
    

    func addItem(_ item: InventoryItemEntity) {
        let tempCartItem = InventoryItemModel(id: item._id, name: item.name, retailPrice: item.retailPrice, qtyInCart: 1)
        cartItems.append(tempCartItem)
    }
    
    func adjustQuantityInCart(item: InventoryItemEntity, by amount: Int) {
        guard let existingItem = cartItems.first(where: { $0.id == item._id }) else { return }
        guard let index = cartItems.firstIndex(where: { $0.id == item._id }) else { return }
        let newQty = (existingItem.qtyInCart ?? -2) + 1
        let tempCartItem = InventoryItemModel(id: item._id, name: item.name, retailPrice: item.retailPrice, qtyInCart: newQty)
        cartItems[index] = tempCartItem
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
        //Display Confirmation Page
        //Remove items from cart if the quantity is 0
        //Subtract the number sold from the original on hand quantity and update the item in Realm
        //Create and save sale in Realm
        //Show success message, reset cart
    }
    
}

struct MakeASaleView: View {
    @ObservedResults(CategoryEntity.self) var categories
    @StateObject var vm: MakeASaleViewModel = MakeASaleViewModel()
    @State var selectedCategory: CategoryEntity = .init()
    
    private func setDefaultCategory() {
        guard let defaultCategory = categories.first else { return }
        selectedCategory = defaultCategory
    }
    
    var body: some View {
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
                    .background(Color(XSS.S.color80))
                    .cornerRadius(20, corners: [.topLeft, .topRight, .bottomRight])
                    
                    categorySelector
                } //: VStack
                
                cartView
                    .frame(width: geo.size.width * 0.25)
            } //: HStack
            
        } //: Geometry Reader
        .onAppear {
            setDefaultCategory()
        }
    } //: Body
    
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
                            .background(Color(XSS.ComplimentS.color70))
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
                    .foregroundColor(lightTextColor)
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
                                Text((item.retailPrice ?? -5).formatToCurrencyString())
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
                    .modifier(TextMod(.title3, .semibold, lightTextColor))
                
                Spacer()
                
                Text(vm.cartSubtotal.formatToCurrencyString())
                    .modifier(TextMod(.title2, .semibold, lightTextColor))
            } //: HStack
            .padding(.vertical, 8)
            .frame(maxWidth: 350)
            
            Button {
                //
            } label: {
                Text("Check Out")
                    .frame(maxWidth: .infinity)
            }
            .modifier(RoundedButtonMod())
            
        } //: VStack
        .padding(.horizontal)
        .background(Color(XSS.S.color20))
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
                            .foregroundColor(selectedCategory == category ? Color(XSS.S.color10) : Color(XSS.S.color90))
                        
                    }
                    .frame(minWidth: 150)
                    .background(selectedCategory == category ? Color(XSS.S.color80) : Color(XSS.S.color40))
                    .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
                }
            } //: HStack
        } //: Scroll
        .frame(maxWidth: .infinity, maxHeight: 40)
        .background(.clear)
        .onAppear {
            setDefaultCategory()
        }
    } //: Category Selector
    
    
}

struct MakeASaleView_Previews: PreviewProvider {
    @StateObject static var vm: MakeASaleViewModel = MakeASaleViewModel()
    @State static var category: CategoryEntity = CategoryEntity.foodCategory
    
    static var previews: some View {
        
        MakeASaleView(vm: vm, selectedCategory: category)
            .modifier(PreviewMod())
    }
}
