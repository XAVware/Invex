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
            VStack(spacing: 15) {
                Spacer().frame(height: 10)
                Button(action: {
//                    self.appManager.changeDisplayTo(.day)
                }) {
                    Text("Make A Sale")
                        .underline()
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .frame(height: 60)
                        .foregroundColor(.white)
                }
                
                Button(action: {
//                    self.appManager.changeDisplayTo(.week)
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
                
                Button(action: {
                    self.appManager.isShowingAddItem.toggle()
                    self.appManager.isShowingMenu.toggle()
                }) {
                    Text("Settings")
                        .underline()
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .frame(height: 40)
                        .foregroundColor(.white)
                }
//                .fullScreenCover(isPresented: $appManager.isShowingSettings, content: SettingsView.init)
                
                Spacer(minLength: 0)
            } //: VStack
            .frame(width: 350)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color(hex: "f0f2f0"), Color(hex: "000c40")]), startPoint: .bottom, endPoint: .top)
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

//struct MenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuView()
//    }
//}
