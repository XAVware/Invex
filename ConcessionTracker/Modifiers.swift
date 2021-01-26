//
//  Modifiers.swift
//  ConcessionTracker
//
//  Created by Ryan Smetana on 1/20/21.
//

import SwiftUI

struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.system(size: 24, weight: .semibold, design: .rounded))
            .foregroundColor(Color("ThemeColor"))
    }
}

struct HeaderModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundColor(Color("ThemeColor"))
            .frame(maxWidth: .infinity, maxHeight: 40)
    }
}

struct PlusMinusButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scaledToFit()
            .shadow(radius: 2)
            .frame(width: 40)
            .foregroundColor(Color("ThemeColor"))
    }
}

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .bold, design: .rounded))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(UITextAutocapitalizationType.words)
    }
}

struct MenuButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 24, weight: .semibold, design: .rounded))
            .frame(height: 60)
            .foregroundColor(.white)
    }
}

struct SaveButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 24, weight: .semibold, design: .rounded))
            .frame(maxWidth: 500, minHeight: 60)
            .background(Color("GreenBackground"))
    }
}

struct ListHeaderModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .opacity(0.8)
            .font(.system(size: 18, weight: .semibold, design: .rounded))
    }
}


struct IpadMiniPreviewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .previewLayout(.fixed(width: 1024, height: 768))
    }
}

