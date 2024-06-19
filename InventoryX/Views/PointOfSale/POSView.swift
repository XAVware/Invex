//
//  PointOfSaleView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/26/24.
//

import SwiftUI
import RealmSwift
import Algorithms

struct POSView: View {
    @Environment(\.horizontalSizeClass) var horSize
    @Environment(\.verticalSizeClass) var verSize
    @EnvironmentObject var vm: PointOfSaleViewModel
    @ObservedResults(ItemEntity.self) var items
    @ObservedResults(DepartmentEntity.self) var departments
    /// When `selectedDepartment` is nil, the app displays all items in the view.
    @State var selDept: DepartmentEntity?
    let colSpacing: CGFloat = 16
    let rowSpacing: CGFloat = 16
    
    var body: some View {
        HStack {
            VStack(spacing: horSize == .compact ? 16 : 24) {
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
                
                ItemGridView(items: selDept != nil ? Array(selDept?.items ?? .init()) : Array(items)) { item in
                    vm.addItemToCart(item)
                }
                
            } //: VStack
            .padding(.horizontal)
            .animation(.interpolatingSpring, value: true)

            
            if horSize == .regular {
                CartSidebarView(vm: vm, ignoresTopBar: true)
                    .frame(maxWidth: vm.cartDisplayMode.idealWidth)
                    .clipShape(RoundedCorner(radius: 24, corners: [.topLeft, .bottomLeft]))
                    .shadow(radius: 4)
                    .offset(x: vm.cartDisplayMode == .hidden ? 320 : 0)
                    .ignoresSafeArea()
            }
        } //: HStack
        .onAppear {
            if horSize == .regular {
                vm.showCartSidebar()
            } else {
                vm.hideCartSidebar()
            }
        }
        
    } //: Body
    
    
}

#Preview {
    POSView()
        .environmentObject(PointOfSaleViewModel())
        .environment(\.realm, DepartmentEntity.previewRealm)
}


