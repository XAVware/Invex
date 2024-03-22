//
//  CartViewNew.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/19/24.
//

import SwiftUI


enum CartState {
    case hidden
    case sidebar
    case confirming
}

struct CartViewNew: View {
    
    @EnvironmentObject var makeASaleVM: MakeASaleViewModel
    
    @Binding var cartState: CartState
    @Binding var menuState: MenuState
    
    @State var origWidth: CGFloat = 0
    var body: some View {
        GeometryReader { geo in
            VStack {

                VStack {
                    
                    ForEach(makeASaleVM.cartItems, id: \.id) { item in
                        
                        VStack(alignment: .leading, spacing: 16) {
                            
                            HStack {
                                Text(item.name ?? "Empty")
                                    .font(.headline)
                                
                                Spacer()
                                
                                Text((item.retailPrice ?? -5).formatAsCurrencyString())
                                    .font(.subheadline)
                            } //: HStack
                            
                            HStack(spacing: 24) {
                                Spacer()
                                
                                Image(systemName: "trash")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 12, height: 12)
                                
                                HStack(spacing: 0) {
                                    
                                    Button {
                                        
                                        item.qtyInCart? -= 1
                                    } label: {
                                        Image(systemName: "minus")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(6)
                                            .frame(width: 24, height: 24)
                                    }
                                    
                                    Divider()
                                    
                                    Text("\(item.qtyInCart ?? -1)")
                                        .font(.subheadline)
                                        .frame(width: 48)
                                    
                                    Divider()
                                    
                                    Button {
                                        item.qtyInCart? += 1
                                    } label: {
                                        Image(systemName: "plus")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(6)
                                            .frame(width: 24, height: 24)
                                    }
                                    
                                } //: HStack
                                .background(Color("Purple050").opacity(0.5))
                                .background(.ultraThinMaterial)
                                .frame(height: 24)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                
                            } //: HStack
                            
                        } //: VStack
                        .frame(maxWidth: 350, maxHeight: 72, alignment: .leading)
                    } //: For Each
                    Spacer()
                } //: VStack
                .padding(.vertical)
                .frame(maxHeight: .infinity)
                
                Spacer()
                
                VStack {
                    HStack {
                        Text("Total:")
                        Spacer()
                        Text("$10.00")
                    } //: HStack
                    .font(.headline)
                    
                    
                } //: VStack
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 54)
                
                Button {
                    
                } label: {
                    Text("Checkout")
                }
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(maxWidth: 420, maxHeight: 54)
                .background(.ultraThinMaterial)
                .background(Theme.primaryColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .opacity(geo.size.width / origWidth)
            .onAppear {
                origWidth = geo.size.width
            }
        }
    }
    
}

#Preview {
    CartViewNew(cartState: .constant(.sidebar), menuState: .constant(.open))
        .environmentObject(MakeASaleViewModel())
    
}
