//
//  OnboardingPasscodeView.swift
//  InventoryTracker_10.2021
//
//  Created by Ryan Smetana on 10/15/21.
//

import SwiftUI

struct OnboardingPasscodeView: View {
    var body: some View {
        VStack {
            Text("Finally, enter an admin passcode")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("ThemeColor"))
                .padding()
            
            Text("This passcode should be used by administrators to access features such as inventory adjustments")
                .font(.callout)
                .foregroundColor(Color("ThemeColor"))
                .multilineTextAlignment(.center)
            
            Spacer()
            
            
            PasscodePad(padState: .setPasscode, finishAction: {
//                self.savePasscodeAndProceed()
            })
                .padding()
        }
    }
    
    func savePasscodeAndProceed() {
//        self.displayState = .makeASale
    }
}

struct OnboardingPasscodeView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPasscodeView()
    }
}
