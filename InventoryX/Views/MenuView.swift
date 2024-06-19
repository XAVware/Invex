//
//  Menu.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/19/24.
//

import SwiftUI

struct MenuView: View {    
    // This could be causing lock screen to dismiss on orientation change.
    @State var showingLockScreen: Bool = false
    
    let menuButtons: [DisplayState] = [.makeASale, .inventoryList, .settings]
    
    func getButtonData(for display: DisplayState) -> (String, String) {
        return switch display {
        case .makeASale:        ("Sale", "cart.fill")
        case .inventoryList:    ("Inventory", "tray.full.fill")
        case .settings:         ("Settings", "gearshape")
        default:                ("","")
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            ForEach(menuButtons, id: \.self) { display in
                Button {
                    LazySplitService.shared.changeDisplay(to: display)
                } label: {
                    HStack(spacing: 16) {
                        let data = getButtonData(for: display)
                        Text(data.0)
                        Spacer()
                        Image(systemName: data.1)
                        RoundedCorner(radius: 8, corners: [.topLeft, .bottomLeft])
                            .fill(Color("lightAccent"))
                            .frame(width: 6)
                            .opacity(display == LazySplitService.shared.primaryRoot ? 1 : 0)
                            .offset(x: 3)
                    }
                    .modifier(MenuButtonMod(isSelected: display == LazySplitService.shared.primaryRoot))
                }
                
            } //: For Each

            Spacer()
            
            Button {
                showingLockScreen = true
            } label: {
                HStack(spacing: 16) {
                    Text("Lock")
                    Spacer()
                    Image(systemName: "lock")
                    RoundedCorner(radius: 8, corners: [.topLeft, .bottomLeft])
                        .fill(Color("lightAccent"))
                        .frame(width: 6)
                        .opacity(0)
                        .offset(x: 3)
                } //: HStack
                .modifier(MenuButtonMod(isSelected: false))
            }
            
        } //: VStack
        .background(.lightAccent)
        .fullScreenCover(isPresented: $showingLockScreen) {
            LockScreenView()
                .frame(maxHeight: .infinity)
                .background(Color("bgColor"))
        }
        
    }
    
    struct MenuButtonMod: ViewModifier {
        let isSelected: Bool
        func body(content: Content) -> some View {
            content
                .font(.headline)
                .fontDesign(.rounded)
                .padding(.leading)
                .padding(.vertical, 8)
                .frame(maxHeight: 64)
    //            .foregroundStyle(isSelected ? .white : Color("bgColor").opacity(0.6))
                .foregroundStyle(.accent.opacity(isSelected ? 1.0 : 0.6))
        }
    }
    
}

#Preview {
    MenuView()
}
