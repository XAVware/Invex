//
//  Menu.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/19/24.
//

import SwiftUI

enum MenuState { case open, compact, closed }

struct Menu: View {
    @Binding var display: DisplayState
    @Binding var menuState: MenuState
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            ForEach(MenuButton.allCases, id: \.self) { data in
                if data == MenuButton.lock { Spacer() }
                Button {
                    display = data.display
                } label: {
                    MenuButtonLabel(menuState: $menuState, buttonData: data)
                        .foregroundStyle(data.display == display ? .white : Color("Purple200"))
                }
                .overlay(
                    data.display == display ?
                    HStack {
                        Spacer()
                        RoundedCorner(radius: 8, corners: [.topLeft, .bottomLeft])
                            .fill(.white)
                            .frame(width: 6)
                    } //: HStack
                    : nil
                )
            } //: For Each
            
        } //: VStack
        .background(Color("Purple800"))
        
    }
    
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
        
        var display: DisplayState {
            return switch self {
            case .dashboard:        .makeASale
            case .makeASale:        .makeASale
            case .inventoryList:    .inventoryList
            case .salesHistory:     .salesHistory
            case .settings:         .settings
            case .lock:             .lockScreen
                
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
}

#Preview {
    Menu(display: .constant(.makeASale), menuState: .constant(.compact))
}
