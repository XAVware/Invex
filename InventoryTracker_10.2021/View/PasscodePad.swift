    //
    //  PasscodePad.swift
    //  ConcessionTrackerComponents
    //
    //  Created by Smetana, Ryan on 6/16/21.
    //
    
    import SwiftUI
    
    struct PasscodePad: View {
        enum PadState {
            case setPasscode, enterPasscode
        }
        
        @State var padState: PadState
        
        @State var tempPasscode: String = ""
        @State var finalPasscode: String = ""
        
        @State var isShowingError: Bool = false
        @State var isShowingReEnter: Bool = false
        
        @State var finishAction: () -> Void
        
        let setPasscodeErrorMessage: String = "The passcodes you entered do not match. Please try again"
        let enterPasscodeErrorMessage: String = "The passcode you entered is incorrect."
                
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
                    Image(systemName: self.tempPasscode.count >= 1 ? "circle.fill" : "circle")
                    Image(systemName: self.tempPasscode.count >= 2 ? "circle.fill" : "circle")
                    Image(systemName: self.tempPasscode.count >= 3 ? "circle.fill" : "circle")
                    Image(systemName: self.tempPasscode.count == 4 ? "circle.fill" : "circle")
                }
                .frame(height: 20)
                .foregroundColor(Color.blue)
                
                
                VStack(spacing: 25) {
                    HStack(spacing: 20) {
                        PasscodePadButton(number: "1", tempPasscode: self.$tempPasscode) { self.finish() }
                        
                        PasscodePadButton(number: "2", tempPasscode: self.$tempPasscode) { self.finish() }
                        
                        PasscodePadButton(number: "3", tempPasscode: self.$tempPasscode) { self.finish() }
                    } //: HStack - Numbers 1 to 3
                    
                    HStack(spacing: 20) {
                        PasscodePadButton(number: "4", tempPasscode: self.$tempPasscode) { self.finish() }
                        
                        PasscodePadButton(number: "5", tempPasscode: self.$tempPasscode) { self.finish() }
                        
                        PasscodePadButton(number: "6", tempPasscode: self.$tempPasscode) { self.finish() }
                    } //: HStack - Numbers 4 to 6
                    
                    HStack(spacing: 20) {
                        PasscodePadButton(number: "7", tempPasscode: self.$tempPasscode) { self.finish() }
                        
                        PasscodePadButton(number: "8", tempPasscode: self.$tempPasscode) { self.finish() }
                        
                        PasscodePadButton(number: "9", tempPasscode: self.$tempPasscode) { self.finish() }
                    } //: HStack - Numbers 7 to 9
                    
                    HStack(spacing: 20) {
                        Spacer().frame(width: 60)
                        
                        PasscodePadButton(number: "0", tempPasscode: self.$tempPasscode) {
                            self.finish()
                        }
                        
                        Button(action: {
                            let currentLength = self.tempPasscode.count
                            
                            guard currentLength > 0 else {
                                return
                            }
                            
                            let newPasscode = tempPasscode.prefix(currentLength - 1)
                            
                            self.tempPasscode = String(newPasscode)
                        }, label: {
                            Text("Delete").font(.caption)
                        })
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color.blue)
                    } //: HStack - Numbers 0 and backspace
                }
                .foregroundColor(Color.blue)
                .padding()
            } //: VStack
        }
        
        func finish() {
            if self.finalPasscode == "" {
                self.finalPasscode = self.tempPasscode
                self.tempPasscode = ""
                self.isShowingError = false
                self.isShowingReEnter = true
            } else {
                guard self.finalPasscode == self.tempPasscode else {
                    self.finalPasscode = ""
                    self.tempPasscode = ""
                    self.isShowingReEnter = false
                    self.isShowingError = true
                    return
                }
                self.finishAction()
                
            }
        }
    }
    
