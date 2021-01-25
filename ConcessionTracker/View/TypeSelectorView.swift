//
//  TypeSelectorView.swift
//  ConcessionTracker
//
//  Created by Ryan Smetana on 1/20/21.
//

import SwiftUI

struct TypeSelectorView: View {
    @Binding var selectedType: String
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(concessionTypes) { concessionType in
                    Button(action: {
                        self.selectedType = concessionType.type
                    }) {
                        HStack {
                            Text(concessionType.type)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 18, weight: self.selectedType == concessionType.type ? .semibold : .light, design: .rounded))
                                .foregroundColor(Color.black)


                            Image(systemName: "chevron.right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10, height: 15)
                                .font(.system(size: 18, weight: self.selectedType == concessionType.type ? .semibold : .light, design: .rounded))
                                .foregroundColor(Color.black)
                        } //: HStack
                    } //: Button - ConcessionType
                    .padding(.horizontal)
                    .frame(height: 40)
                    .background(self.selectedType == concessionType.type ? Color.gray.opacity(0.8) : Color.clear)
                    
                    Divider()
                } //: ForEach
            } //: VStack
        } //: ScrollView
    }
}

