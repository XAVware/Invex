//
//  TextFieldX.swift
//  InventoryX
//
//  Created by Ryan Smetana on 11/6/24.
//

import SwiftUI

struct TextFieldX: View {
    @Environment(FormXViewModel.self) var formVM
    @FocusState private var focus: Bool
    @State private var value: String = ""
    @State private var errMsg: String = ""
    
    private let validate: (String) -> (Bool, String?)
    private let save: (String) -> Void
    
    init(value: String, validate: @escaping (String) -> (Bool, String?), save: @escaping (String) -> Void) {
        self.value = value
        self.validate = validate
        self.save = save
    }
    
    private var borderColor: Color {
        if self.errMsg.isEmpty == false {
            return Color.red.opacity(0.8)
        } else {
            return focus ? Color.textDark : Color.shadow200
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Name:")
                        .font(.caption)
                        .opacity(0.8)
                    
                    TextField("Enter a value", text: $value)
                        .focused($focus, equals: true)
                        .autocorrectionDisabled()
                        .submitLabel(.return)
                        .onSubmit { focus = false }
                } //: VStack
                .padding(10)
                .frame(height: 58)
                .background(errMsg.isEmpty ? Color.clear : Color.red.opacity(0.1))
                .modifier(RoundedOutlineMod(cornerRadius: 7, borderColor: self.borderColor))
                .onTapGesture { setFocus(true) }
                
                Label(errMsg, systemImage: "info.circle")
                    .font(.footnote)
                    .foregroundStyle(Color.red)
                    .opacity(errMsg.isEmpty ? 0 : 1)
                
            } //: VStack
            .onChange(of: focus) { wasFocused, isFocused in
                focusChanged(from: wasFocused, to: isFocused)
            }
            
            Spacer()
            
            PrimaryButtonPanelX(onCancel: {
                cancelTapped()
            }, onSave: {
                saveTapped()
            })
        } //: VStack
        .onAppear {
            setFocus(true)
            formVM.onTapOutside = {
                setFocus(false)
            }
        }
    } //: Body
    
    private func setFocus(_ focus: Bool) {
        withAnimation(.interactiveSpring) {
            self.focus = focus
        }
    }
    
    private func saveTapped() {
        setFocus(false)
        let validation = validate(value)
        if validation.0 == false {
            errMsg = validation.1 ?? "Error"
            return
        }
        save(value)
        formVM.forceClose()
    }
    
    private func cancelTapped() {
        setFocus(false)
        formVM.closeContainer(withValue: self.value)
    }
    
    private func focusChanged(from wasFocused: Bool, to isFocused: Bool) {
        /// When the text field is no longer focused, run validation logic.
        ///     - To no longer be in focus the user must have de-selected the field or tried to submit.
        if !isFocused {
            let validation = validate(value)
            if !validation.0 {
                errMsg = validation.1 ?? "Error"
            }
        } else if wasFocused && isFocused {
            errMsg = ""
        }
    }
    
}

#Preview {
    TextFieldX(value: "XAVware", validate: { value in
        if value.isEmpty {
            return (false, "Please enter a valid name.")
        } else {
            return (true, nil)
        }
    }, save: { validString in
        print("Save: \(validString)")
    })
    .environment(FormXViewModel())
    .padding()
}
