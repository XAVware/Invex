//
//  PasscodeView.swift
//  PasscodeTemplate
//
//  Created by Stephan Dowless on 1/25/24.
//

import SwiftUI

struct PasscodeView: View {
    @State private var passcode = ""
    @State private var showPasscodeError = false
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        VStack {
            VStack(spacing: 48) {
                VStack(spacing: 24) {
                    Text("Enter Passcode")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    
                    Text("Please enter your 4-digit pin to securely access your account.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                }
                .padding(.top)
                
                HStack(spacing: 26) {
                    ForEach(0 ..< 4) { index in
                        Circle()
                            .fill(passcode.count > index ? Color("Purple600") : Color("Purple200"))
                            .frame(width: 20, height: 20)
                            .overlay {
                                if passcode.count <= index {
                                    Circle()
                                        .stroke(Color("Purple800"), lineWidth: 1.0)
                                }
                            }
                    }
                }
                
                if showPasscodeError {
                    Text("Incorrect passcode. Please try again.")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
            
            Spacer()
            
            NumberPadView(passcode: $passcode)
        }
        .onChange(of: passcode) { newValue in
            verifyPasscode()
        }
    }
    
    private func verifyPasscode() {
        guard passcode.count == 4 else { return }
        
        Task {
            try? await Task.sleep(nanoseconds: 125_000_000)
            isAuthenticated = passcode == "1111"
            showPasscodeError = !isAuthenticated
            passcode = ""
        }
    }
}

#Preview {
    PasscodeView(isAuthenticated: .constant(false))
}

