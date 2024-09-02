
//  LockScreenView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/18/24.


import SwiftUI

struct NumberPadView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var passcode: String
    
    private func addValue(_ value: Int) {
        if passcode.count < 4 {
            passcode += "\(value)"
        }
    }
    
    private func removeValue() {
        if !passcode.isEmpty {
            passcode.removeLast()
        }
    }
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
            ForEach(1 ... 9, id: \.self) { number in
                Button("\(number)") {
                    addValue(number)
                }
                .buttonStyle(NumberPadButtonStyle())
            }
            
            Button("", systemImage: "delete.backward") {
                removeValue()
            }
            .buttonStyle(NumberPadButtonStyle())

            Button("0") {
                passcode.append("0")
            }
            .buttonStyle(NumberPadButtonStyle())
            
        } //: Lazy V Grid
        .foregroundStyle(.primary)
    }
    
    
}

//#Preview {
//    NumberPadView(passcode: .constant(""))
//}
struct NumberPadButtonStyle: ButtonStyle {
    @Environment(\.verticalSizeClass) var vSize
    @Environment(\.horizontalSizeClass) var hSize
    @Environment(\.colorScheme) var colorScheme
    

    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
//            .padding(vSize == .compact || hSize == .compact ? 10 : 14)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .font(.title3)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        .shadow(.inner(color: configuration.isPressed ? .neoUnderLight : .neoOverLight,
                                       radius: 2,
                                       x: configuration.isPressed ? -2 : 2,
                                       y: configuration.isPressed ? -2 : 2 ))
                        .shadow(.inner(color: configuration.isPressed ? .neoUnderDark : .neoOverDark,
                                       radius: 2,
                                       x: configuration.isPressed ? 2 : -2,
                                       y: configuration.isPressed ? 2 : -2))
                        
                    )
                    .shadow(color: configuration.isPressed ? .clear : .neoOverDark, radius: 2, x: 2, y: 2)
                    .foregroundColor(.bg)
                    .blendMode(colorScheme == .dark ? .plusLighter : .plusDarker)
            )
            .foregroundColor(Color.textPrimary)
//            .opacity(configuration.isPressed ? 0.7 : 1.0)
//            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.interpolatingSpring(duration: 0.1), value: configuration.isPressed)
    }
}
