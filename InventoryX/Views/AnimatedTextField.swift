//
//  AnimatedTextField.swift
//  XAV_Customs
//
//  © 2023 XAVware, LLC.
//
// ~~~~~~~~~~~~~~~ README ~~~~~~~~~~~~~~~
//

import SwiftUI

struct AnimatedTextField: View {
    enum FocusedField { case field }
    @FocusState var isFocused: FocusedField?
    
    @Binding var boundTo: String
    @State var placeholder: String
    
    @State var placeholderOffset: CGFloat = 0
    @State var textFieldOffset: CGFloat = 0
    @State var placeholderScale: CGFloat = 1
    
    let isSecure: Bool
    let fgColor: Color
    let bgColor: Color
    let tintColor: Color
    let fieldHeight: CGFloat
    
    private var isPlaceholderSmall: Bool {
        if isFocused == .field || !boundTo.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func setPlacholderSize() {
        withAnimation(.easeOut(duration: 0.15)) {
            placeholderOffset = isPlaceholderSmall ? -32 : 0
            placeholderScale = isPlaceholderSmall ? 0.65 : 1
        }
    }
    
    init(boundTo: Binding<String>, placeholder: String, isSecure: Bool = false, fgColor: Color = .black, bgColor: Color = .clear, tintColor: Color = .gray, fieldHeight: CGFloat = 36) {
        self._boundTo = boundTo
        self.placeholder = placeholder
        self.isSecure = isSecure
        self.fgColor = fgColor
        self.bgColor = bgColor
        self.tintColor = tintColor
        self.fieldHeight = fieldHeight
    }
    
    var body: some View {
        field
            .padding(.horizontal)
            .foregroundColor(fgColor)
            .frame(height: 36)
            .background(bgColor)
            .focused($isFocused, equals: .field)
            .overlay(border)
            .overlay(placeholderLabel, alignment: .leading)
            .onTapGesture {
                isFocused = .field
            }
            .onAppear {
                setPlacholderSize()
            }
            .onChange(of: isPlaceholderSmall, perform: { _ in
                setPlacholderSize()
            })
    } //: Body
    
    private var border: some View {
        RoundedRectangle(cornerRadius: 5)
            .stroke(tintColor, lineWidth: 1)
    } //: Border
    
    private var placeholderLabel: some View {
        Text(placeholder)
            .foregroundColor(tintColor)
            .padding(.horizontal, isPlaceholderSmall ? 4 : 0)
            .background(bgColor)
            .padding(.leading, 18)
            .offset(y: placeholderOffset)
            .scaleEffect(placeholderScale, anchor: .leading)
        
    } //: Placeholder Label
    
    @ViewBuilder var field: some View {
        if isSecure {
            SecureField("", text: $boundTo)
        } else {
            TextField("", text: $boundTo)
        }
    } //: Field
}

// MARK: - PREVIEW
struct AnimatedTextField_Previews: PreviewProvider {
    @State static var username: String = ""
    static var previews: some View {
        AnimatedTextField(boundTo: $username, placeholder: "Username")
            .frame(maxWidth: 300)
    }
}
