//
//  Modifiers.swift
//  XAV_Customs
//
//  © 2023 XAVware, LLC.
//
// ~~~~~~~~~~~~~~~ README ~~~~~~~~~~~~~~~
//

import SwiftUI

struct TextMod: ViewModifier {
    let font: Font
    let weight: Font.Weight
    let fgColor: Color
    
    init(_ font: Font = .body, _ weight: Font.Weight = .semibold, _ fgColor: Color = .black) {
        self.font = font
        self.weight = weight
        self.fgColor = fgColor
    }
    
    func body(content: Content) -> some View {
        content
            .font(self.font)
            .fontWeight(self.weight)
            .foregroundColor(self.fgColor)
            .fontDesign(.rounded)
    }
}
