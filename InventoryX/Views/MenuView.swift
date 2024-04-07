//
//  Menu.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/19/24.
//

import SwiftUI

enum MenuState { case open, compact, closed }

struct MenuView: View {
    @Binding var display: DisplayState
    @Binding var menuState: MenuState
    
    @State var showingLockScreen: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            ForEach(DisplayState.allCases, id: \.self) { data in
                Button {
                    display = data
                } label: {
                    MenuButtonLabel(menuState: $menuState, buttonData: data)
                        .foregroundStyle(data == display ? .white : Color("Purple200"))
                }
                .overlay(
                    data == display ?
                    HStack {
                        Spacer()
                        RoundedCorner(radius: 8, corners: [.topLeft, .bottomLeft])
                            .fill(.white)
                            .frame(width: 6)
                    } //: HStack
                    : nil
                )
            } //: For Each
            
            Spacer()
            
            Button {
                showingLockScreen = true
            } label: {
                HStack(spacing: 16) {
                    Image(systemName: "lock")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .padding(.horizontal, 8)
                    
                    if menuState == .open {
                        Text("Lock")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                } //: HStack
                .padding()
                .foregroundStyle(Color("Purple200"))
            }
            
        } //: VStack
        .fullScreenCover(isPresented: $showingLockScreen) {
            LockScreenView()
        }
        .background(Color("Purple800"))
        
    }
    
    struct MenuButtonLabel: View {
        @Binding var menuState: MenuState
        let buttonData: DisplayState
        
        init(menuState: Binding<MenuState>, buttonData: DisplayState) {
            self._menuState = menuState
            self.buttonData = buttonData
        }
        
        var body: some View {
            HStack(spacing: 16) {
                Image(systemName: buttonData.menuIconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .padding(.horizontal, 8)
                
                if menuState == .open {
                    Text(buttonData.menuButtonText)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            } //: HStack
            .padding()
        }
    }
}

#Preview {
    MenuView(display: .constant(.makeASale), menuState: .constant(.compact))
}
