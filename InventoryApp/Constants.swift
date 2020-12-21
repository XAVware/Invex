//
//  Constants.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/19/20.
//

import SwiftUI


struct K {
    
    struct BackgroundGradients {
        static let saveButton = RadialGradient(gradient: Gradient(colors: [Color(hex: "237a30").opacity(1), Color(hex: "237a30").opacity(0.7), Color(hex: "4ac29a").opacity(0.9)]), center: .center, startRadius: 50, endRadius: 250)
        static let checkoutButton = RadialGradient(gradient: Gradient(colors: [Color(hex: "237a30").opacity(1), Color(hex: "237a30").opacity(0.7), Color(hex: "4ac29a").opacity(0.9)]), center: .center, startRadius: 50, endRadius: 250)
        static let cartView = LinearGradient(gradient: Gradient(colors: [Color(hex: "141E30").opacity(0.8), Color(hex: "243B55").opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing)
        static let navBar = LinearGradient(gradient: Gradient(colors: [Color(hex: "000000").opacity(0.9), Color(hex: "434343").opacity(0.9)]), startPoint: .top, endPoint: .bottom)
        static let menuView = RadialGradient(gradient: Gradient(colors: [Color(hex: "0f2027"), Color(hex: "203a43"), Color(hex: "2c5354")]), center: .topLeading, startRadius: 40, endRadius: UIScreen.main.bounds.width)
    }
    
    struct SafeAreas {
        static let top = UIApplication.shared.windows.first?.safeAreaInsets.top
        static let bottom = UIApplication.shared.windows.first?.safeAreaInsets.bottom
        static let leading = UIApplication.shared.windows.first?.safeAreaInsets.left
        static let trailing = UIApplication.shared.windows.first?.safeAreaInsets.right
    }
    
    struct Sizes {
        static let screenWidth: CGFloat = UIScreen.main.bounds.width
        static let menuWidth: CGFloat = 350
        static let cartWidth: CGFloat = UIScreen.main.bounds.width * 0.34
    }
    
    
}

