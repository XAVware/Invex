//
//  PointOfSaleView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/26/24.
//

import SwiftUI
import RealmSwift
import Algorithms

/*
 8.29.24 - A warning is being thrown for breaking constraints on startup on regular width devices. I thought it was related to POSView but it only happens when OnboardingView is being displayed as a full screen cover. Going to toggle onboarding with an optional isOnboarding variable in the root.
 
 */

struct POSView: View {
    @Environment(\.horizontalSizeClass) var hSize
    @Environment(\.verticalSizeClass) var vSize
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var vm: PointOfSaleViewModel
    
    @ObservedResults(ItemEntity.self) var items
    @ObservedResults(DepartmentEntity.self) var departments
    
    /// When `selectedDepartment` is nil, the app displays all items in the view.
    @State var selDept: DepartmentEntity?
    let colSpacing: CGFloat = 16
    let rowSpacing: CGFloat = 16
    
    @State var showCartAlert: Bool = false
    
//    @Binding var cartItems: Binding<[CartItem]> = []
    
    func continueTapped() {
        if vm.cartItems.isEmpty {
            showCartAlert.toggle()
        } else {
            LSXService.shared.update(newDisplay: .confirmSale(vm.saleItems))
        }
    }
    
    
    var body: some View {
        GeometryReader { geo in
            let isLandscape: Bool = geo.size.width > geo.size.height
            let isHorizontalLayout: Bool = isLandscape || hSize == .regular
            HStack {
                ZStack(alignment: .center) {
                    NeomorphicCardView(layer: .under)
                    
                    VStack(spacing: 0) {
                        // MARK: - Department Picker
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                Button {
                                    selDept = nil
                                } label: {
                                    Text("All")
                                        .modifier(DepartmentButtonMod(isSelected: selDept == nil))
                                }
                                
                                ForEach(departments) { department in
                                    Button {
                                        selDept = department
                                    } label: {
                                        Text(department.name)
                                            .modifier(DepartmentButtonMod(isSelected: selDept == department))
                                    }
                                } //: For Each
                            } //: HStack
                        } //: Scroll View
                        .padding(vSize == .regular ? 12 : 8)
                        
                        ItemGridView(items: selDept != nil ? Array(selDept?.items ?? .init()) : Array(items)) { item in
                            vm.addItemToCart(CartItem(from: item))
                        }
                    } //: VStack
                    .padding(.horizontal, hSize == .regular ? 12 : 4)
                    .animation(.interpolatingSpring, value: true)
                    
                } //: ZStack
                .padding(.bottom, !isHorizontalLayout ? 48 : 0)
                .frame(maxWidth: .infinity)
                
                // MARK: - Cart Sidebar
                if isHorizontalLayout {
                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(
                                .shadow(.inner(color: .neoUnderDark, radius: 3, x: 1, y: 1))
                                .shadow(.inner(color: .neoUnderLight, radius: 2, x: -3, y: -2))
                            )
                            .foregroundColor(.neoUnderBg)
                            .overlay(
                                Color.accent.opacity(0.02)
                                    .clipShape(RoundedRectangle(cornerRadius: 18))
                                
                            )
                        
                        VStack {
                            HStack {
                                Image(systemName: "cart")
                                Text("Cart")
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding([.top, .horizontal])
                            .font(.headline)
                            .foregroundStyle(.accent)
                            .opacity(0.8)
                            
                            
                            List(vm.saleItems) { item in
                                CartItemView(item: item, qty: item.qtyInCart)
                                    .listRowBackground(Color.clear)
                                    .environmentObject(vm)
                            }
                            .frame(maxHeight: .infinity)
                            .listStyle(PlainListStyle())

                            
                            
                            // MARK: - Cart Totals
                            VStack(alignment: .leading, spacing: 16) {
                                VStack(spacing: 4) {
                                    HStack {
                                        Text("Subtotal:")
                                        Spacer()
                                        Text("\(vm.cartSubtotal.formatAsCurrencyString())")
                                    } //: HStack
                                    
                                    HStack {
                                        Text("Tax:")
                                        Spacer()
                                        Text("\(vm.taxAmount.formatAsCurrencyString())")
                                    } //: HStack
                                } //: VStack
                                .font(.subheadline)
                                .padding(8)
                                
                                Button(action: continueTapped) {
                                    HStack {
                                        Text("Checkout")
                                            .frame(maxWidth: .infinity)
                                        Text(vm.total.formatAsCurrencyString())
                                    }
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .fontDesign(.rounded)
                                }
                                .buttonStyle(ThemeButtonStyle())
                                
                            } //: VStack
                            .padding()
                        } //: VStack
                        .alert("Your cart is empty.", isPresented: $showCartAlert) {
                            Button("Okay", role: .cancel) { }
                        }
                    } //: ZStack
                    .frame(maxWidth: vm.cartDisplayMode.idealWidth)
                    .offset(x: vm.cartDisplayMode == .hidden ? 320 : 0)
                    .ignoresSafeArea(edges: [.bottom])
                }
            } //: HStack
            .padding(.bottom)
            .padding(.horizontal, hSize == .regular ? 12 : 4)
            .background(.bg)
            .navigationBarTitleDisplayMode(.inline)
            .overlay(!isHorizontalLayout ? checkoutButton : nil, alignment: .bottom)
            //TODO: Company data doesn't need to be fetched every time this appears. Just save it in POS VM
            .onAppear {
                vm.fetchCompany()
                if hSize == .regular {
                    vm.showCartSidebar()
                } else {
                    vm.hideCartSidebar()
                }
            }
            .toolbar {
                // Only show cart toolbar button when menu isn't open
                ToolbarItem(placement: .topBarTrailing) {
                    if hSize == .regular {
                        Button {
                            if vm.cartDisplayMode == .hidden {
                                vm.showCartSidebar()
                            } else {
                                vm.hideCartSidebar()
                            }
                        } label: {
                            Image(systemName: "chevron.forward.2")
                        }
                    } else {
                        EmptyView()
                    }
                }
            }
            
        } //: Geometry Reader
        
    } //: Body
    
    private var checkoutButton: some View {
        Button(action: continueTapped) {
            HStack {
                Text("Checkout")
                Spacer()
                Text(vm.total.formatAsCurrencyString())
                    .frame(maxWidth: .infinity, maxHeight: 32)
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
        }
//        .padding(.horizontal)
        .buttonStyle(ThemeButtonStyle())
    }
    
    
}

#Preview {
    POSView()
        .environmentObject(PointOfSaleViewModel())
        .environment(\.realm, DepartmentEntity.previewRealm)
}
