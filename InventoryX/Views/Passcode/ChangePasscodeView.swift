//
//  ChangePasscodeView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/25/24.
//

import SwiftUI

/// Pass the user's current password hash to the view. When the view is initialized:
///     - If the hash is empty, they are onboarding. Only show enter password and re-enter password.
///     - If the hash is not empty, they already have a password set and it needs to be checked before they can change it.

struct ChangePasscodeView: View {
    @Environment(\.dismiss) var dismiss
    @State var passcodeHash: String = ""
    
    /// Used in onboarding view to execute additional logic.
    let onSuccess: (() -> Void)?
    
    /// Used to hide the back button and title while onboarding.
    @State var showTitles: Bool
    
    @State var detailType: DetailViewType
    
    @State var padTitle: String = "Enter passcode"
    
    init(passHash: String = "", showTitles: Bool = true, onSuccess: (() -> Void)? = nil) {
        self.detailType = passHash.isEmpty ? .create : .modify
        self.passcodeHash = passHash
        self.showTitles = showTitles
        self.onSuccess = onSuccess
    }
    
    func passcodeSubmitted(hash: String) throws {
        if detailType == .modify {
            guard passcodeHash == hash else { throw AppError.passcodesDoNotMatch }
            passcodeHash = ""
            detailType = .create
        } else {
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
    
    @State private var passcode = ""
    
    private func passcodeChanged(to passcode: String) {
        guard passcode.count == 4 else { return }
        
        do {
            let hash = AuthService.shared.hashString(passcode)
            try passcodeSubmitted(hash: hash)
        } catch {
            LogService(self).error(error.localizedDescription)
        }
        
        self.passcode = ""
    }
    
    var body: some View {
        VStack {
            header
            Spacer()
            ViewThatFits {
                verLayout
                horLayout
            }
            Spacer()
        } //: VStack
        .padding()
    } //: Body
    
    @ViewBuilder private var header: some View {
        if showTitles {
            VStack(alignment: .leading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24)
                        .foregroundStyle(.black)
                }
                
                Text("Passcode")
                    .modifier(TitleMod())
                
            } //: VStack
            .frame(maxWidth: 720)
        }
    } //: Header
    
    private var verLayout: some View {
        VStack {
            VStack(spacing: 16) {
                Text(padTitle)
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("Enter a 4-digit passcode.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                
                circleIndicator
                    .padding(.vertical)
            } //: VStack
            .frame(minWidth: 200, idealWidth: 220, maxWidth: 2400, minHeight: 120, idealHeight: 140, maxHeight: 160)
            
            NumberPadView(passcode: $passcode)
                .frame(minWidth: 320, idealWidth: 340, maxWidth: 360)
                .onChange(of: passcode) { newPasscode in
                    passcodeChanged(to: newPasscode)
                }
        } //: VStack
        .padding(.vertical, 32)
    }
    
    private var horLayout: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(spacing: 16) {
                Text(padTitle)
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("Enter a 4-digit passcode.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                
                circleIndicator
                    .padding(.vertical)
                Spacer()
            } //: VStack
            .frame(maxWidth: .infinity, maxHeight: 420)
            
            NumberPadView(passcode: $passcode)
                .frame(minWidth: 320, idealWidth: 340, maxWidth: 360)
                .onChange(of: passcode) { newPasscode in
                    passcodeChanged(to: newPasscode)
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
    
}

#Preview {
    ChangePasscodeView(passHash: "")
}
