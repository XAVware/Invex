//
//  KeypadX.swift
//  InventoryX
//
//  Created by Ryan Smetana on 11/26/24.
//

import SwiftUI

/*
 - Commas are added as needed for numbers 1,000 and up.
 - Error animation is triggered when user:
    - attempts to delete all digits - 0 will always be displayed;
    - attempts to add two decimal places
    - attempts to add a third digit after a decimal
 
 - If the value contains a decimal that is not followed by two digits, placeholder zeros (00) are displayed for each missing decimal.
 - When the user deletes the character following the decimal, the decimal and the placeholders are removed.
 */

// MARK: - KeypadX
struct KeypadX: View {
    private let gridSpacing: CGFloat = 1
    @Binding var strValue: String
    let tapKey: (String) -> Void
    
    var body: some View {
        VStack(spacing: gridSpacing) {
            ForEach(1 ..< 4) { row in
                HStack(spacing: gridSpacing) {
                    ForEach(1..<4) { col in
                        let number = (row - 1) * 3 + col
                        KeypadXButton(number: "\(number)") {
                            tapKey(number.description)
                        }
                    }
                } //: HStack
            }
            
            // Last row
            HStack(spacing: gridSpacing) {
                KeypadXButton(number: ".") {
                    tapKey(".")
                }
                .fontWeight(.black)
                
                KeypadXButton(number: "0") {
                    tapKey("0")
                }
                
                KeypadXButton(symbol: "delete.left") {
                    tapKey("<")
                }
            } //: HStack
        } //: VStack
    } //: Body
    
}


// MARK: - Keypad Button View
struct KeypadXButton: View {
    enum KeypadButtonShape { case round, none }
    var number: String? = nil
    var symbol: String? = nil
    var action: () -> Void
    
    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred(intensity: 0.9)
            action()
        } label: {
            if let number = number {
                Text(number)
                    .font(.title)
                    .foregroundColor(Color.textPrimary)
            }
            
            if let symbol = symbol {
                Image(systemName: symbol)
                    .font(.title)
                    .foregroundColor(Color.textPrimary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .font(.largeTitle)
        .foregroundColor(Color.textPrimary)
        .background {
            GeometryReader { geo in
                let w: CGFloat = geo.size.width
                RoundedRectangle(cornerRadius: 6)
                    .fill(RadialGradient(colors: [
                        Color.accentColor.opacity(0.007),
                        Color.clear
                    ], center: .center, startRadius: w / 4, endRadius: w / 2))
            }
        }
        .buttonStyle(KeypadXButtonStyle())
    }
}


// MARK: - Button Style
struct KeypadXButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.interpolatingSpring(duration: 0.1), value: configuration.isPressed)
    }
}
