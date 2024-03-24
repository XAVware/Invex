//
//  PasscodeView.swift
//  PasscodeTemplate
//
//  Created by Stephan Dowless on 1/25/24.
//

import SwiftUI

struct PasscodeView: View {
    @State private var passcode = ""

    // Pass hash
    var onSubmit: ((String) -> Void)
    
    
    var body: some View {
        VStack(spacing: 96) {
//            VStack(spacing: 48) {

                
                HStack(spacing: 26) {
                    ForEach(0 ..< 4) { index in
                        Circle()
                            .fill(passcode.count > index ? Color("Purple800") : .clear)
                            .frame(width: 20, height: 20)
                            .overlay {
                                if passcode.count <= index {
                                    Circle()
                                        .stroke(Color("Purple800"), lineWidth: 1.0)
                                }
                            }
                    }
                }

//            }
            
            
            NumberPadView(passcode: $passcode)
        }
        .onChange(of: passcode) { newValue in
            verifyPasscode()
        }
    }
    
    private func verifyPasscode() {
        guard passcode.count == 4 else { return }
        
//            try? await Task.sleep(nanoseconds: 125_000_000)
//            isAuthenticated = passcode == "1111"
//            showPasscodeError = !isAuthenticated
        onSubmit(AuthService.shared.hashString(passcode))
        passcode = ""
    }
}

//#Preview {
//    PasscodeView(isAuthenticated: .constant(false))
//}

