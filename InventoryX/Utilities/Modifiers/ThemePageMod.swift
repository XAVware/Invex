//
//  ThemeForm-Mod.swift
//  InventoryX
//
//  Created by Ryan Smetana on 11/1/24.
//

import SwiftUI


struct ThemePageMod: ViewModifier {
    @Environment(\.horizontalSizeClass) var hSize
    func body(content: Content) -> some View {
        content
        
    }
}

struct ThemeForm<C: View>: View {
    @Environment(\.horizontalSizeClass) var hSize
    
    let content: C
    @State var title: String?
    
    init(title: String? = "", @ViewBuilder content: (() -> C)) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                if let title = title {
                    Text(title)
                        .font(.largeTitle)
                }
                content
                Spacer()
            }
            .padding(hSize == .regular ? 48 : 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .fontDesign(.rounded)
        }
        .background(.bg)
        .scrollIndicators(.hidden)
        .overlay(
            Divider()
            .background(Color.accentColor.opacity(0.01)), alignment: .top)
    }
    
}

struct ThemeFormSection<C: View>: View {
    @Environment(\.horizontalSizeClass) var hSize
    
    let content: C
    @State var title: String = ""
    
    init(title: String, @ViewBuilder content: (() -> C)) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title2)
                .fontWeight(.medium)
            
            content
                .padding(0)
                .background(Color.fafafa)
                .modifier(RoundedOutlineMod(cornerRadius: 9))
        }
        .padding(.vertical, 8)
    }
    
}
