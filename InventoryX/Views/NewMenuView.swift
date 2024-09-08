//
//  NewMenuView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 9/7/24.
//

import SwiftUI

struct NewMenuView: View {
    @Binding var mainDisplay: LSXDisplay
    
    let menuSections: [[MenuButton]] = [
        [.account],
        [.pos, .inventoryList],
//        [.settings],
        [.lock]
    ]
    
    enum MenuButton {
        case account
        case pos
        case inventoryList
        case settings
        case lock
        
        var iconName: String {
            return switch self {
            case .account:          "person.fill"
            case .pos:              "cart.fill"
            case .inventoryList:    "tray.full.fill"
            case .settings:         "gearshape"
            case .lock:             "lock"
            }
        }
        
        var label: String {
            return switch self {
            case .account:          "Account"
            case .pos:              "Make A Sale"
            case .inventoryList:    "Inventory"
            case .settings:         "Settings"
            case .lock:             "Lock"
            }
        }
        
        var destination: LSXDisplay {
            return switch self {
            case .account:          .company
            case .pos:              .pos
            case .inventoryList:    .inventoryList
            case .settings:         .settings
            case .lock:             .lock
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                ForEach(menuSections, id: \.self) { sectionButtons in
                    ZStack {
                        NeomorphicCardView(layer: .over)
                        
                        VStack {
                            ForEach(sectionButtons, id: \.self) { menuButton in
                                Button {
                                    mainDisplay = menuButton.destination
                                } label: {
                                    HStack(spacing: 24) {
                                        Image(systemName: menuButton.iconName)
                                        Text(menuButton.label)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                                .buttonStyle(MenuButtonStyle())
                                
                                /// Put a divider between each button
                                if menuButton != sectionButtons.last {
                                    FieldDivider()
                                }
                            } //: For Each
                        } //: VStack
                        //                    .background(.clear)
                    } //: ZStack
                    .frame(maxHeight: CGFloat(sectionButtons.count) * 72)
                    
                    
                    /// Put a spacer between each menu section, but not at the bottom.
                    if sectionButtons != menuSections.last && sectionButtons != menuSections[0] {
                        Spacer()
                    }
                } //: For Each menuSection
                
                // MARK: - Footer
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
            } //: VStack
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.bg.ignoresSafeArea())
        } //: Scroll
    } //: Body
}

//
//#Preview {
//    NewMenuView()
//}
