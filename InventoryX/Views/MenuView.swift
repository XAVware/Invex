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
            if menuState == .open || menuState == .compact {
                Button {
                    toggleMenu()
                } label: {
                    Spacer()
                    Image(systemName: "line.3.horizontal")
                }
                .font(.title)
                .fontDesign(.rounded)
                .foregroundStyle(Color("Purple050").opacity(0.8))
                .padding()
//                .animation(nil, value: true)
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
