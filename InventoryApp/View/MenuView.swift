//
//  MenuView.swift
//  CogCalendar-SwiftUI
//
//  Created by Ryan Smetana on 12/7/20.
//

import SwiftUI

struct MenuView: View {
    @ObservedObject var appManager: AppStateManager
    
    var menuWidth: CGFloat = 350
    
    var body: some View {
        HStack {
            VStack(spacing: 15) {
                Spacer().frame(height: 10)
                Text("Menu")
                    .padding(.horizontal)
                    .font(.system(size: 36, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: menuWidth, height: 50, alignment: .leading)
                Button(action: {
                    self.appManager.goToMakeASale()
                    self.appManager.getAllItems()
                }) {
                    Text("Make A Sale")
                        .underline()
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .frame(height: 60)
                        .foregroundColor(.white)
                }
                
                Button(action: {
                    self.appManager.goToAddInventory()
                }) {
                    Text("Add Inventory")
                        .underline()
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .frame(height: 60)
                        .foregroundColor(.white)
                }
                
                Button(action: {
                    //                    self.appManager.changeDisplayTo(.month)
                }) {
                    Text("Sales History")
                        .underline()
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .frame(height: 60)
                        .foregroundColor(.white)
                }
                
                
                Spacer(minLength: 0)
            } //: VStack
            .frame(width: menuWidth)
            .background(
//                LinearGradient(gradient: Gradient(colors: [Color(hex: "f0f2f0"), Color(hex: "000c40")]), startPoint: .bottom, endPoint: .top)
                ZStack {
                    Color(hex: "0f2027")
                    
                    RadialGradient(gradient: Gradient(colors: [Color(hex: "0f2027"), Color(hex: "203a43"), Color(hex: "2c5354")]), center: .topLeading, startRadius: 40, endRadius: UIScreen.main.bounds.width)
                }
            )
            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            
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
