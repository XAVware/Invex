//
//  NewMenu.swift
//  InventoryV2
//
//  Created by Ryan Smetana on 12/26/20.
//

import SwiftUI

struct MenuView: View {
    @Binding var displayState: DisplayStates
    
    @State var isShowingMenu: Bool = false
    
    var body: some View {
        HStack {
            VStack(spacing: 15) {
                
                HStack {
                    Text("Menu")
                        .padding()
                        .font(.system(size: 36, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
                    
                    Button(action: {
                        withAnimation {
                            self.isShowingMenu.toggle()
                        }
                    }) {
                        Image(systemName: self.isShowingMenu ? "chevron.right" : "line.horizontal.3")
                            .resizable()
                            .scaledToFit()
                            .accentColor(.white)
                            .font(.system(size: 24, weight: .medium))
                            .frame(width: 25, height: self.isShowingMenu ? 20 : 40)
                    }
                    .frame(width: 30, height: 30, alignment: .trailing)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 15)
                    .background(Color("ThemeColor"))
                    .cornerRadius(9)
                    .offset(x: self.isShowingMenu ? 0 : 50, y: 0)
                    
                } //: HStack
                .padding(.top)
                
                Button(action: {
                    self.changeStateTo(.makeASale)
                }) {
                    Text("Make A Sale")
                }
                .modifier(MenuButtonModifier())
                
                Divider().background(Color.white)
                
                Button(action: {
                    self.changeStateTo(.addInventory)
                }) {
                    Text("Add Inventory")
                }
                .modifier(MenuButtonModifier())
                
                Divider().background(Color.white)
                
                
//                MenuButton(title: "Inventory List") {
//                    self.changeStateTo(.inventoryList)
//                }
//
//                MenuButton(title: "Sales History") {
//                    self.changeStateTo(.salesHistory)
//                }
//
//                MenuButton(title: "Inventory Status") {
//                    self.changeStateTo(.inventoryStatus)
//                }
                
                Spacer()
                
            } //: VStack - Menu View
            .frame(width: 350)
            .background(Color("ThemeColor"))
            .edgesIgnoringSafeArea(.all)
            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            
            Spacer(minLength: 0)
        } //: HStack - MenuView
        .offset(x: self.isShowingMenu ? 0: -350, y: 0)
        .background(
            Color.black.opacity(self.isShowingMenu ? 0.28 : 0)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {withAnimation { self.isShowingMenu = false }})
        .edgesIgnoringSafeArea(.all)
    }
    
    func changeStateTo(_ newState: DisplayStates) {
        self.displayState = newState
        withAnimation { self.isShowingMenu = false }
    }
}
