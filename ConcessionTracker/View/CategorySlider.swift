//
//  CategorySlider.swift
//  ConcessionTrackerComponents
//
//  Created by Smetana, Ryan on 6/16/21.
//

import SwiftUI

struct CategorySlider: View {
    
    @Binding var selectedCategoryName: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            HStack(spacing: 2) {
                ForEach(concessionTypes) { type in
                    Button(action: {
                        self.selectedCategoryName = type.type
                    }, label: {
                        Text(type.type)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 7)
                            .foregroundColor(.black)
                            .opacity(self.selectedCategoryName == type.type ? 1.0 : 0.65)
                    })
                    .frame(minWidth: 150)
                    .background(self.selectedCategoryName == type.type ? Color.green : Color.white)
                    .cornerRadius(15, corners: .bottomLeft)
                    .cornerRadius(15, corners: .bottomRight)
                    
                    Divider().background(Color.black).padding(.vertical, 4)
                }
                
            }
        })
    }
}

