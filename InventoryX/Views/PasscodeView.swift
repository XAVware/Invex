//
//  ChangePasscodeView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/25/24.
//

import SwiftUI

enum PasscodeViewState {
    case set
    case confirm
    
    var padTitle: String {
        return switch self {
        case .set: "Enter a passcode"
        case .confirm: "Enter current passcode"
        }
    }
    
//    var padSubtitle: String {
//        return switch self {
//        case .set: "Enter a 4-digit passcode."
//        case .confirm: "Enter a 4-digit passcode."
//        }
//    }
}

/// To allow for reusability in Onboarding, Change Passcode, and Lock Screen scenarios, this view
/// is initialized with an array of processes that can either be `.confirm` or `.set`. Every time
/// a passcode is submitted to the ViewModel it takes the first process in the array and runs it's
/// logic. If the logic for that process is executed successfully, the first process is removed
/// from the array. The last line of `passcodeSubmitted()` checks if `processes` is empty. If it
/// is empty, there are no more tasks that need to be complete and `onSuccess()` can be called.
///
/// - `passcodeHash` is initialized to `AuthService.passHash` and will be an empty string if no 
///     passcode hash exists in UserDefaults.
/// - `onSuccess()` is used once all processes are run to execute cleanup functions in parent views.
/// - `showTitles` is used to give parent views control over whether or not the header buttons/titles 
///     are visible
///
/// Onboarding Processes => `[.set]` 
///     - The user has never created a passcode
///
/// Change Passcode Processes => `[.confirm, .set]`
///     - The user wants to change their passcode but they need to enter their current passcode first.
///
/// Lock Screen Processes => `[.confirm]`
///     - The user has a passcode set and has no intention of changing it. They need to enter the 
///     passcode and unlock the app if it is correct
///
/// The `.set` process:
///     When the user is setting a passcode they will need to enter the new passcode twice to ensure 
///     they intended to submit the passcode. Initially, `passcodeHash` needs to be an empty string.
///     When a passcode is submitted while `passcodeHash` is empty, `passcodeHash` will be set to
///     the hash of the new code but they still need to enter the code again so `.set` is not removed
///     from the process array. When they submit a passcode a second time, the new hash will be
///     compared to the previously entered `passcodeHash` - if they match, the new passcodeHash is
///     saved and the `.set` process is finished so it is removed, otherwise an error for mismatched
///     passcodes is thrown and `passcodeHash` is cleared so the user will restart the `.set` process.
///
/// The `.confirm` process:
///     When the user is confirming a passcode, `AuthService.passHash` must not be empty otherwise there 
///     would be nothing to compare passcodes to. `passcodeHash` is initialized to `AuthService.passHash`.
///     When a passcode is submitted, check if the new hash matches `passcodeHash`. If the passcode hashes
///     match, remove `.confirm` from the process array and set `passcodeHash` to an empty string in
///     case the user needs to set a new passcode immediately after.

@MainActor class PasscodeViewModel: ObservableObject {
    @Published var authService: AuthService
    @Published var processes: [PasscodeViewState]
    @Published var passcodeHash: String = ""
    @Published var showTitles: Bool
    let onSuccess: (() -> Void)?
    
//    @Published var headerTitle: String
    
    var headerTitle: String {
        switch processes.first {
        case .set:
            if passcodeHash.isEmpty {
                return "Enter a new passcode"
            } else {
                return "Re-enter passcode"
            }
            
        case .confirm:
            return "Enter current passcode"
        default:
            return "Untracked state"
            
        }
    }
    
    init(processes: [PasscodeViewState], showTitles: Bool, onSuccess: (() -> Void)?) {
        let authService = AuthService.shared
        let currentHash = authService.passHash
        debugPrint("Hash stored in AuthService: \(currentHash)")
        self.passcodeHash = currentHash
        self.authService = authService
        self.onSuccess = onSuccess
        self.processes = processes
        self.showTitles = showTitles
//        self.headerTitle = processes.first?.padTitle ?? "Err"
        debugPrint("Initializing with processes: \(processes)")
    }
    
    func passcodeSubmitted(code: String) async throws {
        let newHash = authService.hashString(code)
        guard let type = processes.first else { throw AppError.noPasscodeProcesses }
        
        switch type {
        case .set:
            if passcodeHash.isEmpty {
                debugPrint("Setting password hash to: \(newHash)")
                passcodeHash = newHash
//                headerTitle = "Re-enter passcode"
            } else {
                guard passcodeHash == newHash else {
                    debugPrint("Setting password hash to: ")
                    passcodeHash = ""
                    throw AppError.passcodesDoNotMatch
                }
                
                await authService.savePasscode(hash: newHash)
                processes.removeFirst()
            }
            
        case .confirm:
            guard !passcodeHash.isEmpty else { throw AppError.noPasscodeFound }
            guard passcodeHash == newHash else { throw AppError.passcodesDoNotMatch }
            processes.removeFirst()
//            if processes.count > 0 {
//                headerTitle = "Enter a new passcode"
//            }
            debugPrint("Setting password hash to: ")
            passcodeHash = ""
        }
        
        debugPrint("Remaining processes: \(processes)")
    
        if processes.isEmpty {
            onSuccess?()
        }
    }

}

struct PasscodeView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: PasscodeViewModel
    let defaultSubtitle: String = "Enter a 4-digit passcode"
    @State private var passcode = ""
    @State private var subtitle = "Enter a 4-digit passcode"
    
    init(processes: [PasscodeViewState], showTitles: Bool = true, onSuccess: (() -> Void)? = nil) {
        self._vm = StateObject(wrappedValue: PasscodeViewModel(processes: processes, showTitles: showTitles, onSuccess: onSuccess))
    }
    
    
    private func passcodeChanged(to passcode: String) {
        self.subtitle = defaultSubtitle
        guard passcode.count == 4 else { return }
        let code = passcode
        self.passcode = ""
        
        Task {
            do {
                try await vm.passcodeSubmitted(code: code)
            } catch let error as AppError {
                if error.localizedDescription == AppError.passcodesDoNotMatch.localizedDescription {
                    self.subtitle = error.localizedDescription
                } else {
                    print("Error submitting passcode: \(error.localizedDescription)")
                }
            } catch {
                print("Error submitting passcode: \(error.localizedDescription)")
            }
        }
        
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
        if vm.showTitles {
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
                
                Text(vm.headerTitle)
                    .modifier(TitleMod())
                
            } //: VStack
            .frame(maxWidth: 720)
        }
    } //: Header
    
    private var verLayout: some View {
        VStack {
            VStack(spacing: 16) {
                Text(subtitle)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                
                circleIndicator
                    .padding(.vertical)
            } //: VStack
            .frame(minWidth: 200, idealWidth: 220, maxWidth: 2400, minHeight: 120, idealHeight: 140, maxHeight: 160)
            
            NumberPadView(passcode: $passcode)
                .frame(minWidth: 320, idealWidth: 340, maxWidth: 360)
                .onChange(of: passcode) { _, newPasscode in
                    passcodeChanged(to: newPasscode)
                }
        } //: VStack
        .padding(.vertical, 32)
    }
    
    private var horLayout: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(spacing: 16) {
                Text(subtitle)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                
                circleIndicator
                    .padding(.vertical)
                
                Spacer()
            } //: VStack
            .frame(maxWidth: .infinity, maxHeight: 420)
            
            NumberPadView(passcode: $passcode)
                .frame(minWidth: 320, idealWidth: 340, maxWidth: 360)
                .onChange(of: passcode) { _, newPasscode in
                    passcodeChanged(to: newPasscode)
                }
        } //: HStack
    }
    
    private var circleIndicator: some View {
        HStack(spacing: 24) {
            ForEach(0 ..< 4) { index in
                Circle()
                    .fill(passcode.count > index ? .accent : .clear)
                    .frame(width: 16, height: 16)
                    .overlay {
                        if passcode.count <= index {
                            Circle()
                                .stroke(.accent, lineWidth: 1.0)
                        }
                    }
            }
        }
        .frame(height: 16)
    } //: Circle Indicator
    
}

#Preview {
    PasscodeView(processes: [.set])
}
