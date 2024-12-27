//
//  ThemeButtonStyle.swift
//  InventoryX
//
//  Created by Ryan Smetana on 8/30/24.
//

import SwiftUI

struct ThemeButtonStyle: ButtonStyle {
    @Environment(\.verticalSizeClass) var vSize
    @Environment(\.horizontalSizeClass) var hSize
    @State var style: ThemeButtonStyle
    @State var radius: CGFloat
    
    init(_ style: ThemeButtonStyle = .primary, cornerRadius: CGFloat = 32) {
        self.style = style
        self.radius = cornerRadius
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(vSize == .compact || hSize == .compact ? 10 : 14)
            .background(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(style.bgColor)
            )
            .foregroundColor(style.fgColor)
            .frame(maxWidth: 480, alignment: .center)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
        
    }
}

extension ThemeButtonStyle {
    /// Primary style appear with the accent color as the background, while secondary appears with accent as foreground
    enum ThemeButtonStyle {
        case primary
        case secondary
        
        var bgColor: AnyGradient {
            return switch self {
            case .primary:      Color.accent.gradient
            case .secondary:    Color.clear.gradient
            }
        }
        
        var fgColor: Color {
            return switch self {
            case .primary:      Color.textLight
            case .secondary:    Color.accent
            }
        }
    }
}
