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

enum SidebarState {
    case hidden
    case showing
}

struct POSView: View {
    @Environment(NavigationService.self) var navService
    @EnvironmentObject var vm: PointOfSaleViewModel
    
    @ObservedResults(DepartmentEntity.self) var departments
    
    /// When `selectedDepartment` is nil, the app displays all items in the view.
    @State var selectedDepartment: DepartmentEntity?
    
    func departmentTapped(_ department: DepartmentEntity?) {
        selectedDepartment = department
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Department Picker
            ScrollView(.horizontal, showsIndicators: false) {
                Picker("Department", selection: $selectedDepartment) {
                    Button("All", action: { departmentTapped(nil) })
                        .modifier(DepartmentButtonMod(isSelected: selectedDepartment == nil))
                        .tag(DepartmentEntity?.none)
                    
                    ForEach(departments) { dept in
                        Button(dept.name, action: { departmentTapped(dept) })
                            .modifier(DepartmentButtonMod(isSelected: selectedDepartment == dept))
                            .tag(dept)
                    }
                } //: Picker
                .padding(.horizontal)
                .pickerStyle(.segmented)
                .background(Color.bg)

            } //: Scroll View

            /// When 'All' is selected, `selectedDepartment` is nil and all items are displayed.
            TabView(selection: $selectedDepartment) {
                ItemGridView(department: nil) {
                    vm.adjustStock(of: CartItem(from: $0), by: 1)
                }.tag(DepartmentEntity?.none)
                
                ForEach(departments) { dept in
                    ItemGridView(department: dept) { item in
                        vm.adjustStock(of: CartItem(from: item), by: 1)
                    }.tag(dept)
                }
            } //: Tab View
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding()
            .frame(maxHeight: .infinity)
        } //: VStack
        .overlay(navService.sidebarVisibility == nil ? checkoutButton : nil, alignment: .bottom)
        .navigationTitle("New Sale")
    } //: Body
    
    private var checkoutButton: some View {
        Button {
            vm.checkoutTapped {
                navService.path.append(LSXDisplay.confirmSale(vm.cartItems))
            }
        } label: {
            HStack {
                Image(systemName: "cart")
                Text("Checkout")
                Spacer()
                Text(vm.total.toCurrencyString())
            }
            .padding(.horizontal, 4)
            .frame(maxWidth: 320, maxHeight: 26)
        }
        .font(.subheadline)
        .fontWeight(.semibold)
        .fontDesign(.rounded)
        .buttonStyle(ThemeButtonStyle())
        .padding()
    }
    
    struct DepartmentButtonMod: ViewModifier {
        let isSelected: Bool
        func body(content: Content) -> some View {
            content
                .font(.headline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundStyle(.accent)
                .opacity(isSelected ? 1.0 : 0.9)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .overlay(isSelected ? Rectangle().fill(.accent).frame(height: 3) : nil, alignment: .bottom)
        }
    }
    
}

//struct PrimaryOverlayButton<Label: View>: View {
//    let action: () -> Void
//    let label: Label
//    
//    init(action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
//        self.action = action
//        self.label = label()
//    }
//    
//    var body: some View {
//        Button(action: action) {
//            label
//                .padding(.horizontal, 4)
//                .frame(maxWidth: 320, maxHeight: 26)
//        }
//        .font(.subheadline)
//        .fontWeight(.semibold)
//        .fontDesign(.rounded)
//        .buttonStyle(ThemeButtonStyle())
//        //        .padding()
////        .shadow(radius: 1.5)
//        
//    }
//}

#Preview {
    POSView()
        .environmentObject(PointOfSaleViewModel())
        .environment(NavigationService())
        .environment(\.realm, DepartmentEntity.previewRealm)
}
