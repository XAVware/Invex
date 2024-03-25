//
//  ThemeTextField.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/25/24.
//

import SwiftUI

struct ThemeTextField: View {
    enum FieldType {
        case text
        case integer
        case price
        case percentage
        
        
        var overlayText: String {
            return switch self {
            case .text:         "abc"
            case .integer:      "123"
            case .price:        "$"
            case .percentage:   "%"
            }
        }
        
        var overlayAlignment: Alignment {
            return switch self {
            case .percentage: .trailing
            default: .leading
            }
        }
        
        var textAlignment: TextAlignment {
            return switch self {
            case .text: .leading
            default: .center
            }
        }
    }
    
    enum LayoutOption {
        case vertical
        case horizontal
    }
    
    
    @Binding var boundTo: String
    let placeholder: String
    let title: String
    let subtitle: String?
    let type: FieldType
    let layout: LayoutOption
    
    var body: some View {
        switch layout {
        case .vertical:
            VStack(spacing: 16) {
                labels
                
                field
            } //: VStack
            .frame(maxWidth: 720)
            
        case .horizontal:
            GeometryReader { geo in
                HStack(spacing: 16) {
                    labels
                        .frame(maxWidth: 420)
                    Spacer()
                    field
                        .frame(width: 140)
                }
            }
        }
        
        
        
    } //: Body
    
    private var labels: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
                .fontWeight(.regular)
                .fontDesign(.rounded)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let sub = subtitle {
                Text(sub)
                    .font(.subheadline)
                    .fontDesign(.rounded)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                
            }
        } //: VStack
        //        .frame(maxWidth: 420, alignment: .leading)
    } //: Labels
    

    
    private var field: some View {
        HStack(spacing: 0) {
            TextField(placeholder, text: $boundTo)
                .padding(.horizontal, 12)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .multilineTextAlignment(type.textAlignment)
            
            if (!type.overlayText.isEmpty) {
                highlight
            }
        }
        .frame(maxHeight: 54)
        .background(.white.opacity(0.95))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(lineWidth: 0.5)
                    .foregroundStyle(.gray)
                    .shadow(color: Color("Purple050"), radius: 4, x: 3, y: 3)
                    .shadow(color: Color("Purple050"), radius: 4, x: -3, y: -3)
            )
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .shadow(color: Color.gray.opacity(0.25), radius: 4, x: 0, y: 0)
    } //: Field
    
    private var highlight: some View {
        ZStack {
            Rectangle()
                .fill(Color("Purple800").opacity(0.9))
                .opacity(0.8)
                .frame(width: 48)
            Text(type.overlayText)
                .foregroundStyle(Color("Purple050"))
                .font((type == FieldType.percentage || type == FieldType.price) ? .title3 : .subheadline)
                .fontWeight(.heavy)
                .fontDesign(.rounded)
        }
    }
}

#Preview {
    ThemeTextField(boundTo: .constant(""),
                   placeholder: "0.00",
                   title: "Restock Threshold:",
                   subtitle: "This is the number that you want to restock the items in the department at. This will help you quickly find items that need to be restocked.",
                   type: .integer, 
                   layout: .horizontal)
        .frame(maxHeight: 140)
}
