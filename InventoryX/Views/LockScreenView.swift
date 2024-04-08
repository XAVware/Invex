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
//                Spacer()
                DateTimeLabel()
                    .padding(.top, 48)
                Spacer()
            } //: VStack
            .frame(maxWidth: 420)
//            Spacer()
            
            VStack(alignment: .center) {
                Spacer()
                Text("Enter Passcode")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                
                PasscodeView(processes: [.confirm], showTitles: false, onSuccess: {
                    dismiss()
                })
                .frame(minHeight: 550, maxHeight: 600)

            } //: VStack
            
//            .frame(maxWidth: 360, maxHeight: 540, alignment: .center)
            
        } //: HStack
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    LockScreenView()
}
