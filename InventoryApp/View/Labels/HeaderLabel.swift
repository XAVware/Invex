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
        default:
            return ""
        }
    }
    
    var labelWidth: CGFloat {
        switch title {
        case "Menu":
            return K.Sizes.menuWidth
        case "Current Inventory":
            return K.Sizes.screenWidth - 100
        case "Add Inventory":
            return 300
        default:
            return 400
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
                .frame(width: self.labelWidth, height: 50, alignment: .leading)
        } //: HStack
        .padding()
    }
}

struct HeaderLabel_Previews: PreviewProvider {
    static var previews: some View {
        HeaderLabel(title: "Preview")
    }
}
