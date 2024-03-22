//
//  CapsuleInputField.swift
//  VerbalFluency
//
//  Created by Ryan Smetana on 3/12/24.
//

import SwiftUI

struct CapsuleInputField: View {
    private let CORNER_RADIUS: CGFloat = 24
    
    private enum Focus { case secure, text }
    @FocusState private var focus: Focus?
    
    let placeholder: String
    let isSecure: Bool
    
    @Binding var boundTo: String
    @State var showPassword: Bool
    
    var iconName: String?
    

    init(placeholder: String, isSecure: Bool = false, boundTo: Binding<String>, iconName: String? = nil) {
        self.placeholder = placeholder
        self.isSecure = isSecure
        self._boundTo = boundTo
        self.iconName = iconName
        showPassword = !isSecure
    }

    private func toggleDisplayPassword() {
        showPassword.toggle()
        focus = isSecure ? .text : .secure
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Group {
                if let iconName = iconName {
                    Image(systemName: iconName)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(K.primaryColor)
                } else {
                    Spacer()
                }
            }
            .frame(width: 16, height: 16)
            .padding(.horizontal)
            
            Group {
                if showPassword {
                    TextField(placeholder, text: $boundTo)
                } else {
                    SecureField(placeholder, text: $boundTo)
                }
            } //: Group
            .focused($focus, equals: showPassword ? .text : .secure)
            .foregroundStyle(.black)
            .padding(.vertical, 12)
            
            Group {
                if isSecure {
                    Button {
                        toggleDisplayPassword()
                    } label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(Color.gray)
                    }
                } else {
                    Spacer()
                }
            }
            .frame(width: 16, height: 16)
            .padding(.horizontal)
            .padding(.trailing, 4)
        } //: HStack
        .frame(maxWidth: .infinity, maxHeight: 48)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: CORNER_RADIUS))
        .overlay(
            RoundedRectangle(cornerRadius: CORNER_RADIUS)
                .stroke(lineWidth: 0.5)
                .foregroundStyle(Color.gray)
        )
    }
}

struct CapsuleInputField_Previews: PreviewProvider {
    @State static var text: String = ""
    static var previews: some View {
        VStack {
            Spacer()
            CapsuleInputField(placeholder: "Username", isSecure: false, boundTo: $text, iconName: "lock")
            Spacer()
        }
        .padding()
        .background(.ultraThickMaterial)
    }
}
