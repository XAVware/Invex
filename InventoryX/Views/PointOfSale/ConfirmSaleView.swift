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
        let realm = try await Realm()
        let newSale = SaleEntity(timestamp: Date(), total: self.total)
        
        try realm.write {
            realm.add(newSale)
            newSale.items.append(objectsIn: cartItems.map { $0.convertToSaleItem() })
            
            try cartItems.forEach { item in
                guard let realmItem = realm.object(ofType: ItemEntity.self, forPrimaryKey: item.id) else { throw AppError.thawingItemError }
                let origQty = realmItem.onHandQty
                realmItem.onHandQty = origQty - item.qtyInCart
                print("Item '\(realmItem.name)' quantity changed: \(origQty) -> \(realmItem.onHandQty)")
            }
            print("Finished saving sale and updating stock. There are \(sales.count) sales.")
            cartItems.removeAll()
        }
        
        
//        for item in cartItems {
////            guard let realmItem = realmItems.first(where: { $0._id == item.id })?.thaw() else { throw AppError.thawingItemError }
//            guard let realmItem = realm.object(ofType: ItemEntity.self, forPrimaryKey: item.id) else { throw AppError.thawingItemError }
//            try realm.write {
//            }
//        }
                
        
        
        /// CartItem is initialized with an ItemEntity but it only stores the properties that it needs. It would be too cumbersome to store all of the ItemEntity properties.
        ///     - The 'live' version of a SaleItemEntity before the sale is finalized.
        /// When the sale is finalized, the CartItems are converted to SaleItems.
        /// ItemEntity and SaleItemEntity are intentionally separate to avoid losing records when an ItemEntity is deleted.
//        let saleItems = Array(cartItems.map( { SaleItemEntity(item: $0) } ))
//        try await RealmActor().saveSale(items: saleItems, total: self.total)
        
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
