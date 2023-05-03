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
    @Binding var boundTo: String
    @State var placeholder: String
    
    @State var placeholderOffset: CGFloat = 0
    @State var textFieldOffset: CGFloat = 0
    @State var placeholderScale: CGFloat = 1
    
    @State var isSecure: Bool
    @State var foregroundColor: Color
    @State var tintColor: Color
    
    
    func setPlacholderSize() {
        if boundTo.isEmpty {
            placeholderOffset = 0
            placeholderScale = 1
            textFieldOffset = 0
        } else {
            placeholderOffset = -19
            placeholderScale = 0.65
            textFieldOffset = 7
        }
    }
    
    init(boundTo: Binding<String>, placeholder: String, isSecure: Bool = false, foregroundColor: Color = .black, tintColor: Color = .gray) {
        self._boundTo = boundTo
        self.placeholder = placeholder
        self.isSecure = isSecure
        self.foregroundColor = foregroundColor
        self.tintColor = tintColor
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.clear
            
            Text(placeholder)
                .foregroundColor(tintColor)
                .offset(y: placeholderOffset)
                .scaleEffect(placeholderScale, anchor: .leading)
            
            field
                .foregroundColor(foregroundColor)
                .frame(height: 36)
                .offset(y: textFieldOffset)
        } //: ZStack
        .onChange(of: boundTo.isEmpty, perform: { _ in
            withAnimation(.easeOut(duration: 0.3)) {
                setPlacholderSize()
            }
        })
        .frame(height: 48)
        .padding(.horizontal)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(tintColor, lineWidth: 1)
        )
        .onAppear {
            setPlacholderSize()
        }
    } //: Body
    
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
    }
}
