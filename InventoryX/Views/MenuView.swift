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
    
    let menuButtons: [LSXDisplay] = [.pos, .inventoryList, .settings]
    
    func getButtonData(for display: LSXDisplay) -> (String, String)? {
        return switch display {
        case .pos:              ("Sale", "cart.fill")
        case .inventoryList:    ("Inventory", "tray.full.fill")
        case .settings:         ("Settings", "gearshape")
        default:                nil
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(menuButtons, id: \.self) { display in
                    if let data = getButtonData(for: display) {
                        Button {
                            LSXService.shared.update(newDisplay: display)
                        } label: {
                            HStack(spacing: 16) {
                                Text(data.0)
                                Spacer()
                                Image(systemName: data.1)
                            } //: HStack
                            .font(.title3)
                            .fontDesign(.rounded)
                            .padding()
                        }
                    }
                } //: For Each
                Spacer()
            } //: VStack
            .padding(.vertical)
        } //: Scroll
        .padding(.trailing)
        .navigationTitle("Menu")
        .navigationBarTitleDisplayMode(.inline)
        .background(
            Color.bg
                .cornerRadius(36, corners: [.topRight, .bottomRight])
                .shadow(radius: 2)
                .ignoresSafeArea()
                .padding(.trailing, 3)
        )
        
//        VStack(spacing: 16) {
//            Spacer()
//            
//            ForEach(menuButtons, id: \.self) { display in
//                Button {
//                    LSXService.shared.update(newDisplay: display)
//                } label: {
//                    HStack(spacing: 16) {
//                        let data = getButtonData(for: display)
//                        Text(data.0)
//                        Spacer()
//                        Image(systemName: data.1)
//                        RoundedCorner(radius: 8, corners: [.topLeft, .bottomLeft])
//                            .fill(Color("lightAccent"))
//                            .frame(width: 6)
////                            .opacity(display == LSXService.shared.primaryRoot ? 1 : 0)
//                            .offset(x: 3)
//                    }
////                    .modifier(MenuButtonMod(isSelected: display == LazySplitService.shared.primaryRoot))
//                }
//                
//            } //: For Each
//
//            Spacer()
//            
//            Button {
//                showingLockScreen = true
//            } label: {
//                HStack(spacing: 16) {
//                    Text("Lock")
//                    Spacer()
//                    Image(systemName: "lock")
//                    RoundedCorner(radius: 8, corners: [.topLeft, .bottomLeft])
//                        .fill(Color("lightAccent"))
//                        .frame(width: 6)
//                        .opacity(0)
//                        .offset(x: 3)
//                } //: HStack
//                .modifier(MenuButtonMod(isSelected: false))
//            }
//            
//        } //: VStack
//        .background(.lightAccent)
//        .fullScreenCover(isPresented: $showingLockScreen) {
//            LockScreenView()
//                .frame(maxHeight: .infinity)
//                .background(Color("bgColor"))
//        }
//        
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
