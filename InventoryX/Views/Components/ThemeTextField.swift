//
//  ThemeTextField.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/25/24.
//

import SwiftUI

struct ThemeTextField: View {
    @Environment(\.colorScheme) var colorScheme
    private enum Focus { case text }
    @FocusState private var focus: Focus?
    
    @Binding var boundTo: String
    let placeholder: String
    let title: String
    let hint: String?
    let type: FieldType
    
    @State var showingHint: Bool = false
    
    init(boundTo: Binding<String>, placeholder: String, title: String, hint: String? = nil, type: FieldType) {
        self._boundTo = boundTo
        self.placeholder = placeholder
        self.title = title
        self.hint = hint
        self.type = type
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Text(title)
                .foregroundStyle(Color.textPrimary)
            
            if let hint = hint {
                Button("", systemImage: "questionmark.circle.fill") {
                    showingHint.toggle()
                }
                .foregroundStyle(Color.textPrimary.opacity(0.25))
                .offset(x: -12, y: -1)
                .popover(isPresented: $showingHint) {
                    Text(hint)
                        .padding()
                        .frame(minWidth: 200, idealWidth: 280, maxWidth: 320)
                        .font(.callout)
                        .presentationCompactAdaptation(.popover)
                }
            }
            
            Spacer()
            
            TextField(placeholder, text: $boundTo)
                .multilineTextAlignment(.trailing)
                .focused($focus, equals: .text)
                .onTapGesture {
                    self.focus = .text
                }
        } //: HStack
        .font(.subheadline)
        .padding()
    } //: Body
    
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
                   hint: "This is the number that you want to restock the items in the department at. This will help you quickly find items that need to be restocked.",
                   type: .integer)
    .padding()
    .background(.bg)
    
}
