//
//  LockScreenView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/18/24.


import SwiftUI

struct LockScreenView: View {
    @Environment(\.dismiss) var dismiss
    let uiProperties: LayoutProperties
    var body: some View {
        HStack {
            if uiProperties.width > 840 {
                VStack(alignment: .leading) {
//                    Spacer()
                    DateTimeLabel()
                        .padding(.top, 48)
                    Spacer()
                } //: VStack
                .frame(maxWidth: 420)
            }
            
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
        } //: HStack
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ResponsiveView { props in
        LockScreenView(uiProperties: props)
    }
}
