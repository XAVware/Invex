//
//  ChangePasscodeView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/25/24.
//

import SwiftUI


//@MainActor class ChangePasscodeViewModel: ObservableObject {
//    @Published var passcodeHash: String
//    let onSuccess: (() -> Void)?
//    
//    init(passcodeHash: String?, onSuccess: (() -> Void)?) {
//        self.passcodeHash = passcodeHash ?? ""
//        self.onSuccess = onSuccess
//    }
//    
//    func passcodeSubmitted(hash: String) throws {
//        if passcodeHash.isEmpty {
//            passcodeHash = hash
//        } else {
//            guard passcodeHash == hash else {
//                passcodeHash = ""
//                throw AppError.passcodesDoNotMatch
//            }
//                        
//            AuthService.shared.savePasscode(hash: passcodeHash)
//            onSuccess?()
//        }
//    }
//}

struct ChangePasscodeView: View {
//    @StateObject var vm: ChangePasscodeViewModel
    @State var passcodeHash: String = ""
    
//    let currentHash: String?
    
    
    /// Used in onboarding view to execute additional logic.
    let onSuccess: (() -> Void)?
    
    @State var detailType: DetailViewType
    
    init(onSuccess: (() -> Void)? = nil) {
        let currentHash = AuthService.shared.getCurrentPasscode() ?? ""
        
        if !currentHash.isEmpty {
            self.detailType = .modify
        } else {
            self.detailType = .create
        }
        self.passcodeHash = currentHash
//        print("Set detail type to \(detailType)")

        self.onSuccess = onSuccess
        // If current hash is not nil, ask them to enter their current passcode before they can reset it.
//        self._vm = StateObject(wrappedValue: ChangePasscodeViewModel(passcodeHash: currentHash, onSuccess: onSuccess))
    }
    
    func passcodeSubmitted(hash: String) throws {
        if detailType == .modify {
            print("Modifying...")
            guard passcodeHash == hash else {
                throw AppError.passcodesDoNotMatch
            }
            print("Codes match. Changing to create")
            passcodeHash = ""
            detailType = .create
        } else {
            print("Creating...")
            if passcodeHash.isEmpty {
                print("Setting first hash")
                passcodeHash = hash
            } else {
                guard passcodeHash == hash else {
                    passcodeHash = ""
                    throw AppError.passcodesDoNotMatch
                }
                print("Hashes match. Saving")
                AuthService.shared.savePasscode(hash: passcodeHash)
                onSuccess?()
            }
        }
    }
    
    var body: some View {
        ViewThatFits {
            verLayout
            horLayout
        }
    }
    
    private var verLayout: some View {
        VStack {
            VStack(spacing: 16) {
                Text(passcodeHash.isEmpty ? "Enter Passcode" : "Re-enter passcode")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("Enter a 4-digit passcode.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                
                circleIndicator
                    .padding(.vertical)
            } //: VStack
            .frame(minWidth: 200, idealWidth: 220, maxWidth: 240, minHeight: 120, idealHeight: 140, maxHeight: 160)
            
            NumberPadView(passcode: $passcode)
                .onChange(of: passcode) { newValue in
                    verifyPasscode()
                }
                .frame(minWidth: 320, idealWidth: 360, maxWidth: 400)
        } //: VStack
        .padding(.vertical, 32)
    }
    
    private var horLayout: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(spacing: 16) {
                Text(passcodeHash.isEmpty ? "Enter Passcode" : "Re-enter passcode")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("Enter a 4-digit passcode.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                
                circleIndicator
                    .padding(.vertical)
            } //: VStack
            .frame(maxWidth: .infinity)
            
            NumberPadView(passcode: $passcode)
                .onChange(of: passcode) { newValue in
                    verifyPasscode()
                }
        } //: HStack
    }
    
    private var circleIndicator: some View {
        HStack(spacing: 24) {
            ForEach(0 ..< 4) { index in
                Circle()
                    .fill(passcode.count > index ? Color("Purple800") : .clear)
                    .frame(width: 16, height: 16)
                    .overlay {
                        if passcode.count <= index {
                            Circle()
                                .stroke(Color("Purple800"), lineWidth: 1.0)
                        }
                    }
            }
        }
        .frame(height: 16)
    } //: Circle Indicator
    
    @State private var passcode = ""
    
    private func verifyPasscode() {
        guard passcode.count == 4 else { return }
        
        do {
            let hash = AuthService.shared.hashString(passcode)
            try passcodeSubmitted(hash: hash)
        } catch {
            print(error.localizedDescription)
        }
        
        passcode = ""
    }
    
}




//#Preview {
//    ChangePasscodeView(passHash: "")
//}
