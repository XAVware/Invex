//
//  TextFieldX.swift
//  InventoryX
//
//  Created by Ryan Smetana on 11/6/24.
//

import SwiftUI

struct TextFieldX: View {
    @Environment(XAVFormViewModel.self) var formVM
    @FocusState private var focus: Bool
    @State var value: String = ""
    @State var errorMessage: String = ""
    
    let validate: (String) -> (Bool, String?)
    let save: (String) -> Void
    
    init(value: String, validate: @escaping (String) -> (Bool, String?), save: @escaping (String) -> Void) {
        self.value = value
        self.validate = validate
        self.save = save
    }
    
    func setFocus(_ focus: Bool) {
        withAnimation(.interactiveSpring) {
            self.focus = focus
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
                }
                .padding(10)
                .frame(height: 58)
                .modifier(RoundedOutlineMod(cornerRadius: 7, borderColor: focus ? Color.black : Color.neoUnderDark))
                .onTapGesture { setFocus(true) }
                
                HStack {
                    if !errorMessage.isEmpty {
                        Image(systemName: "info.circle")
                    }
                    Text(errorMessage)
                }
                .font(.footnote)
                .foregroundStyle(Color.red)
            } //: VStack
            .onChange(of: focus) { wasFocused, isFocused in
                if !isFocused {
                    let validation = validate(value)
                    if !validation.0 {
                        errorMessage = validation.1 ?? "Error"
                    }
                } else if wasFocused && isFocused {
                    errorMessage = ""
                }
            }
            
            HStack {
                Button("Cancel") {
                    setFocus(false)
                    formVM.closeContainer(withValue: self.value)
                }
                .underline()
                .buttonStyle(.plain)
                
                Spacer()
                
                Button {
                    setFocus(false)
                    let validation = validate(value)
                    if validation.0 == false {
                        errorMessage = validation.1 ?? "Error"
                        return
                    }
                    save(value)
                    formVM.forceClose()
                } label: {
                    Text("Save").font(.headline)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle)
                .controlSize(.large)
            }
        } //: VStack
        .onAppear {
            setFocus(true)
//            formVM.setOrigValue(self.value)
            formVM.onTapOutside = {
                setFocus(false)
            }
            
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
    
}
