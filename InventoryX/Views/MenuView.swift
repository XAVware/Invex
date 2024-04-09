//
//  Menu.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/19/24.
//

import SwiftUI

enum MenuState { 
    case open
    case compact
    case closed
    
    var idealWidth: CGFloat {
        switch self {
        case .open:     return 280
        case .compact:  return 72
        case .closed:   return 0
        }
    }
}

struct MenuView: View {
    @Binding var display: DisplayState
    @Binding var menuState: MenuState
    
    @State var showingLockScreen: Bool = false
    
    func toggleMenu() {
        withAnimation(.smooth) {
            menuState = switch menuState {
            case .open: MenuState.compact
            case .compact: MenuState.open
            case .closed: MenuState.open
            }
        }
    }
    
    
    
    var body: some View {
        VStack(spacing: 16) {
            
            Button {
                toggleMenu()
            } label: {
                if menuState == .open {
                    LogoView().foregroundStyle(Color("Purple050").opacity(1))
                    Spacer()
                }
                Image(systemName: menuState == MenuState.open ? "chevron.backward.2" : "line.3.horizontal")
            }
            .font(.title)
            .fontDesign(.rounded)
            .foregroundStyle(Color("Purple050").opacity(0.8))
            .padding()
            
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
            LockScreenView()
        }
        
    }
   
}

//#Preview {
//    MenuView(display: .constant(.makeASale), menuState: .constant(.compact))
//}

#Preview {
    ResponsiveView { props in
        RootView(uiProperties: props)
            .environment(\.realm, DepartmentEntity.previewRealm)
    }
}
