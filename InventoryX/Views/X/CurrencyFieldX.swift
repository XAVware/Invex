//
//  KeypadView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 11/18/24.
//

import SwiftUI

struct CurrencyFieldX: View {
    @Environment(FormXViewModel.self) var formVM
    @State private var strValue: String = "0"
    @State private var toggleError: Bool = false
    @State private var errorMessage: String = ""
    @State private var requiresPlaceholder: Bool
    private let save: (Double) -> Void
    
    init(amount: Double, save: @escaping (Double) -> Void) {
        let amt = amount.description
        self.requiresPlaceholder = false
        self.save = save
    }
    
    // Validate entered amount
    private func validateAmount() {
        if let amount = Double(strValue), amount < 0 {
            toggleError = true
            errorMessage = "Please enter an amount greater than $0."
        } else {
            toggleError = false
            errorMessage = ""
        }
    }
    
    private var formattedInput: AttributedString {
        let s: String = strValue
        var placeholders = AttributedString("")
        let parts = s.split(separator: ".")
        
        /// String value should show `00` as a placeholder when it contains a `.` but does not have any digits following it
        if s.contains(".") && parts.count == 1 {
            placeholders = AttributedString("00")
        } else if s.contains(".") && parts.count == 2 {
            let decPart = parts[1]
            if decPart.count < 2 {
                placeholders = AttributedString(Array(repeating: "0", count: decPart.count))
            }
        }
         
        let decimalPart = parts.count > 1 ? parts.last! : ""
        var integerPart = String(parts.first ?? "")
        
        // Add commas to number before decimal as needed.
        if let intValue = Int(integerPart) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            integerPart = formatter.string(from: NSNumber(value: intValue)) ?? ""
        }
        
        var dollarSign = AttributedString("$")
        dollarSign.font = .system(size: 36, weight: .light, design: .rounded)
        dollarSign.foregroundColor = Color.neoOverDark
        dollarSign.baselineOffset = 18
        dollarSign.kern = 6
        
        var attInt = AttributedString(integerPart)
        attInt.font = .system(size: 56, weight: .semibold, design: .rounded)
        attInt.foregroundColor = Color.textPrimary.opacity(0.8)
        
        var dec = AttributedString(s.contains(".") ? "." : "")
        dec.font = .system(size: 56, weight: .semibold, design: .rounded)
        dec.foregroundColor = Color.textPrimary.opacity(0.8)
        
        var attributedDec = AttributedString(decimalPart)
        attributedDec.font = .system(size: 56, weight: .semibold, design: .rounded)
        attributedDec.foregroundColor = Color.textPrimary.opacity(0.8)
        attributedDec.kern = 1.5
        
        placeholders.font = .system(size: 56, weight: .semibold, design: .rounded)
        placeholders.foregroundColor = Color.neoOverDark
        placeholders.kern = 1.5
        
        return dollarSign + attInt + dec + attributedDec + placeholders
    }
    

    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 24) {
//                HStack(spacing: 4) {
                    
                Text(formattedInput)
                    .animation(.interactiveSpring, value: formattedInput)
                .animation(.spring(), value: toggleError)
                .padding()
                .modifier(Shake(animatableData: toggleError ? 1 : 0))
                
                KeypadView(strValue: $strValue, tapKey: { key in
                    /// If there were already two digits after the decimal, the only acceptable key is `< DELETE`
                    if let pre = Decimal(string: strValue), pre.significantFractionalDecimalDigits == 2, key != "<"  {
                        triggerError()
                        return
                    }
                    
                    switch key {
                    case ".":
                        /// Confirm the string doesn't already contain a decimal before appending
                        strValue.contains(".") ? triggerError() : strValue.append(".")

                    case "<":
                        /// Check that string is not empty before deleting character.
                        guard !strValue.isEmpty else {
                            triggerError()
                            return
                        }
                        strValue.removeLast()

                    default:
                        self.strValue += key
                    }
                   
                })
                    .frame(maxHeight: 420)
                    .padding(.vertical)
            } //: VStack
            .padding(.vertical)

            PrimaryButtonPanelX {
                formVM.closeContainer(withValue: self.strValue)
            } onSave: {
                let amt = NSAttributedString(formattedInput).string.replacingOccurrences(of: "$", with: "")
                guard let amount = Double(amt) else {
                    return
                }
                save(amount)
                formVM.forceClose()
            }
        } //: VStack
        .padding()
        .background(Color.bg)
        .onChange(of: self.strValue) { _, _ in
            validateAmount()
        }
    }
    
    private func triggerError() {
        withAnimation(.default) {
            toggleError = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            toggleError = false
        }
    }
}

#Preview {
    CurrencyFieldX(amount: 0, save: { val in
        
    })
        .background(Color.bg)
        .environment(FormXViewModel())
}

struct Shake: GeometryEffect {
    var distance: CGFloat = 8
    var count: CGFloat = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            distance * sin(animatableData * .pi * count), y: 0))
    }
}

extension Decimal {
    var significantFractionalDecimalDigits: Int {
        return max(-exponent, 0)
    }
}
