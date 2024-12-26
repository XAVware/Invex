//
//  KeypadView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 11/18/24.
//

import SwiftUI

struct CurrencyFieldX: View {
    @Environment(\.horizontalSizeClass) var hSize
    @Environment(\.verticalSizeClass) var vSize
    @Environment(FormXViewModel.self) var formVM
    @State private var strValue: String = "0"
    @State private var toggleError: Bool = false
    @State private var errorMessage: String = ""
    private let save: (Double) -> Void
    
    @State var requiresPlaceholder: Bool = true
    
    init(amount: Double, save: @escaping (Double) -> Void) {
        // 12.10.24 Why is this initializing four times?
        self.strValue = amount.description
        self.save = save
    }
    
    @State private var formattedResult: AttributedString = AttributedString("")
    
    private func formatInput(_ input: String, requiresPlaceholder: Bool) -> AttributedString {
        var placeholders = AttributedString("")
        let parts = input.split(separator: ".")
        
        /// String value should show `00` as a placeholder when it contains a `.` but does not have any digits following it
        // Case: "123." -> needs "00" appended
        // Case: "123.4" -> needs "0" appended
        // Format number preceding decimal to include commas when need.
        if input.contains(".") && parts.count == 1 {
            placeholders = AttributedString("00")
        } else if input.contains(".") && parts.count == 2 {
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
        // Format dollar sign
        var dollarSign = AttributedString("$")
        dollarSign.font = .system(size: 36, weight: .light, design: .rounded)
        dollarSign.foregroundColor = Color.neoOverLight
        dollarSign.baselineOffset = 18
        dollarSign.kern = 6
        
        var attInt = AttributedString(integerPart)
        attInt.font = .system(size: 56, weight: .semibold, design: .rounded)
        attInt.foregroundColor = Color.textPrimary.opacity(0.8)
        
        // Further formatting is needed if the text contains a decimal
        var dec = AttributedString(input.contains(".") ? "." : "")
        dec.font = .system(size: 56, weight: .semibold, design: .rounded)
        dec.foregroundColor = Color.textPrimary.opacity(0.8)
        
        // Decimals
        var attributedDec = AttributedString(decimalPart)
        attributedDec.font = .system(size: 56, weight: .semibold, design: .rounded)
        attributedDec.foregroundColor = Color.textPrimary.opacity(0.8)
        attributedDec.kern = 1.5
        
        placeholders.font = .system(size: 56, weight: .semibold, design: .rounded)
        placeholders.foregroundColor = Color.textPrimary.opacity(requiresPlaceholder ? 1 : 0.3)
        placeholders.kern = 1.5
        
        return dollarSign + attInt + dec + attributedDec + placeholders
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
    
//    private var formattedInput: AttributedString {
//        let parts = input.split(separator: ".")
//        var result = AttributedString("")
//        
//        // Format dollar sign
//        var dollarSign = AttributedString("$")
//        dollarSign.font = .system(size: 36, weight: .light, design: .rounded)
//        dollarSign.foregroundColor = Color.neoOverLight
//        dollarSign.baselineOffset = 18
//        dollarSign.kern = 6
//        result += dollarSign
//        
//        // Format number preceding decimal to include commas when need.
//        var integerPart = String(parts.first ?? "")
//        if let intValue = Int(integerPart) {
//            let formatter = NumberFormatter()
//            formatter.numberStyle = .decimal
//            integerPart = formatter.string(from: NSNumber(value: intValue)) ?? ""
//        }
//        
//        var attInt = AttributedString(integerPart)
//        attInt.font = .system(size: 56, weight: .semibold, design: .rounded)
//        attInt.foregroundColor = Color.textPrimary.opacity(0.8)
//        result += attInt
//        
//        // Further formatting is needed if the text contains a decimal
//        if input.contains(".") {
//            var decimal = AttributedString(".")
//            decimal.font = .system(size: 56, weight: .semibold, design: .rounded)
//            decimal.foregroundColor = Color.textPrimary.opacity(0.8)
//            result += decimal
//            
//            // Decimals
//            let decimalPart = parts.count > 1 ? String(parts[1]) : ""
//            if !decimalPart.isEmpty {
//                var attDec = AttributedString(decimalPart)
//                attDec.font = .system(size: 56, weight: .semibold, design: .rounded)
//                attDec.foregroundColor = Color.textPrimary.opacity(0.8)
//                attDec.kern = 1.5
//                result += attDec
//            }
//            
//            // Placeholder zeros
//            var placeholderZeros = ""
//            if parts.count == 1 {
//                // Case: "123." -> needs "00" appended
//                placeholderZeros = "00"
//            } else if let decimalDigits = parts.last {
//                // Case: "123.4" -> needs "0" appended
//                let neededZeros = 2 - decimalDigits.count
//                if neededZeros > 0 {
//                    placeholderZeros = String(repeating: "0", count: neededZeros)
//                }
//            }
//            
//            if !placeholderZeros.isEmpty {
//                var placeholder = AttributedString(placeholderZeros)
//                placeholder.font = .system(size: 56, weight: .semibold, design: .rounded)
//                placeholder.foregroundColor = Color.textPrimary.opacity(requiresPlaceholder ? 0.3 : 0.8)
//                placeholder.kern = 1.5
//                result += placeholder
//            }
//        }
//        
//        return result
//    }
    
    
    var body: some View {
        let layout = vSize == .compact ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout(spacing: 24))
        VStack {
            Spacer()
            
            layout {
                Text(formattedResult)
                    .animation(.interactiveSpring, value: formattedResult)
                    .animation(.spring(), value: toggleError)
                    .padding()
                    .modifier(Shake(animatableData: toggleError ? 1 : 0))
                
                KeypadView(strValue: $strValue, tapKey: { key in
                    guard prevalidate(key) else { return }
                    switch key {
                    case ".":   decimalTapped()
                    case "<":   deleteTapped()
                    default:    numberTapped(key)
                    }
                    formattedResult = formatInput(strValue, requiresPlaceholder: requiresPlaceholder)
                })
                .frame(maxWidth: 480, maxHeight: 420)
                .padding(.vertical)
            } //: VStack
            .padding(.vertical)
            
            PrimaryButtonPanelX {
                var val = NSAttributedString(formattedResult).string
                
                if !val.contains(".") {
                    val.append(".00")
                } else if val.split(separator: ".").count == 2 {
                    let dec = val.split(separator: ".")[1]
                    print("Decimal: \(dec)")
                }
                formVM.closeContainer(withValue: val)
            } onSave: {
                let amt = NSAttributedString(formattedResult).string.replacingOccurrences(of: "$", with: "")
                guard let amount = Double(amt) else {
                    return
                }
                save(amount)
                formVM.forceClose()
            }
        } //: VStack
        .padding()
        .background(Color.bg)
        .onAppear {
            setPlaceholderVisibility()
            formattedResult = formatInput(strValue, requiresPlaceholder: requiresPlaceholder)
        }
        .onChange(of: self.strValue) { _, _ in
            validateAmount()
        }
    }
    
    private func prevalidate(_ key: String) -> Bool {
        /// If there were already two digits after the decimal, the only acceptable key is `< DELETE`
        if let pre = Decimal(string: strValue), pre.significantFractionalDecimalDigits == 2, key != "<"  {
            triggerError()
            return false
        }
        return true
    }
    
    // MARK: - Key Pad Functions
    /// Check that string is not empty before deleting character.
    private func deleteTapped() {
        guard !strValue.isEmpty else {
            triggerError()
            return
        }
        strValue.removeLast()
    }
    
    /// Confirm the string doesn't already contain a decimal before appending
    private func decimalTapped() {
        strValue.contains(".") ? triggerError() : strValue.append(".")
    }
    
    private func numberTapped(_ key: String) {
        // Before appending the character, confirm there won't be more than 2 decimal places.
        let parts = strValue.split(separator: ".")
        
        guard !(parts.count == 2 && parts[1].count == 2) else {
            triggerError()
            return
        }
        
        self.strValue += key
    }
    
    private func setPlaceholderVisibility() {
        let split = strValue.split(separator: ".")
        if split.count > 1, let val = Int(split[1]) {
            if val > 0 {
                requiresPlaceholder = true
            } else {
                guard let whole = split.first else { return }
                self.strValue = whole.description
                requiresPlaceholder = false
            }
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

// MARK: - Shake Animation
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
