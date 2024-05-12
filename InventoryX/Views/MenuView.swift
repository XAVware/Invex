//
//  Menu.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/19/24.
//

import SwiftUI

struct MenuView: View {
    @Binding var display: DisplayState
    @Binding var menuState: MenuState
    let toggleMenu: (() -> Void)
    
    @State var showingLockScreen: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            /// Don't show this button when the menu is closed because the menu button is
            /// being overlayed. Placing the menu button in an HStack with a Spacer improves
            /// the animation when changing state.
            if menuState == .open || menuState == .compact {
                HStack {
                    if menuState == .open {
                        Spacer()
                    }
                    
                    Button {
                        toggleMenu()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                    .font(.title)
                    .fontDesign(.rounded)
                    .foregroundStyle(Color("lightAccent"))
                    .padding()
                } //: HStack
            }
            
            Spacer()
            
            ForEach(DisplayState.allCases, id: \.self) { data in
                Button {
                    if display == data {
                        menuState = .closed
                    } else {
                        display = data
                    }
                } label: {
                    HStack(spacing: 16) {
                        if menuState == .open {
                            Text(data.menuButtonText)
                            Spacer()
                        }
                        
                        Image(systemName: data.menuIconName)
                        RoundedCorner(radius: 8, corners: [.topLeft, .bottomLeft])
                            .fill(Color("lightAccent"))
                            .frame(width: 6)
                            .opacity(data == display ? 1 : 0)
                            .offset(x: 3)
                    }
                    .modifier(MenuButtonMod(isSelected: data == display))
                }
                
            } //: For Each
            
            Spacer()
            
            Button {
                showingLockScreen = true
            } label: {
                HStack(spacing: 16) {
                    if menuState == .open {
                        Text("Lock")
                        Spacer()
                    }
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
        .frame(width: menuState.idealWidth)
        .background(.accent)
        .fullScreenCover(isPresented: $showingLockScreen) {
            LockScreenView()
                .frame(maxHeight: .infinity)
                .background(Color("bgColor"))
        }
        
    }
    
}

#Preview {
    MenuView(display: .constant(.makeASale), menuState: .constant(.compact)) { }
}

