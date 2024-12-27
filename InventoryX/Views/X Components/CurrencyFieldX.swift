//
//  CurrencyFieldX.swift
//  InventoryX
//
//  Created by Ryan Smetana on 11/18/24.
//

import SwiftUI

struct CurrencyFieldX: View {
    @Environment(\.horizontalSizeClass) var hSize
    @Environment(\.verticalSizeClass) var vSize
    @Environment(FormXViewModel.self) var formVM
    @State private var strValue: String = ""
    @State private var toggleError: Bool = false
    @State private var errorMessage: String = ""
    @State private var requiresPlaceholder: Bool = true
    @State private var formattedResult: AttributedString = AttributedString("")
    private let save: (Double) -> Void

    init(amount: Double, save: @escaping (Double) -> Void) {
        // 12.10.24 Why is this initializing four times?
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        self.strValue = formatter.string(from: NSNumber(value: amount))?.replacingOccurrences(of: ",", with: "") ?? "0.00" 
        self.save = save
    }
    
    var body: some View {
        @Bindable var formVM: FormXViewModel = self.formVM
        let layout = vSize == .compact ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout(spacing: 24))
        VStack {
//            Spacer()
            
            layout {
//                if vSize == .regular {
                VStack {
                    if vSize == .compact {
                        VStack(alignment: .leading, spacing: 8) {
                            // Title is displayed large like th
                            Text("Retail Price")
                                .font(.largeTitle)
                            
                            Text("How much do you sell it for?")
                                .opacity(0.5)
                                .padding(.trailing, 48)
                                .font(.headline)
                        } //: VStack
                    }
                    
                    Text(formattedResult)
                        .animation(.interactiveSpring, value: formattedResult)
                        .animation(.spring(), value: toggleError)
                        .padding()
                        .modifier(Shake(animatableData: toggleError ? 1 : 0))
                }
//                }
                
                KeypadX(strValue: $strValue, tapKey: { key in
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
                }
                formVM.closeContainer(withValue: val)
            } onSave: {
                let amt = NSAttributedString(formattedResult).string.replacingOccurrences(of: "$", with: "")
                print(amt)
                guard let amount = Double(amt) else {
                    return
                }
                save(amount)
                formVM.forceClose()
            }
        } //: VStack
        .padding()
        .background(Color.bg100)
        .onAppear {
            setPlaceholderVisibility()
            formattedResult = formatInput(strValue, requiresPlaceholder: requiresPlaceholder)
        }
        .onChange(of: self.strValue) { _, _ in
            validateAmount()
        }
        .onChange(of: vSize) { oldValue, newValue in
            if newValue == .compact {
                formVM.labelsHidden = true
            } else {
                formVM.labelsHidden = false
            }
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
     
    // MARK: - Key Pad Functions
    /// Check that string is not empty before deleting character.
    private func deleteTapped() {
        guard !strValue.isEmpty else {
            triggerError()
            return
        }
        
        requiresPlaceholder = false
        
        strValue.removeLast()
        // If we're about to delete the decimal point, remove the whole decimal portion
        if strValue.last == "." {
            strValue = String(strValue.dropLast())
            return
        }
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
    
    // MARK: - Text field formatting
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    private func formatInput(_ input: String, requiresPlaceholder: Bool) -> AttributedString {
        let parts = input.split(separator: ".")
        var result = AttributedString("")
        
        // Cache shared attributes
        let mainFont = Font.system(size: 56, weight: .semibold, design: .rounded)
        let mainColor = Color.textDark.opacity(0.8)
        
        // Add components with shared attributes
        result += dollarSign()
        result += integerPart(parts.first ?? "", font: mainFont, color: mainColor)
        
        if input.contains(".") {
            result += decimalComponents(parts: parts, font: mainFont, color: mainColor, requiresPlaceholder: requiresPlaceholder)
        }
        
        return result
    }
    
    // Break into smaller, focused functions
    private func dollarSign() -> AttributedString {
        var sign = AttributedString("$")
        sign.font = .system(size: 36, weight: .light, design: .rounded)
        sign.foregroundColor = Color.textDark.opacity(0.6)
        sign.baselineOffset = 18
        sign.kern = 6
        return sign
    }
    
    private func integerPart(_ str: String.SubSequence, font: Font, color: Color) -> AttributedString {
        let formatted = numberFormatter.string(from: NSNumber(value: Int(String(str)) ?? 0)) ?? ""
        var result = AttributedString(formatted)
        result.font = font
        result.foregroundColor = color
        return result
    }
    
    private func decimalComponents(parts: [String.SubSequence], font: Font, color: Color, requiresPlaceholder: Bool) -> AttributedString {
        var result = AttributedString(".")
        result.font = font
        result.foregroundColor = color
        
        if let decPart = parts[safe: 1] {
            var dec = AttributedString(String(decPart))
            dec.font = font
            dec.foregroundColor = color  // Remove opacity here
            dec.kern = 1.5
            result += dec
            
            // Only placeholder zeros get reduced opacity
            if decPart.count < 2 {
                var zeros = AttributedString(String(repeating: "0", count: 2 - decPart.count))
                zeros.font = font
                zeros.foregroundColor = color.opacity(requiresPlaceholder ? 1 : 0.3)
                zeros.kern = 1.5
                result += zeros
            }
        } else {
            var zeros = AttributedString("00")
            zeros.font = font
            zeros.foregroundColor = color.opacity(requiresPlaceholder ? 1 : 0.3)
            zeros.kern = 1.5
            result += zeros
        }
        
        return result
    }
}

#Preview {
    CurrencyFieldX(amount: 0, save: { val in
        
    })
    .background(Color.bg100)
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

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
