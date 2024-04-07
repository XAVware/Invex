//
//  ToolbarView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/21/24.
//

import SwiftUI

struct ToolbarView: View {
    @Binding var menuState: MenuState
    @Binding var cartState: CartState
    @Binding var display: DisplayState
    
    @State var showAddDepartment: Bool = false
    @State var showAddItem: Bool = false
    
    func toggleCart() {
        withAnimation(.smooth) {
            cartState = cartState == .hidden ? .sidebar : .hidden
        }
    }
    
    func toggleMenu() {
        withAnimation(.smooth) {
            menuState = switch menuState {
            case .open: MenuState.compact
            case .compact: MenuState.open
            case .closed: MenuState.open
            }
        }
    }
    
    // TODO: Make this more dynamic.
    var body: some View {
        HStack(spacing: 32) {
            Button {
                toggleMenu()
            } label: {
                Image(systemName: menuState == MenuState.open ? "chevron.backward.2" : "line.3.horizontal")
            }
            
            Spacer()
            
            if display == .makeASale {
                Button {
                    toggleCart()
                } label: {
                    Image(systemName: "cart")
                }
            }
        } //: HStack
        .font(.title)
        .fontDesign(.rounded)
    } //: Toolbar
}

#Preview {
    ToolbarView(menuState: .constant(.compact), cartState: .constant(.sidebar), display: .constant(.makeASale))
        .padding()
}
