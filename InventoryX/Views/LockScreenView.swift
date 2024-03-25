//
//  LockScreenView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/18/24.


import SwiftUI

struct LockScreenView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Spacer()
                DateTimeLabel()
                Spacer()
            } //: VStack
            
            Spacer()
            
            VStack(alignment: .center) {
                VStack(spacing: 24) {
                    Text("Enter Passcode")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    
                    Text("Please enter your 4-digit pin to securely access your account.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                }
                
                PasscodeView() { hash in
                    print("passcode entered and hashed: \(hash)")
                    guard AuthService.shared.checkPasscode(hash: hash) else {
                        print("Passcodes don't match")
                        return
                    }
                    dismiss()
                }
                .padding(.vertical)
                .frame(maxWidth: 360, maxHeight: 540, alignment: .center)
            } //: VStack
            
        } //: HStack
        .frame(maxWidth: 800)
    }
}

#Preview {
    LockScreenView()
}
