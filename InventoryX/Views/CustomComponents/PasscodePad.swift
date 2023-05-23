//
//  PasscodePad.swift
//  ConcessionTrackerComponents
//
//  Created by Smetana, Ryan on 6/16/21.
//

import SwiftUI

struct PasscodePad: View {
    enum PadState { case createPasscode, enterPasscode }
    
    @State var padState: PadState
    @State var completion: (String) -> Void
    @State var firstPasscode: String
    
    @State var passcode: String = ""
    @State var isShowingError: Bool = false
    
    var isConfirming: Bool {
        return firstPasscode.isEmpty ? false : true
    }
    
    var errorMessage: String {
        guard isShowingError else { return "" }
        switch padState {
        case .createPasscode:
            return "The passcodes you entered do not match. Please try again"
        case .enterPasscode:
            return "The passcode you entered is incorrect."
        }
    }
    
    var headerText: String {
        switch padState {
        case .createPasscode:
            return isConfirming ? "Re-Enter Passcode" : "Enter Passcode"
        case .enterPasscode:
            return "Enter Passcode"
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
    
    func deleteCharacter() {
        guard passcode.count > 0 else { return }
        passcode = String(passcode.prefix(passcode.count - 1))
    }
    
    func numberClicked(value: Int) {
        isShowingError = false
        let digitString = String(describing: value)
        passcode.append(digitString)
        if passcode.count == 4 {
            comparePasscodes()
            passcode = ""
        }
    }
    
    func comparePasscodes() {
        switch padState {
        case .createPasscode:
            if isConfirming == false {
                firstPasscode = passcode
            } else {
                if firstPasscode == passcode {
                    completion(passcode)
                } else {
                    firstPasscode = ""
                    isShowingError = true
                }
            }
            
        case .enterPasscode:
            if firstPasscode == passcode {
                completion(passcode)
            } else {
                isShowingError = true
            }
        }
    }
    
    init(passcode: String = "", padState: PadState, completion: @escaping (String) -> Void) {
        if padState == .enterPasscode && passcode.count != 4 {
            fatalError("Passcode pad set to .confirmPasscode but provided passcode is not correct length.")
        }
        self.padState = padState
        self.firstPasscode = passcode
        self.completion = completion
    }
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 16) {
                Text(headerText)
                    .modifier(TextMod(.largeTitle, .semibold, .black))
                
                Text(errorMessage)
                    .modifier(TextMod(.caption, .semibold, (!isConfirming || padState == .enterPasscode) ? .red : .black))
            }
            
            HStack(spacing: 15) {
                ForEach(1 ..< 5) { count in
                    Image(systemName: passcode.count >= count ? "circle.fill" : "circle")
                }
            }
            .frame(height: 20)
            .foregroundColor(primaryColor)
            .padding(.vertical)
            .padding(.bottom, 16)
            
            VStack(spacing: 25) {
                ForEach(0 ..< 3) { row in
                    HStack(spacing: 20) {
                        ForEach(0 ..< 3) { column in
                            Button {
                                numberClicked(value: row + column + getRowFactor(for: row))
                            } label: {
                                Text("\(row + column + getRowFactor(for: row))")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .modifier(PasscodeButtonMod())
                    
                    Button {
                        deleteCharacter()
                    } label: {
                        Image(systemName: "delete.left")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30)
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


struct PasscodePad_Previews: PreviewProvider {
    static var previews: some View {
        PasscodePad(passcode: "", padState: .createPasscode, completion: { confirmedPasscode in })
            .previewLayout(.sizeThatFits)
            .padding()
    }
}


