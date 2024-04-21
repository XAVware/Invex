//
//  Menu.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/19/24.
//

import SwiftUI


// TODO: Pass UI width to closed state to determine if it should be shown as a compact sidebar or disappear entirely
enum MenuState: Equatable {
    case open
    case compact
    case closed
    //    case closed(CGFloat)
    
    var idealWidth: CGFloat {
        switch self {
        case .open:     return 280
        case .compact:  return 64
        case .closed: return 0
            //        case .closed(let viewWidth):   return viewWidth > 840 ? 64 : 0
        }
    }
}

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
                    Spacer()
                    
                    Button {
                        toggleMenu()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                    .font(.title)
                    .fontDesign(.rounded)
                    .foregroundStyle(Color("Purple050").opacity(0.8))
                    .padding()
                } //: HStack
            }
            
            Spacer()
            
            ForEach(DisplayState.allCases, id: \.self) { data in
                Button {
                    display = data
                } label: {
                    HStack(spacing: 16) {
                        if menuState == .open {
                            Text(data.menuButtonText)
                            Spacer()
                        }
                        
                        Image(systemName: data.menuIconName)
                        RoundedCorner(radius: 8, corners: [.topLeft, .bottomLeft])
                            .fill(.white)
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
                        .fill(.white)
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
            ResponsiveView { props in
                LockScreenView(uiProperties: props)
            }
        }
        
    }
    
}

#Preview {
    MenuView(display: .constant(.makeASale), menuState: .constant(.compact)) { }
}

