    //
    //  PasscodePad.swift
    //  ConcessionTrackerComponents
    //
    //  Created by Smetana, Ryan on 6/16/21.
    //
    
    import SwiftUI
    
    struct PasscodePad: View {
        let keypadValues = [["1", "2", "3"],
                            ["4", "5", "6"],
                            ["7", "8", "9"],
                            ["", "0", "Delete"]]
        
        enum PadState { case setPasscode, enterPasscode }
        
        @State var padState: PadState
        @Binding var storedPasscode: String //load from securitycoordinator
        
        
        @State var enteredPasscode: String          = ""
        @State var reEnteredPasscode: String        = ""
        @State var isShowingError: Bool             = false
        @State var isShowingReEnter: Bool           = false
        let setPasscodeErrorMessage: String         = "The passcodes you entered do not match. Please try again"
        let enterPasscodeErrorMessage: String       = "The passcode you entered is incorrect."
        
        var body: some View {
            VStack(spacing: 30) {
                
                if self.isShowingError {
                    Text(self.padState == .setPasscode ? setPasscodeErrorMessage : enterPasscodeErrorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                } else if self.isShowingReEnter {
                    Text("Re-Enter Your Passcode")
                        .fontWeight(.bold)
                        .foregroundColor(Color.blue)
                        .font(.caption)
                }
                
                HStack(spacing: 15) {
                    Image(systemName: self.enteredPasscode.count >= 1 ? "circle.fill" : "circle")
                    Image(systemName: self.enteredPasscode.count >= 2 ? "circle.fill" : "circle")
                    Image(systemName: self.enteredPasscode.count >= 3 ? "circle.fill" : "circle")
                    Image(systemName: self.enteredPasscode.count == 4 ? "circle.fill" : "circle")
                }
                .frame(height: 20)
                .foregroundColor(Color.blue)
                
                
                VStack(spacing: 25) {
                    
                    ForEach(0 ..< 4) { row in
                        HStack(spacing: 20) {
                            ForEach(0 ..< 3) { col in
                                if row == 3 && col == 0 {
                                    Spacer().frame(width: 60, height: 60)
                                } else if row == 3 && col == 2 {
                                    Button(action: {
                                        deleteClicked()
                                    }, label: {
                                        Text("Delete").font(.caption)
                                    })
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(Color.blue)
                                } else {
                                    PasscodePadButton(number: keypadValues[row][col]) {
                                        buttonClicked(value: keypadValues[row][col])
                                    }
                                    .frame(width: 60, height: 60)
                                }
                            }
                        } //: HStack
                    } //; ForEach
                } //: VStack
                .foregroundColor(Color.blue)
                .padding()
            } //: VStack
        }
        
        func finish() {
            if self.reEnteredPasscode == "" {
                self.reEnteredPasscode = self.enteredPasscode
                self.enteredPasscode = ""
                self.isShowingError = false
                self.isShowingReEnter = true
            } else {
                guard self.reEnteredPasscode == self.enteredPasscode else {
                    self.reEnteredPasscode = ""
                    self.enteredPasscode = ""
                    self.isShowingReEnter = false
                    self.isShowingError = true
                    return
                }
                storedPasscode = enteredPasscode
            }
        }
        
        func buttonClicked(value: String) {
            enteredPasscode.append(value)
            if enteredPasscode.count == 4 { finish() }
        }
        
        func deleteClicked() {
            guard enteredPasscode.count > 0 else { return }
            let newPasscode = enteredPasscode.prefix(enteredPasscode.count - 1)
            enteredPasscode = "\(newPasscode)"
        }
        
    }
