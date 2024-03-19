//
//  CartView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 6/5/23.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var vm: MakeASaleViewModel
    
    var body: some View {
        if vm.isConfirmingSale {
            confirmSaleView
        } else {
            cartView
                .background(Theme.primaryBackground)            
        }
    } //: Body
    
    private var headerToolbar: some View {
        HStack(spacing: 24) {
            Spacer()
            Text("Sale")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .modifier(TextMod(.title3, .semibold, .white))
            
        } //: HStack
        .modifier(TextMod(.body, .light, Theme.primaryBackground))
        .frame(height: toolbarHeight)
        .padding(.horizontal)
    } //: Header Toolbar
    
    private var cartView: some View {
        GeometryReader { geo in
            VStack {
                headerToolbar
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
                        .modifier(TextMod(.body, .semibold, Theme.lightFgColor))
                    
                    Spacer()
                    
                    Text(vm.cartSubtotal.formatAsCurrencyString())
                        .modifier(TextMod(.title3, .semibold, Theme.lightFgColor))
                } //: HStack
                .padding(.vertical, 8)
                
                Button {
                    vm.checkoutTapped()
                } label: {
                    Text("Check Out")
                        .frame(maxWidth: .infinity)
                }
                .modifier(TextMod(.title3, .semibold, Theme.lightFgColor))
                .padding(12)
                .foregroundColor(Theme.darkFgColor)
                .background(Theme.selectedButtonColor)
                .cornerRadius(25)
                
                Spacer().frame(height: 24)
                
            } //: VStack
            .padding(.horizontal)
            .background(Theme.primaryBackground)
//            .onChange(of: geo.size.width) { newValue in
//                print(newValue)
//            }
        } //: GeometryReader
    } //: CartView
    
    private var confirmSaleView: some View {
        GeometryReader { geo in
            VStack(spacing: 32) {
                VStack(spacing: 8) {
                    Text("Amount Due:")
                        .modifier(TextMod(.largeTitle, .semibold, Theme.lightFgColor))
                    
                    Text(vm.cartSubtotal.formatAsCurrencyString())
                        .modifier(TextMod(.system(size: 48), .semibold, Theme.lightFgColor))
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
                    .modifier(TextMod(.callout, .regular, Theme.lightFgColor))
                    
                    Divider().background(Theme.lightFgColor)
                    
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
                                .modifier(TextMod(.callout, .semibold, Theme.lightFgColor))
                                .frame(height: 30)
                                
                                Divider().background(Theme.secondaryBackground).opacity(0.3)
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
                            .modifier(TextMod(.body, .regular, Theme.lightFgColor))
                            .padding()
                    }
                } //: VStack

            } //: VStack
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical)
        } //: Geometry Reader
    } //: Confirm Sale View
}

struct CartView_Previews: PreviewProvider {
    @State static var navMan: NavigationManager = NavigationManager()
    static var previews: some View {
        CartView()
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
            .previewInterfaceOrientation(.landscapeLeft)
            .environmentObject(MakeASaleViewModel())
    }
}
