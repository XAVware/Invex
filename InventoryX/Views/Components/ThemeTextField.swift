//
//  ThemeTextField.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/25/24.
//

import SwiftUI

struct ThemeTextField: View {
    private enum Focus { case text }
    @FocusState private var focus: Focus?
    
    @Binding var boundTo: String
    let placeholder: String
    let title: String
    let subtitle: String?
    let type: FieldType
    
    var fieldWidth: CGFloat {
        return switch type {
        case .text:         .infinity
        case .integer:      140
        case .price:        140
        case .percentage:   140
        }
    }
    
    var body: some View {
        ViewThatFits {
            HStack(alignment: .center, spacing: 16) {
                labels
                Spacer()
                field
                    .focused($focus, equals: .text)
                    .onTapGesture {
                        self.focus = .text
                    }
            } //: HStack
            .frame(maxHeight: 140)
            
            VStack(alignment: .trailing, spacing: 16) {
                labels
                    .frame(maxWidth: .infinity, alignment: .leading)
                field
                    .focused($focus, equals: .text)
                    .onTapGesture {
                        self.focus = .text
                    }
            } //: VStack
            .frame(maxHeight: 140)
        }
    } //: Body
    
    private var labels: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundStyle(Color("TextColor"))
            
            if let sub = subtitle {
                Text(sub)
                    .fontWeight(.light)
                    .foregroundStyle(Color("GrayTextColor"))
                    .lineLimit(3)
            }
        } //: VStack
        .frame(minWidth: 140, maxWidth: 480, alignment: .leading)
    } //: Labels
    
    private var field: some View {
        HStack(spacing: 0) {
            TextField(placeholder, text: $boundTo)
                .padding(.horizontal, 12)
                .multilineTextAlignment(type.textAlignment)
            
            if (!type.overlayText.isEmpty) {
                // Overlay highlight
                ZStack {
                    Rectangle()
                        .fill(.accent)
                        .opacity(0.8)
                        .frame(width: 48)
                    
                    Text(type.overlayText)
                        .foregroundStyle(Color("lightAccent"))
                        .font(.subheadline)
                        .fontDesign(.rounded)
                        .scaleEffect(type == FieldType.percentage || type == FieldType.price ? 1.3 : 1.0)
                }
            }
        }
        .background(.ultraThickMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(lineWidth: 0.5)
                .foregroundStyle(Color("GrayTextColor").opacity(0.4))
                .shadow(color: .accent.opacity(0.2), radius: 4, x: 3, y: 3)
                .shadow(color: .accent.opacity(0.2), radius: 4, x: -3, y: -3)
        )
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .shadow(color: Color("ShadowColor"), radius: 4, x: 0, y: 0)
        .frame(minWidth: 72, idealWidth: fieldWidth, maxWidth: fieldWidth,
               minHeight: 42, idealHeight: 45, maxHeight: 48, alignment: .topLeading)
    } //: Field
    
}


extension ThemeTextField {
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
}

#Preview {
    ThemeTextField(boundTo: .constant(""),
                   placeholder: "0.00",
                   title: "Restock Threshold:",
                   subtitle: "This is the number that you want to restock the items in the department at. This will help you quickly find items that need to be restocked.",
                   type: .integer)
    .padding()
    
}
