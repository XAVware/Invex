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
    @Environment(\.horizontalSizeClass) var hSize
    @Environment(\.verticalSizeClass) var vSize
    @EnvironmentObject var vm: PointOfSaleViewModel
    
    @ObservedResults(CompanyEntity.self) var companies
    @ObservedResults(SaleEntity.self) var sales
    @ObservedResults(ItemEntity.self) var realmItems
    
    @State var companyName: String = ""
    @State var saleNumber: Int = -2
    @State var taxRate: Double = 0
    
//    var cartSubtotal: Double { vm.cartItems.reduce(0) { $0 + $1.retailPrice } }
//    var taxAmount: Double { cartSubtotal * taxRate / 100 }
//    var total: Double { cartSubtotal + taxAmount }
    
    /// Finalizes the sale by adding the sale to Realm and updating ItemEntity quantities on hand.
    func finalizeSale() {
        vm.cartItems.removeAll(where: { $0.qtyInCart == 0 })
        guard !vm.cartItems.isEmpty else {
            navService.path.removeLast()
            return
        }
        
        let newSale = SaleEntity(timestamp: Date(), total: vm.total)
        let saleItems = vm.cartItems.map { $0.convertToSaleItem() }
        newSale.items.append(objectsIn: saleItems)
        $sales.append(newSale)
        
        Task {
            try await updateStock(cartItems: vm.cartItems)
            vm.clearCart()
            navService.path.removeLast()
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
        }
    }
    
    var body: some View {
        
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let isLandscape: Bool = w > h
            HStack(alignment: isLandscape ? .center : .top) {
                // MARK: - Receipt View
                VStack(spacing: 0) {
                    HStack {
                        Text("Cart")
                            .font(.headline)
                        Spacer()
                        Text("\(companyName)")
                        Spacer()
                        Text("Sale #\(saleNumber)")
                            .fontWeight(.light)
                    } //: HStack
                    .padding()
                    .background(Color.bg300)
                    
                    Divider()
                    
                    List(vm.cartItems) { item in
                        CartItemView(item: item, qty: item.qtyInCart)
                            .listRowBackground(Color.clear)
                            .padding(.vertical)
                    }
                    .listStyle(PlainListStyle())
                    .environmentObject(vm)
                    .frame(height: isLandscape ? h : h * 0.65)
//                    Spacer()
                } //: VStack
                .font(.subheadline)
                .background(Color.bg200.clipShape(RoundedRectangle(cornerRadius: 8)))
                .roundedCornerWithBorder(lineWidth: 1, borderColor: Color.shadow100, radius: 8, corners: [.allCorners])
                
                if isLandscape {
                    summary
                }
            } //: VStack
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .overlay(isLandscape ? nil : summary, alignment: .bottom)
            .padding()
            .background(Color.bg)
            .navigationTitle("Confirm Sale")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                guard let c = companies.first else { return }
                self.companyName = c.name
                self.taxRate = c.taxRate
                self.saleNumber = sales.count + 1
            }
        } //: Geometry Reader
    } //: Body
    
    // MARK: - Summary View
    private var summary: some View {
        VStack(spacing: 16) {
            let isCondensed: Bool = hSize == .compact || vSize == .compact
            VStack(alignment: .leading) {
                if !isCondensed {
                    Text("Order Summary")
                        .fontWeight(.semibold)
                        .font(vSize == .regular ? .title2 : .title3)
                        .padding(.bottom)
                }
                
                VStack(spacing: 16) {
                    HStack {
                        Text("Subtotal:")
                        Spacer()
                        Text("\(vm.cartSubtotal.toCurrencyString())")
                    } //: HStack
                    
                    HStack {
                        Text("Tax:")
                        Spacer()
                        Text("\(vm.taxAmount.toCurrencyString())")
                    } //: HStack
                } //: VStack
                .font(.subheadline)
                
                Divider()
                
                HStack {
                    Text("Total:")
                    Spacer()
                    Text(vm.total.toCurrencyString())
                } //: HStack
                .fontWeight(.semibold)
                .font(.title3)
                .padding(.vertical, 4)
                
                
            } //: VStack
            .padding()
            .background(Color.bg200.clipShape(RoundedRectangle(cornerRadius: 12)))
            .roundedCornerWithBorder(lineWidth: 1, borderColor: Color.shadow100, radius: 8, corners: [.allCorners])
            
            Button(action: finalizeSale) {
                Text("Confirm Sale").frame(maxWidth: .infinity)
            }
            .buttonStyle(ThemeButtonStyle())
            .padding(.vertical, 8)
            
        } //: VStack - Order Summary
        .frame(minWidth: 220, maxWidth: 420/*, maxHeight: max(h * 0.33, 320)*/)
    }
    
}


#Preview {
    NavigationStack {
        ConfirmSaleView()
            .navigationTitle("Confirm Sale")
            .environmentObject(PointOfSaleViewModel())
            .environment(NavigationService())
    }
}
