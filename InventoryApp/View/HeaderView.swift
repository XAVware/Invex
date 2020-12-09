//
//  HeaderView.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/9/20.
//

import SwiftUI

struct HeaderView: View {
    @ObservedObject var appManager: AppStateManager
    
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
                            .font(.system(size: 24, weight: .heavy))
                            .frame(width: 40, height: 60)
                        
                        Text("Menu")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .accentColor(.white)
                    }
                }
                .frame(width: 150, height: 50)
                .padding(.horizontal)
                
                Text("Inventory Tracker")
                    .frame(minWidth: 250, maxWidth: .infinity, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .center)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                    .frame(width: 150)
                    .padding(.horizontal)
                
            }
            .frame(height: 60)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color(hex: "000000").opacity(0.9), Color(hex: "434343").opacity(1)]), startPoint: .top, endPoint: .bottom)
            )
        
    }
}

//struct HeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        HeaderView()
//            
//    }
//}
