//
//  Menu.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/19/24.
//

import SwiftUI

struct MenuView: View {
    // This could be causing lock screen to dismiss on orientation change.
    @State var showingLockScreen: Bool = false
    
    let menuButtons: [LSXDisplay] = [.pos, .inventoryList, .settings]
    
    func getButtonData(for display: LSXDisplay) -> (String, String)? {
        return switch display {
        case .pos:              ("Sale", "cart.fill")
        case .inventoryList:    ("Inventory", "tray.full.fill")
        case .settings:         ("Settings", "gearshape")
        default:                nil
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    NeomorphicCardView(layer: .over)
                    VStack {
                        ForEach(menuButtons, id: \.self) { display in
                            if let data = getButtonData(for: display) {
                                Button {
                                    LSXService.shared.update(newDisplay: display)
                                } label: {
                                    HStack(spacing: 24) {
                                        Image(systemName: data.1)
                                        Text(data.0)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                .buttonStyle(MenuButtonStyle())
                                
                                if display != .settings {
                                    FieldDivider()
                                }
                                
                            }
                        } //: For Each
                    } //: VStack
                } //: ZStack
                .frame(maxHeight: CGFloat(menuButtons.count) * 72)
                
                Spacer()
                
                ZStack {
                    NeomorphicCardView(layer: .over)
                    
                    Button {
                        showingLockScreen = true
                    } label: {
                        HStack(spacing: 24) {
                            Image(systemName: "lock")
                            Text("Lock")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .buttonStyle(MenuButtonStyle())
                } //: ZStack
                .frame(maxHeight: 48)
                
                
                VStack(spacing: 8) {
                    Text("© 2024 XAVware, LLC. All Rights Reserved.")
                    HStack(spacing: 6) {
                        Link("Terms of Service", destination: K.termsOfServiceURL)
                        Text("-")
                        Link("Privacy Policy", destination: K.privacyPolicyURL)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
                .font(.caption2)
                .padding(.top, 24)
                .foregroundStyle(.accent)
                .opacity(0.6)
//                .font(.caption2)
//                .padding()
                
            } //: VStack
            .padding(.vertical)
            .padding(.leading)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.bg)
            .fullScreenCover(isPresented: $showingLockScreen) {
                LockScreenView()
                    .frame(maxHeight: .infinity)
                    .background(Color.bg)
            }
            
        } //: Body
        
    }
}

#Preview {
    MenuView()
}

struct MenuButtonStyle: ButtonStyle {
    @Environment(\.verticalSizeClass) var vSize
    @Environment(\.horizontalSizeClass) var hSize

    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
//            .padding(vSize == .compact || hSize == .compact ? 10 : 14)
            .padding()
            .font(.title3)
            .fontDesign(.rounded)
            .background(Color.bg.opacity(0.01))
            .foregroundColor(Color.accent)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
