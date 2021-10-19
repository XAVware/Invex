//
//  PasscodePadButton.swift
//  ConcessionTracker
//
//  Created by Smetana, Ryan on 6/17/21.
//

import SwiftUI


struct PasscodePadButton: View {
    @State var number: String
    @State var onClick: () -> Void
    @State var pressed: Bool = false
    
    var body: some View {
        Button(action: {
            if self.pressed {
                self.onClick()
            }
        }, label: {
            Text(self.number)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundColor(self.pressed ? Color.white : Color.blue)
        })
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                self.pressed = true
            }
            withAnimation(.easeInOut(duration: 0.2)) {
                self.pressed = false
            }
        }
        .onLongPressGesture(minimumDuration: 0.2, maximumDistance: .infinity, pressing: { pressing in
            self.pressed = pressing
        }, perform: { })
        .frame(width: 60, height: 60)
        .background(Color.blue.cornerRadius(25).opacity(self.pressed ? 1.0 : 0.0))
        .overlay(Capsule().stroke(Color.blue, lineWidth: 3))
    }
    
}
