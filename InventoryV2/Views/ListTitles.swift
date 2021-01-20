//
//  InventoryListDetailLabel.swift
//  InventoryApp
//
//  Created by Ryan Smetana on 12/22/20.
//

import SwiftUI

struct ListTitles: View {
    var columnTitles: [String]
    @State var listWidth: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            
            ForEach(columnTitles, id: \.self) { title in
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .opacity(0.7)
                    .frame(width: (listWidth / CGFloat(columnTitles.count)), alignment: self.getAlignmentFor(title: title))
            }
            
        } //: HStack
        .frame(height: 40)
    }
    
    func getAlignmentFor(title: String) -> Alignment {
        if title == columnTitles[0] {
            return .leading
        } else if title == columnTitles[columnTitles.count - 1] {
            return .trailing
        } else {
            return .center
        }
    }
}
