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
            Spacer()
            VStack {
                Spacer()
                PasscodeView(processes: [.confirm]) {
                    dismiss()
                }
                .frame(minHeight: 360, maxHeight: 600)
                Spacer()
            }
            .frame(maxWidth: 420)
        } //: HStack
        .frame(maxWidth: .infinity)
        .overlay(dateTimeLabel, alignment: .topLeading)
        .background(Color.bg)
    }
    
    private var dateTimeLabel: some View {
        VStack(spacing: 32) {
            DateTimeLabel()
        } //: VStack
        .padding(42)
    }
}

//#Preview {
//    LockScreenView()
//    
//}
