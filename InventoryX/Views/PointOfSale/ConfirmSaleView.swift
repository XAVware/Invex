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
    @EnvironmentObject var vm: PointOfSaleViewModel
    
    func continueTapped() {
        guard !vm.cartItems.isEmpty else { return }
        Task {
            do {
                try await vm.finalizeSale()
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
                            Text("Sale #\(vm.calcNextSaleNumber())")
                            Spacer()
                        }
                        
                        Text("\(vm.companyName)")
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 16) {
                                ForEach(vm.uniqueItems) { item in
                                    let itemQty = vm.cartItems.filter { $0._id == item._id }.count
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
                                    Text("\(vm.cartSubtotal.formatAsCurrencyString())")
                                } //: HStack
                                
                                HStack {
                                    Text("Tax: (\(vm.taxRate.toPercentageString())%)")
                                    Spacer()
                                    Text("\(vm.taxAmount.formatAsCurrencyString())")
                                } //: HStack
                            } //: VStack
                            .font(.subheadline)
                            
                            Divider()
                            
                            HStack {
                                Text("Total:")
                                Spacer()
                                Text(vm.total.formatAsCurrencyString())
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
                vm.fetchCompany()
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
