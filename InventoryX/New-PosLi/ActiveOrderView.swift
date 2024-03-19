//
//  ActiveOrderView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/16/24.
//

import SwiftUI
import RealmSwift

enum ViewStates: CaseIterable {
    case dashboard, makeASale, inventoryList, salesHistory, settings
    
    var menuButtonText: String {
        return switch self {
        case .dashboard:        "Dashboard"
        case .makeASale:        "Sale"
        case .inventoryList:    "Inventory"
        case .salesHistory:     "Sales"
        case .settings:         "Settings"
        }
    }
    
    var menuIconName: String {
        return switch self {
        case .dashboard:        "square.grid.2x2.fill"
        case .makeASale:        "dollarsign.circle.fill"
        case .inventoryList:    "list.bullet.clipboard.fill"
        case .salesHistory:     "chart.xyaxis.line"
        case .settings:         "gearshape"
        }
    }
}

@MainActor class ViewService: ObservableObject {
    @Published var currentDisplay: DisplayStates = .makeASale
}

struct ActiveOrderView: View {
    
    @StateObject var viewService = ViewService()
    @StateObject var makeASaleVM = MakeASaleViewModel()
    
    @ObservedResults(DepartmentEntity.self) var departments
    @State var selectedDepartment: DepartmentEntity?
    
    @State var showCart: Bool = true
    
    enum ViewStyle: String, CaseIterable {
        case grid = "square.grid.2x2.fill"
        case list = "list.dash"
    }
    
    @State var viewStyle: ViewStyle = .grid
    
    func toggleCart() {
        self.showCart.toggle()
    }
    
    var body: some View {
        ResponsiveView { layoutProperties in
            HStack {
                // MARK: - MENU VIEW
                VStack(spacing: 16) {
                    Spacer()
                    
                    ForEach(MenuButton.allCases, id: \.self) { data in
                        if data == MenuButton.lock { Spacer() }
                        Button {
//                                viewService.currentDisplay = displayState
                        } label: {
                            MenuButtonLabel(menuState: $menuState, buttonData: data)
                                .foregroundStyle(Color("Purple200"))
                        }
                    } //: For Each
                    
                } //: VStack
                .background(Color("Purple800"))
                .frame(maxWidth: menuState == .open ? layoutProperties.width * 0.25 : nil)

                VStack {
                    HStack {
                        Button {
                            toggleMenu()
                        } label: {
                            Image(systemName: menuState == MenuState.open ? "chevron.backward.2" : "line.3.horizontal")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        }
                        
                        Spacer()
                        
                        Picker("Item selection view layout", selection: $viewStyle) {
                            ForEach(ViewStyle.allCases, id: \.self) { style in
                                Image(systemName: style.rawValue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 120)

                        Button {
                            toggleCart()
                        } label: {
                            Image(systemName: "cart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        }
                    } //: HStack
                    ResponsiveView { props in
                        MakeASaleView(viewWidth: props.width)
                            .environmentObject(makeASaleVM)
                        
                    }
                } //: VStack
                .padding()
                
                if showCart {
                    VStack {
                        Text("Cart")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(Theme.primaryColor)
                            .frame(maxWidth: 400, alignment: .leading)
                        
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
                                .padding()
                                .background(Color("Purple050").opacity(0.3))
                                .frame(maxWidth: 350, alignment: .leading)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        } //: VStack
                        .padding(.vertical)
                        
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
                        
                        Button {
                            
                        } label: {
                            Text("Checkout")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .background(Theme.primaryColor)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding()
                    .frame(maxWidth: layoutProperties.width * 0.30)
                    .background(.ultraThinMaterial)
                    //                CartView()
                    //                    .environmentObject(makeASaleVM)
                    //                    .frame(maxWidth: layoutProperties.width * 0.30)
                    // Detail
                }
                
            }
            
        }
    } //: Body
    
    // MARK: - MENU
    enum MenuState { case open, compact, closed }
    @State var menuState: MenuState = .compact
    
    enum MenuButton: String, CaseIterable {
        /// The icon name is assigned to the enum because it appears in compact menu state and open. Whereas the title only displays while open.
        case dashboard      = "rectangle.3.group.fill"
        case makeASale      = "cart.fill"
        case inventoryList  = "tray.full.fill"
        case salesHistory   = "chart.xyaxis.line"
        case settings       = "gearshape"
        case lock           = "lock"
        
        var title: String {
            return switch self {
            case .dashboard:        "Dashboard"
            case .makeASale:        "Sale"
            case .inventoryList:    "Inventory"
            case .salesHistory:     "Sales"
            case .settings:         "Settings"
            case .lock:             "Lock"
            }
        }
        
        // TODO: Can i add the button's destination here? Like:
        // var destination: some View { ... }

    }
    
    struct MenuButtonLabel: View {
        @Binding var menuState: MenuState
        let buttonData: MenuButton
        
        init(menuState: Binding<MenuState>, buttonData: MenuButton) {
            self._menuState = menuState
            self.buttonData = buttonData
        }
        
        var body: some View {
            HStack(spacing: 16) {
                Image(systemName: buttonData.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .padding(.horizontal, 8)
                
                if menuState == .open {
                    Text(buttonData.title)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            } //: HStack
            .padding()
        }
    }
    
    func toggleMenu() {
        menuState = switch menuState {
        case .open: MenuState.compact
        case .compact: MenuState.open
        case .closed: MenuState.open
        }
    }
    
}

#Preview {
    ActiveOrderView()
        .environment(\.realm, DepartmentEntity.previewRealm)
}
