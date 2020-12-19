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
    }
    
    
}

