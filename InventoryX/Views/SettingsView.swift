//
//  SettingsView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 6/4/23.
//

import SwiftUI
import RealmSwift

struct SettingsView: View {
    @Environment(NavigationService.self) var navService
//    @Environment(\.verticalSizeClass) var vSize
    @Environment(\.horizontalSizeClass) var hSize
    @EnvironmentObject var lsxVM: LSXViewModel
//    @StateObject var settingsVM: SettingsViewModel = SettingsViewModel()
    
//    @State var showPasscodeView: Bool = false
//    @State var showDeleteConfirmation: Bool = false
    
    @ObservedResults(CompanyEntity.self) var companies
    
    // This could be causing lock screen to dismiss on orientation change.
    @State var showingLockScreen: Bool = false
    
//    enum Detail { case account, passcode }
//    @State var currentDetail: Detail?
    
    private func lockTapped() {
        showingLockScreen.toggle()
    }
    
    
//    let menuSections: [[MenuButton]] = [
//        [.account, .passcode],
//        [.pos, .inventoryList],
//        //        [.settings],
//        [.lock]
//    ]
//    
//    enum MenuButton {
//        case account
//        case pos
//        case inventoryList
//        case settings
//        case lock
//        case passcode
//        
//        var iconName: String {
//            return switch self {
//            case .account:          "person.fill"
//            case .pos:              "cart.fill"
//            case .inventoryList:    "tray.full.fill"
//            case .settings:         "gearshape"
//            case .lock:             "lock"
//            case .passcode:         "asterisk"
//                //            default: ""
//            }
//        }
//        
//        var label: String {
//            return switch self {
//            case .account:          "Account"
//            case .pos:              "Make A Sale"
//            case .inventoryList:    "Inventory"
//            case .settings:         "Settings"
//            case .lock:             "Lock"
//            case .passcode:         "Change Passcode"
//                //            default: ""
//            }
//        }
//        
//        var destination: LSXDisplay {
//            return switch self {
//            case .account:          .company
//            case .pos:              .pos
//            case .inventoryList:    .inventoryList
//            case .settings:         .settings
//            case .lock:             .lock
//            case .passcode:         .passcodePad([.confirm, .set])
//            }
//        }
//    }
    
//    let mainDisplays: [LSXDisplay] = [.pos, .inventoryList, .settings]
    
    func pushView(_ view: LSXDisplay) {
        navService.path.append(view)
    }
    
    func changeTab(to view: LSXDisplay) {
        lsxVM.mainDisplay = view
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Profile")
                    .font(.title)
                    .fontWeight(.medium)
                
                VStack(spacing: 0) {
                    Button("Account", systemImage: "person") { pushView(.company) }
                        .buttonStyle(MenuButtonStyle())
                    FieldDivider()
                    Button("Change Passcode", systemImage: "asterisk") { pushView(.passcodePad([.confirm, .set])) }
                        .buttonStyle(MenuButtonStyle())
                } //: VStack
                .padding(0)
                .background(Color.fafafa)
                .modifier(RoundedOutlineMod(cornerRadius: 9))
                
                VStack(spacing: 0) {
                    Button("Make A Sale", systemImage: "cart") { changeTab(to: .pos) }
                        .buttonStyle(MenuButtonStyle())
                    FieldDivider()
                    Button("Inventory", systemImage: "tray.full") { changeTab(to: .inventoryList) }
                        .buttonStyle(MenuButtonStyle())
                } //: VStack
                .padding(0)
                .background(Color.fafafa)
                .modifier(RoundedOutlineMod(cornerRadius: 9))
                
                VStack(spacing: 0) {
                    Button("Lock", systemImage: "lock") { /*changeTab(to: .pos)*/ }
                        .buttonStyle(MenuButtonStyle())
                } //: VStack
                .padding(0)
                .background(Color.fafafa)
                .modifier(RoundedOutlineMod(cornerRadius: 9))
                
                VStack(spacing: 0) {
                    Link("Terms of Service", destination: K.termsOfServiceURL)                    .buttonStyle(MenuButtonStyle(trailingIcon: "arrow.up.right"))
                    FieldDivider()
                    Link("Privacy Policy", destination: K.privacyPolicyURL)
                        .buttonStyle(MenuButtonStyle(trailingIcon: "arrow.up.right"))
                } //: VStack
                .padding(0)
                .background(Color.fafafa)
                .modifier(RoundedOutlineMod(cornerRadius: 9))
                
                Text("© 2024 XAVware, LLC. All Rights Reserved.")
                    .padding(.leading)
                    .font(.caption2)
                    .opacity(0.8)
                
                Spacer()
            } //: VStack
            .padding(hSize == .regular ? 36 : 12)
            .padding()
            .background(.bg)
            .fontDesign(.rounded)
            .navigationTitle("")
            .fullScreenCover(isPresented: $showingLockScreen) {
                LockScreenView()
                    .frame(maxHeight: .infinity)
                    .background(Color.bg)
            }
        }
    } //: Body
    
    
}

#Preview {
    SettingsView()
        .environment(\.realm, DepartmentEntity.previewRealm)
        .environmentObject(LSXViewModel())
}
