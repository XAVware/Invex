////
////  KeypadView.swift
////  InventoryX
////
////  Created by Ryan Smetana on 11/26/24.
////

import SwiftUI

/*
 - Decimal key is disabled and hidden when the bound value already contains a decimal.
 - Bound value is reset to 0 when the input is entirely deleted.
 - Keypad buttons fill full frame width. Width should be controlled by parent.
 - Keypad buttons adjust their height to match the width.
 - Keypad buttons can have their `shape` set to add a shape to the background.
 - Validation should be done in parent.
 */

// MARK: - KeypadView
struct KeypadView: View {
    let gridSpacing: CGFloat = 1
    @Binding var strValue: String
    
    let defMaxWidth: CGFloat = 360
    let defMaxHeight: CGFloat = 420
    
    let tapKey: (String) -> Void
    
    var body: some View {
        VStack(spacing: gridSpacing) {
            ForEach(1 ..< 4) { row in
                HStack(spacing: gridSpacing) {
                    ForEach(1..<4) { col in
                        let number = (row - 1) * 3 + col
                        KeypadButton(number: "\(number)") {
                            tapKey(number.description)
                        }
                    }
                } //: HStack
            }
            
            // Last row
            HStack(spacing: gridSpacing) {
                KeypadButton(number: ".") {
                    tapKey(".")
                }
                .fontWeight(.black)
                
                KeypadButton(number: "0") {
                    tapKey("0")
                }
                
                KeypadButton(symbol: "delete.left") {
                    tapKey("<")
                }
            } //: HStack
        } //: VStack
        
    } //: Body
    
}


// MARK: - Keypad Button View
struct KeypadButton: View {
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
        .buttonStyle(NumberPadButtonStyle())
    }
    
    // MARK: - Button Style
    struct NumberPadButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .opacity(configuration.isPressed ? 0.7 : 1.0)
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .animation(.interpolatingSpring(duration: 0.1), value: configuration.isPressed)
        }
    }
}


