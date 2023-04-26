//
//  PasscodePad.swift
//  ConcessionTrackerComponents
//
//  Created by Smetana, Ryan on 6/16/21.
//

import SwiftUI

struct PasscodePad: View {
    enum PadState { case setPasscode, enterPasscode }
    let values: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "", "0", "Delete"]
    
    @State var padState: PadState
    @State var completion: () -> Void
    
    @State var passcode: String = ""
    @State var confirmPasscode: String = ""
    
    @State var finalPasscode: String = ""
    
    @State var isShowingError: Bool = false
    @State var isConfirming: Bool = false
    
    @State var passcodeRowCounter: Int = 0
    
    init(padState: PadState, completion: @escaping () -> Void) {
        self.padState = padState
        self.completion = completion
    }
    
    var errorMessage: String {
        switch true {
        case padState == .setPasscode && isShowingError:
            return "The passcodes you entered do not match. Please try again"
        case padState == .enterPasscode && isShowingError:
            return "The passcode you entered is incorrect."
        case isConfirming:
            return "Re-Enter Your Passcode"
        default:
            return ""
        }
    }

    func getRowFactor(for row: Int) -> Int {
        switch row {
        case 0: return 1
        case 1: return 3
        case 2: return 5
        case 3: return 7
        default: return 0
        }
    }
    
    func finish() {
        if finalPasscode == "" {
            finalPasscode = passcode
            passcode = ""
            isShowingError = false
            isConfirming = true
        } else {
            guard finalPasscode == passcode else {
                finalPasscode = ""
                passcode = ""
                isConfirming = false
                isShowingError = true
                return
            }
            completion()
        }
    }
    
    func deleteCharacter() {
        let currentLength = passcode.count
        
        guard currentLength > 0 else { return }
        
        let newPasscode = passcode.prefix(currentLength - 1)
        
        passcode = String(newPasscode)
    }
    
    func numberClicked(value: Int) {
        let digitString = String(describing: value)
        passcode.append(digitString)
        if passcode.count == 4 {
            finish()
        }
    }
    
    func checkPasscode(code: String) {
        if passcode.isEmpty { return }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Text(errorMessage)
                .modifier(TextMod(.caption, .semibold, isConfirming ? .black : .red))
            
            HStack(spacing: 15) {
                ForEach(1 ..< 5) { count in
                    Image(systemName: passcode.count >= count ? "circle.fill" : "circle")
                }
            }
            .frame(height: 20)
            .foregroundColor(primaryColor)
            
            VStack(spacing: 25) {
                ForEach(0 ..< 3) { row in
                    HStack(spacing: 20) {
                        ForEach(0 ..< 3) { column in
                            Button {
                                numberClicked(value: row + column + getRowFactor(for: row))
                            } label: {
                                Text("\(row + column + getRowFactor(for: row))")
                            }
                            .modifier(PasscodeButtonMod())
                            
                        }
                    } //: Hstack
                } //: For Each
                
                HStack(spacing: 20) {
                    Spacer()
                        .frame(width: 60)
                    
                    Button {
                        numberClicked(value: 0)
                    } label: {
                        Text("0")
                    }
                    .modifier(PasscodeButtonMod())
                    
                    Button {
                        deleteCharacter()
                    } label: {
                        Text("Delete")
                            .font(.caption)
                    }
                    .frame(width: 60, height: 60)
                    .foregroundColor(primaryColor)
                } //: HStack - Numbers 0 and backspace
                
            } //: VStack
            .foregroundColor(primaryColor)
        } //: VStack
    }
}

struct PasscodeButtonMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .modifier(TextMod(.title, .bold, .white))
            .multilineTextAlignment(.center)
            .frame(width: 60, height: 60)
            .background(primaryColor.cornerRadius(25))
            .overlay(Capsule().stroke(primaryColor, lineWidth: 3))
    }
}
