//
//  MenuView.swift
//  CogCalendar-SwiftUI
//
//  Created by Ryan Smetana on 12/7/20.
//

import SwiftUI

struct MenuView: View {
    @ObservedObject var appManager: AppStateManager
    
    var body: some View {
        HStack {
            
            //MARK: - Menu View
            VStack(spacing: 15) {
                
                HeaderLabel(title: "Menu")
//                    .frame(width: K.Sizes.menuWidth, height: 50, alignment: .leading)
                
                MenuButton(title: "Make A Sale") {
                    self.appManager.changeDisplay(to: .makeASale)
                }
                
                MenuButton(title: "Add Inventory") {
                    self.appManager.changeDisplay(to: .addInventory)
                }
                
                MenuButton(title: "Inventory List") {
                    self.appManager.changeDisplay(to: .inventoryList)
                }
                
                Spacer()
                
            } //: VStack - Menu View
            .frame(width: K.Sizes.menuWidth)
            .background(K.BackgroundGradients.menuView)
            .padding(.bottom, K.SafeAreas.bottom)
            .padding(.top, K.SafeAreas.top)
            
            Spacer(minLength: 0)
        } //: HStack - MenuView
        .offset(x: self.appManager.isShowingMenu ? 0 : -UIScreen.main.bounds.width - 60)
        .background(Color.black.opacity(self.appManager.isShowingMenu ? 0.28 : 0).edgesIgnoringSafeArea(.all).onTapGesture { self.appManager.toggleMenu() }
        )
        .edgesIgnoringSafeArea(.all)
    }
    
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(appManager: AppStateManager())
            .previewLayout(.sizeThatFits)
    }
}
