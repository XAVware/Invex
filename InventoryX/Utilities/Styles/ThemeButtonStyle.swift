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
            case .primary:      Color.primaryButtonText
            case .secondary:    Color.accent
            }
        }
    }
    
    @State var style: ThemeButtonStyle
    
    init(_ style: ThemeButtonStyle = .primary) {
        self.style = style
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(vSize == .compact || hSize == .compact ? 10 : 14)
            .background(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(style.bgColor)
            )
            .foregroundColor(style.fgColor)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
