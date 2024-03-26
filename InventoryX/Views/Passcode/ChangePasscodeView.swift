//
//  ChangePasscodeView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/25/24.
//

import SwiftUI


@MainActor class ChangePasscodeViewModel: ObservableObject {
    @Published var passcodeHash: String
    let onSuccess: (() -> Void)?
    
    init(passcodeHash: String?, onSuccess: (() -> Void)?) {
        self.passcodeHash = passcodeHash ?? ""
        self.onSuccess = onSuccess
    }
    
    func passcodeSubmitted(hash: String) throws {
        if passcodeHash.isEmpty {
            passcodeHash = hash
        } else {
            guard passcodeHash == hash else {
                passcodeHash = ""
                throw AppError.passcodesDoNotMatch
            }
                        
            AuthService.shared.savePasscode(hash: passcodeHash)
            onSuccess?()
        }
    }
}

struct ChangePasscodeView: View {
    @StateObject var vm: ChangePasscodeViewModel
    @State var passcodeHash: String = ""
    
    let currentHash: String?
    
    
    /// Used in onboarding view to execute additional logic.
    let onSuccess: (() -> Void)?
    
    init(passHash: String?, onSuccess: (() -> Void)? = nil) {
        self.currentHash = passHash
        self.onSuccess = onSuccess
        // If current hash is not nil, ask them to enter their current passcode before they can reset it.
        self._vm = StateObject(wrappedValue: ChangePasscodeViewModel(passcodeHash: passHash, onSuccess: onSuccess))
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 24) {
                Text(vm.passcodeHash.isEmpty ? "Enter Passcode" : "Re-enter passcode")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Text("Enter a 4-digit passcode to be used to unlock the app.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            } //: VStack
            
            PasscodeView() { hash in
                do {
                    try vm.passcodeSubmitted(hash: hash)
//                    onSuccess?()
                } catch {
                    print(error.localizedDescription)
                }
//                if passcodeHash.isEmpty {
//                    print("Setting first passcode to: \(hash)")
//                    passcodeHash = hash
//                } else {
//                    guard passcodeHash == hash else {
//                        passcodeHash = ""
//                        return
//                    }
//
//                    print("Passcodes match")
//
//                    AuthService.shared.savePasscode(hash: passcodeHash)
//                    vm.currentDisplay = .department
//                }
            }
            .padding(.vertical)
            .frame(maxWidth: 360, maxHeight: 540, alignment: .center)
            
            
        } //: VStack
    }
}




#Preview {
    ChangePasscodeView(passHash: "")
}
