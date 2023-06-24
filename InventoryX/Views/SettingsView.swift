//
//  SettingsView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 6/4/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var navMan: NavigationManager
    
    enum Settings: CaseIterable {
        case resetAll
        case createDaySales
        case createSampleSales
        
        var action: () {
            switch self {
            case .resetAll:             return RealmMinion.deleteAllFromRealm()
            case .createDaySales:       return RealmMinion.createRandomSales(qty: 100)
            case .createSampleSales:    return RealmMinion.createRandomSalesToday(qty: 20)
            }
        }
        
        var buttonText: String {
            switch self {
            case .resetAll:             return "Erase All Data and Reset"
            case .createDaySales:       return "Create 100 Random Sales"
            case .createSampleSales:    return "Create 20 Random Sales Today"
            }
        }
    }
    
    var body: some View {
        VStack {
            headerToolbar
            Text("Settings")
                .modifier(TextMod(.largeTitle, .semibold, .black))
            
            ForEach(Settings.allCases, id: \.self) { setting in
                Button {
                    setting.action
                    if setting == .resetAll {
                        navMan.changeDisplay(to: .dashboard)
                    }
                } label: {
                    Text(setting.buttonText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .modifier(TextMod(.title3, .semibold, darkFgColor))
            } //: For Each
            
//            Button {
//                RealmMinion.deleteAllFromRealm()
//            } label: {
//                Text("Erase All Data and Reset")
//                    .frame(maxWidth: .infinity, alignment: .leading)
//            }
//            .padding()
//            .frame(height: 50)
//            .frame(maxWidth: .infinity)
//
//            Button {
//                RealmMinion.createRandomSales(qty: 100)
//            } label: {
//                Text("Create 100 Random Sales")
//                    .frame(maxWidth: .infinity, alignment: .leading)
//            }
//            .padding()
//            .frame(height: 50)
//            .frame(maxWidth: .infinity)
//
//            Button {
//                RealmMinion.createRandomSalesToday(qty: 20)
//            } label: {
//                Text("Create 20 Random Sales Today")
//                    .frame(maxWidth: .infinity, alignment: .leading)
//            }
//            .padding()
//            .frame(height: 50)
//            .frame(maxWidth: .infinity)
            
            Spacer()
        } //: VStack
        .background(secondaryBackground)
    }
    
    private var headerToolbar: some View {
        HStack(spacing: 24) {
            Button {
                navMan.toggleMenu()
            } label: {
                Image(systemName: "sidebar.squares.leading")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(primaryBackground)
            }
            Spacer()
            
            
            Button {
                navMan.toggleCartPreview()
            } label: {
                Image(systemName: navMan.detailSize == .hidden ? "cart" : "chevron.forward.2")
                    .resizable()
                    .scaledToFit()
//                    .frame(width: 30)
                    .foregroundColor(primaryBackground)
            } //: Button
            
        } //: HStack
        .modifier(TextMod(.body, .light, primaryBackground))
        .frame(height: toolbarHeight)
        .padding(.horizontal)
    } //: Header Toolbar
    
//    struct SettingsButton: View {
//        // This may not be the best way to accomplish. Find best way to make a list of buttons that appear the same but take up full width of container.
//        let action: () -> Void
//        var body: some View {
//            Button {
//                action()
//            } label: {
//                Text("Create 20 Random Sales Today")
//                    .frame(maxWidth: .infinity, alignment: .leading)
//            }
//            .padding()
//            .frame(height: 50)
//            .frame(maxWidth: .infinity)
//        } //: Body
//    } //: Settings Button
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
