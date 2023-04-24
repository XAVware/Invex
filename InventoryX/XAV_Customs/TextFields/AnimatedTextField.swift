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
    // MARK: - PROPERTIES
    @Binding var boundTo: String
    @State var placeholder: String
    
    @State var placeholderOffset: CGFloat = 0
    @State var textFieldOffset: CGFloat = 0
    @State var placeholderScale: CGFloat = 1
    
    @State var isSecure: Bool
    
    // MARK: - FUNCTIONS
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
    
    init(boundTo: Binding<String>, placeholder: String) {
        self._boundTo = boundTo
        self.placeholder = placeholder
        self.isSecure = false
        setPlacholderSize()
    }
    
    init(boundTo: Binding<String>, placeholder: String, isSecure: Bool) {
        self._boundTo = boundTo
        self.placeholder = placeholder
        self.isSecure = isSecure
        setPlacholderSize()
    }
    
    // MARK: - BODY
    var body: some View {
        ZStack(alignment: .leading) {
            Text(placeholder)
                .foregroundColor(.gray)
                .offset(y: placeholderOffset)
                .scaleEffect(placeholderScale, anchor: .leading)
            
            if isSecure {
                SecureField("", text: $boundTo)
                    .foregroundColor(.black)
                    .frame(height: 36)
                    .offset(y: textFieldOffset)
            } else {
                TextField("", text: $boundTo)
                    .foregroundColor(.black)
                    .frame(height: 36)
                    .offset(y: textFieldOffset)
            }

        } //: ZStack
        .onChange(of: boundTo.isEmpty, perform: { _ in
            withAnimation {
                setPlacholderSize()
            }
        })
        .frame(height: 48)
        .padding(.horizontal)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(.gray, lineWidth: 1)
        )
        .onAppear {
            setPlacholderSize()
        }
    }
}

// MARK: - PREVIEW
struct AnimatedTextField_Previews: PreviewProvider {
    @State static var username: String = ""
    static var previews: some View {
        AnimatedTextField(boundTo: $username, placeholder: "Username")
    }
}
