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
        VStack(spacing: 8) {
            // MARK: - Department Picker
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    Button("All", action: { departmentTapped(nil) })
                        .modifier(DepartmentButtonMod(isSelected: selectedDepartment == nil))
                        .tag(DepartmentEntity?.none)
                    
                    ForEach(departments) { dept in
                        Button(dept.name, action: { departmentTapped(dept) })
                            .modifier(DepartmentButtonMod(isSelected: selectedDepartment == dept))
                            .tag(dept)
                    }
                } //: Lazy H Stack
                .padding(.horizontal, 6)
                .pickerStyle(.segmented)
            } //: Scroll View
            .background(Color.accentColor.opacity(0.007))
            .frame(maxHeight: 48)

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
            .padding(.horizontal, 8)
            .frame(maxHeight: .infinity)
        } //: VStack
        .overlay(navService.sidebarVis == nil ? checkoutButton : nil, alignment: .bottom)
        .navigationTitle("New Sale")
    } //: Body
    
    private var checkoutButton: some View {
        Button {
            vm.checkoutTapped {
                navService.path.append(LSXDisplay.confirmSale)
            }
        } label: {
            HStack {
                Image(systemName: "cart")
                Text("Checkout")
                Spacer()
                Text(vm.total.toCurrencyString())
            }
            .padding(.horizontal, 8)
            .frame(maxWidth: 260, maxHeight: 32)
        }
        .font(.system(.subheadline, design: .rounded, weight: .semibold))
        .buttonStyle(ThemeButtonStyle())
        .padding()
    }
    
    struct DepartmentButtonMod: ViewModifier {
        let isSelected: Bool
        func body(content: Content) -> some View {
            content
                .font(.headline)
                .foregroundStyle(isSelected ? Color.bg : Color.accent)
                .fontWeight(isSelected ? .semibold : .regular)
                .fontDesign(.rounded)
                .frame(minWidth: 56)
//                .foregroundStyle(.accent)
                .opacity(isSelected ? 1.0 : 0.8)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? .accent : .clear)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(.accent, lineWidth: 1)
                )
//                .overlay(isSelected ? Capsule().fill(.accent).frame(height: 3.5) : nil, alignment: .bottom)
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
