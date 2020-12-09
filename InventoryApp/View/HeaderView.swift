//
//  HeaderView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/9/20.
//

import SwiftUI

struct HeaderView: View {
    @ObservedObject var appManager: AppStateManager
    
    var menuButtonWidth: CGFloat = 100
    
    var body: some View {
            HStack {
                Button(action: {
                    self.appManager.toggleMenu()
                }) {
                    HStack {
                        Image(systemName: "line.horizontal.3")
                            .resizable()
                            .scaledToFit()
                            .accentColor(.white)
                            .font(.system(size: 24, weight: .medium))
                            .frame(width: 30, height: 40)
                        
                        Text("Menu")
                            .font(.system(size: 18, weight: .light, design: .rounded))
                            .accentColor(.white)
                    }
                }
                .frame(width: menuButtonWidth)
                .padding(.horizontal)
                
                Text("Concession Tracker")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                    .frame(width: menuButtonWidth)
                    .padding(.horizontal)
                
            }
            .frame(height: 40)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color(hex: "000000").opacity(0.9), Color(hex: "434343").opacity(0.9)]), startPoint: .top, endPoint: .bottom)
            )
        
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(appManager: AppStateManager())
            
    }
}
