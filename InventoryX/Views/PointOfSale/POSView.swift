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
    @EnvironmentObject var vm: PointOfSaleViewModel
    
    @ObservedResults(ItemEntity.self) var items
    @ObservedResults(DepartmentEntity.self) var departments
    
    /// When `selectedDepartment` is nil, the app displays all items in the view.
    @State var selDept: DepartmentEntity?
    let colSpacing: CGFloat = 16
    let rowSpacing: CGFloat = 16
    
    @State var showCartAlert: Bool = false
    
    
    func continueTapped() {
        if vm.cartItems.isEmpty {
            showCartAlert.toggle()
        } else {
            LSXService.shared.update(newDisplay: .confirmSale)
        }
    }

    
    var body: some View {
        GeometryReader { geo in
            let isLandscape: Bool = geo.size.width > geo.size.height
            let isHorizontalLayout: Bool = isLandscape || hSize == .regular
            HStack {
                ZStack(alignment: .center) {
                    Color.bg.ignoresSafeArea()
                    
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
                            vm.addItemToCart(item)
                        }
                    } //: VStack
                    .padding(.horizontal, hSize == .regular ? 12 : 4)
                    .animation(.interpolatingSpring, value: true)
                    
                } //: ZStack
                .padding(.bottom, !isHorizontalLayout ? 48 : 0)
                
                if isHorizontalLayout {
                    CartSidebarView(vm: vm, ignoresTopBar: true, width: min(geo.size.width * 0.3, 280))
                }
            } //: HStack
            .padding(.bottom)
            .padding(.horizontal, hSize == .regular ? 12 : 4)
            .background(.bg)
            .navigationBarTitleDisplayMode(.inline)
            .overlay(!isHorizontalLayout ? checkoutButton : nil, alignment: .bottom)
            .onAppear {
                if hSize == .regular {
                    vm.showCartSidebar()
                } else {
                    vm.hideCartSidebar()
                }
            }
//            .toolbar {
//                // Only show cart toolbar button when menu isn't open
//                //            if lsxVM.prefCol != .sidebar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button {
//                        switch hSize {
//                        case .compact:
//                            // On Compact, push confirm sale view with the cart items.
//                            guard !vm.cartItems.isEmpty else {
//                                //                                showCartAlert.toggle()
//                                return
//                            }
//                            LSXService.shared.update(newDisplay: .confirmSale)
//                            
//                        case .regular:
//                            // Toggle between sidebar and hidden display mode.
//                            if vm.cartDisplayMode == .hidden {
//                                vm.showCartSidebar()
//                            } else {
//                                vm.hideCartSidebar()
//                            }
//                            
//                        default: print("Invalid horizontal size class.")
//                        }
//                    } label: {
//                        HStack(spacing: 12) {
//                            Text("\(vm.cartItems.count)")
//                            Image(systemName: "cart")
//                                .frame(width: 18, height: 18)
//                        }
//                        .padding(8)
//                        .padding(.horizontal, 4)
//                        .font(.callout)
//                        .foregroundStyle(Color.white)
//                        .background(Color.accent.opacity(0.95))
//                        .clipShape(Capsule())
//                    }
//                    
//                }
//                //            }
//            }

        } //: Geometry Reader
        
    } //: Body
    
    private var checkoutButton: some View {
        Button(action: continueTapped) {
            HStack {
                Text("Checkout")
                Spacer()
                Text(vm.total.formatAsCurrencyString())
            }
            .frame(maxWidth: .infinity, maxHeight: 32)
            .font(.subheadline)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
        }
            .padding(.horizontal)
            .buttonStyle(ThemeButtonStyle())
    }
    
    
}

#Preview {
    POSView()
        .environmentObject(PointOfSaleViewModel())
        .environment(\.realm, DepartmentEntity.previewRealm)
}
