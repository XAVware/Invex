//
//  ConfirmSaleView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/21/24.
//

import SwiftUI
import RealmSwift

struct ConfirmSaleView: View {
    @Environment(NavigationService.self) var navService

    @Environment(\.verticalSizeClass) var verSize
    @EnvironmentObject var vm: PointOfSaleViewModel

    @ObservedResults(CompanyEntity.self) var companies
    @ObservedResults(SaleEntity.self) var sales
    @ObservedResults(ItemEntity.self) var realmItems
    
    @State var companyName: String = ""
    @State var saleNumber: Int = -2
    @State var taxRate: Double = 0
//    @State var cartItems: [CartItem]

    var cartSubtotal: Double { vm.cartItems.reduce(0) { $0 + $1.retailPrice } }
    var taxAmount: Double { cartSubtotal * taxRate / 100 }
    var total: Double { cartSubtotal + taxAmount }
        
//    init(cartItems: [CartItem]) {
//        vm.cartItems = cartItems
//    }
    
    /// CartItem is initialized with an ItemEntity but it only stores the properties that it needs.
    ///     - The 'live' version of a SaleItemEntity before the sale is finalized.
    /// When the sale is finalized, the CartItems are converted to SaleItems.
    /// ItemEntity and SaleItemEntity are intentionally separate to avoid losing records when an ItemEntity is deleted.
//    func finalizeSale() async throws {
//        let realm = try await Realm()
//        let newSale = SaleEntity(timestamp: Date(), total: self.total)
//        
//        try realm.write {
//            realm.add(newSale)
//            newSale.items.append(objectsIn: cartItems.map { $0.convertToSaleItem() })
//            
//            try cartItems.forEach { item in
//                guard let realmItem = realm.object(ofType: ItemEntity.self, forPrimaryKey: item.id) else { throw AppError.thawingItemError }
//                let origQty = realmItem.onHandQty
//                realmItem.onHandQty = origQty - item.qtyInCart
//                print("Item '\(realmItem.name)' quantity changed: \(origQty) -> \(realmItem.onHandQty)")
//            }
//            print("Finished saving sale and updating stock. There are \(sales.count) sales.")
//            cartItems.removeAll()
//        }
//    }
    
    /// Finalizes the sale by adding the sale to Realm and updating ItemEntity quantities on hand.
    func finalizeSale() {
        guard !vm.cartItems.isEmpty else { return }

        let newSale = SaleEntity(timestamp: Date(), total: self.total)
        let saleItems = vm.cartItems.map { $0.convertToSaleItem() }
        newSale.items.append(objectsIn: saleItems)
        $sales.append(newSale)
        debugPrint("Finished creating new sale")
        
        Task {
            try await updateStock(cartItems: vm.cartItems)
            vm.clearCart()
            navService.path.removeLast()
            print("Finished saving sale and updating stock. There are \(sales.count) sales.")
        }
    }
    
    func updateStock(cartItems: [CartItem]) async throws {
        let realm = try await Realm()
        try cartItems.forEach { item in
            guard let realmItem = realm.object(ofType: ItemEntity.self, forPrimaryKey: item.id) else { throw AppError.thawingItemError }
            let origQty = realmItem.onHandQty
            try realm.write {
                realmItem.onHandQty = origQty - item.qtyInCart
            }
            print("Item '\(realmItem.name)' quantity changed: \(origQty) -> \(realmItem.onHandQty)")
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
                                ForEach(vm.cartItems) { item in
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
                        ZStack {
                            NeomorphicCardView(layer: .under)
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
                            .padding()
//                            .background(Color.bg.opacity(0.6))
//                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        } //ZStack
                        
                        Button(action: finalizeSale) {
                            Text("Confirm Sale").frame(maxWidth: .infinity)
                        }
                        .buttonStyle(ThemeButtonStyle())
                        
                    } //: VStack - Order Summary
                    .frame(minWidth: 220, maxWidth: 420, maxHeight: max(h * 0.33, 360))
                } //: Lazy Grid
            } //: VStack
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color.bg)
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


#Preview {
    NavigationStack {
        ConfirmSaleView(/*cartItems: [CartItem(from: ItemEntity.item1)]*/)
            .navigationTitle("Confirm Sale")
            .environmentObject(PointOfSaleViewModel())
    }
}
