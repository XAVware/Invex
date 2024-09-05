//
//  ConfirmSaleView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/21/24.
//

import SwiftUI
import RealmSwift

struct ConfirmSaleView: View {
    @Environment(\.verticalSizeClass) var verSize
    
    @ObservedResults(CompanyEntity.self) var companies
    @ObservedResults(SaleEntity.self) var sales
    @ObservedResults(ItemEntity.self) var realmItems
    
    @State var companyName: String = ""
    @State var saleNumber: Int = -2
    @State var taxRate: Double = 0
    @State var cartItems: [CartItem]
    
    
    /// Computed array of unique items in the cart. `CartView` uses this to display a section for each item,
    /// without re-ordering them. The array of `@Published cartItems` in `PointOfSaleViewModel` can then be
    /// queried by the view to find data on each unique item such as the quantity in cart and its subtotal.
    /// This allows for re-use of `ItemEntity`. `.uniqued()` requires `Swift Algorithms.`
//    var uniqueItems: [ItemEntity] { Array(items.uniqued()) }
    
    var cartSubtotal: Double { cartItems.reduce(0) { $0 + $1.retailPrice } }
    var taxAmount: Double { cartSubtotal * taxRate / 100 }
    var total: Double { cartSubtotal + taxAmount }
    
//    var cartItemCount: Int { items.count }
    
    init(cartItems: [CartItem]) {
        self.cartItems = cartItems
    }
    
    
    func finalizeSale() async throws {
        /// Update the on-hand quantity for each unique item in the cart.
        ///     - Looping through the unique items performs better than looping through all items.
//        for index in 0...uniqueItems.count - 1 {
//            let tempItem = uniqueItems[index]
//            let cartQty = items.filter { $0._id == tempItem._id }.count
//            try await RealmActor().adjustStock(for: tempItem, by: cartQty)
//        }
        
//        for index in 0...cartItems.count - 1 {
//            let tempItem = cartItems[index]
//            let cartQty = tempItem.qtyInCart
////            let cartQty = items.filter { $0._id == tempItem._id }.count
//            try await RealmActor().adjustStock(for: tempItem, by: cartQty)
//        }
        
        for item in cartItems {
            if let realmItem = realmItems.first(where: { $0._id == item.id })?.thaw() {
                let realm = try await Realm()
                try realm.write {
                    realmItem.onHandQty = realmItem.onHandQty - item.qtyInCart
                }
                print("Finished updating stock")
            } else {
                print("Could not find item: \(item)")
            }
        }
                
        /// Convert ItemEntities to SaleItemEntities so they can be used in the sale, without
        /// risking losing an item record on delete.
        let saleItems = Array(cartItems.map( { SaleItemEntity(item: $0) } ))
        try await RealmActor().saveSale(items: saleItems, total: self.total)
        cartItems.removeAll()
    }

    
    func continueTapped() {
        guard !cartItems.isEmpty else { return }
        Task {
            do {
                try await finalizeSale()
//                LazySplitService.shared.popPrimary()
            } catch {
                debugPrint("Error saving sale: \(error)")
            }
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let isLandscape: Bool = w > h
            // 700 is slightly greater than the height of iPhone 15 pro.
            let isCondensed: Bool = max(w, h) < 700 || verSize == .compact
            
            VStack(alignment: .center, spacing: !isCondensed ? 24 : 16) {
                
                // Grid item spacing is used for the column spacing. LazyVGrid spacing is used for row spacing.
                // Layout horizontally if screen is in landscape
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 120, maximum: 540), spacing: 48), count: isLandscape ? 2 : 1), alignment: .center, spacing: 24) {
                    // MARK: - Receipt View
                    VStack(spacing: 16) {
                        HStack {
                            Text("Sale #\(saleNumber)")
                            Spacer()
                        }
                        
                        Text("\(companyName)")
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 16) {
                                ForEach(cartItems) { item in
//                                    let itemQty = items.filter { $0._id == item._id }.count
                                    let itemQty = item.qtyInCart
                                    let itemSubtotal: Double = Double(itemQty) * item.retailPrice
                                    HStack(spacing: 0) {
                                        VStack(alignment: .leading) {
                                            Text(item.name)
                                            Spacer()
                                            Text("Qty: \(itemQty)")
                                        } //: VStack
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing) {
                                            Text("\(item.retailPrice.formatAsCurrencyString()) / unit")
                                            Spacer()
                                            Text(itemSubtotal.formatAsCurrencyString())
                                        } //: VStack
                                    } //: HStack
                                    .padding(.vertical, 8)
                                    
                                    Divider().opacity(0.4)
                                } //: VStack
                            } //: For Each
                        } //: Scroll
                        .frame(maxWidth: 420)
                    } //: VStack
                    .frame(height: isLandscape ? h : h * 0.6)
                    .font(.subheadline)
                    
                    // MARK: - Summary View
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: !isCondensed ? 16 : 8) {
                            if !isCondensed {
                                Text("Order Summary")
                                    .fontWeight(.semibold)
                                    .font(verSize == .regular ? .title2 : .title3)
                                    .padding(.bottom)
                            }
                            
                            VStack(spacing: 16) {
                                HStack {
                                    Text("Subtotal:")
                                    Spacer()
                                    Text("\(cartSubtotal.formatAsCurrencyString())")
                                } //: HStack
                                
                                HStack {
                                    Text("Tax: (\(taxRate.toPercentageString())%)")
                                    Spacer()
                                    Text("\(taxAmount.formatAsCurrencyString())")
                                } //: HStack
                            } //: VStack
                            .font(.subheadline)
                            
                            Divider()
                            
                            HStack {
                                Text("Total:")
                                Spacer()
                                Text(total.formatAsCurrencyString())
                            } //: HStack
                            .fontWeight(.semibold)
                            .font(.title3)
                            .padding(.vertical, 4)
                        } //: VStack
                        .padding(.vertical, 16)
                        .padding(.horizontal)
                        .background(Color.bg.opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        Button {
                            continueTapped()
                        } label: {
                            Spacer()
                            Text("Confirm Sale")
                            Spacer()
                        }
                        .modifier(PrimaryButtonMod())
                        
                    } //: VStack - Order Summary
                    .frame(minWidth: 220, maxWidth: 420, maxHeight: max(h * 0.33, 360))
                } //: Lazy Grid
            } //: VStack
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .navigationTitle("Confirm Sale")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
//                vm.fetchCompany()
                guard let c = companies.first else {
                    print("No company found")
                    return
                }
                
                self.companyName = c.name
                self.taxRate = c.taxRate
                self.saleNumber = sales.count + 1
            }
        } //: Geometry Reader
    } //: Body
    
}


//#Preview {
//    NavigationStack {
//        ConfirmSaleView()
//            .navigationTitle("Confirm Sale")
//            .environmentObject(PointOfSaleViewModel())
//    }
//}
