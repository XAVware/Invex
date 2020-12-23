//
//  HeaderLabel.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/20/20.
//

import SwiftUI

struct HeaderLabel: View {
    @State var title: String
    
    var imageName: String {
        switch title {
        case "Add Inventory":
            return "dollarsign.square"
        case "Current Inventory":
            return "newspaper"
        case "Sales History":
            return "dollarsign.circle"
        default:
            return ""
        }
    }
    
    var body: some View {
        HStack(spacing: 20) {
            
            if self.title != "Menu" {
                Image(systemName: self.imageName)
                    .resizable()
                    .scaledToFit()
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 40, height: 40)
            }
            
            Text(self.title)
                .padding()
                .font(.system(size: 36, weight: .semibold, design: .rounded))
                .foregroundColor(self.title == "Menu" ? Color.white : Color.black)
                .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
            
        } //: HStack
        .padding()
    }
}

