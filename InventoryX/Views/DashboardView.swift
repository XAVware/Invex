//
//  DashboardView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 6/5/23.
//

import SwiftUI

struct DashboardView: View {
    @State var currentDisplay: DisplayStates = .makeASale
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic
    
    
    var body: some View {
        GeometryReader { geo in
            
            VStack {
                HStack(spacing: 0.02 * geo.size.width) {
                    
                    Spacer()
                    
                    signOutButton
                        .frame(maxWidth: 0.15 * geo.size.width, maxHeight: 0.1 * geo.size.height)
                        .padding()
                        .background(Color(XSS.S.color90))
                        .cornerRadius(16)
                        .shadow(radius: 8)
                } //: HStack
                .frame(maxWidth: .infinity)
                
                
                
                Spacer()
                
                HStack {
                    inventoryButton
                        .frame(maxWidth: 0.25 * geo.size.width, maxHeight: 0.15 * geo.size.height)
                        .padding()
                        .background(Color(XSS.S.color90))
                        .cornerRadius(16)
                        .shadow(radius: 8)
                    Spacer()
                    makeASaleButton
                        .frame(width: 0.50 * geo.size.width, height: 0.15 * geo.size.height)
                        .padding()
                        .background(primaryBackground)
                        .cornerRadius(16)
                        .shadow(radius: 8)
                }
            } //: VStack
            .frame(maxWidth: .infinity)
            .padding()
            .background(secondaryBackground)
            
        } //: Geometry Reader
    } //: Body
    
    private var makeASaleButton: some View {
        Button {
            
        } label: {
            VStack(alignment: .leading) {
                Image(systemName: "dollarsign")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                    .modifier(TextMod(.title, .bold, lightFgColor))
                Spacer()
            } //: VStack
            
            VStack(alignment: .trailing) {
                Spacer()
                Text("Make A Sale")
                    .modifier(TextMod(.largeTitle, .semibold, lightFgColor))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            } //: VStack
        } //: Button
    } //: Make A Sale Button
    
    private var inventoryButton: some View {
        Button {
            
        } label: {
            VStack(alignment: .leading) {
                Image(systemName: DisplayStates.inventoryList.iconName)
                    .resizable()
                    .scaledToFit()
                //                            .modifier(TextMod(.title, .bold, lightFgColor))
                Spacer()
            } //: VStack
            .frame(width: 30)
            .modifier(TextMod(.largeTitle, .semibold, darkFgColor))
            
            VStack(alignment: .trailing) {
                Spacer()
                Text("Inventory")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            } //: VStack
            .modifier(TextMod(.largeTitle, .semibold, darkFgColor))
            
        } //: Button
    } //: Inventory Button
    
    private var settingsButton: some View {
        Button {
            
        } label: {
            VStack(alignment: .leading) {
                Image(systemName: DisplayStates.settings.iconName)
                    .resizable()
                    .scaledToFit()
                //                            .modifier(TextMod(.title, .bold, lightFgColor))
                Spacer()
            } //: VStack
            .frame(width: 30)
            .modifier(TextMod(.largeTitle, .semibold, darkFgColor))
            
            VStack(alignment: .trailing) {
                Spacer()
                Text("Settings")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            } //: VStack
            .modifier(TextMod(.largeTitle, .semibold, darkFgColor))
            
        } //: Button
    } //: Settings Button
    
    private var salesButton: some View {
        Button {
            
        } label: {
            VStack(alignment: .leading) {
                Image(systemName: DisplayStates.salesHistory.iconName)
                    .resizable()
                    .scaledToFit()
                //                            .modifier(TextMod(.title, .bold, lightFgColor))
                Spacer()
            } //: VStack
            .frame(width: 30)
            .modifier(TextMod(.largeTitle, .semibold, darkFgColor))
            
            VStack(alignment: .trailing) {
                Spacer()
                Text("Sales")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            } //: VStack
            .modifier(TextMod(.largeTitle, .semibold, darkFgColor))
            
        } //: Button
    } //: Sales Button
    
    private var signOutButton: some View {
        Button {
            
        } label: {
            VStack(alignment: .leading) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .resizable()
                    .scaledToFit()
                //                            .modifier(TextMod(.title, .bold, lightFgColor))
                Spacer()
            } //: VStack
            .frame(width: 30)
            .modifier(TextMod(.body, .semibold, darkFgColor)) 
            
            VStack(alignment: .trailing) {
                Spacer()
                Text("Sign Out")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            } //: VStack
            .modifier(TextMod(.largeTitle, .semibold, darkFgColor))
            
        } //: Button
    } //: Inventory Button
    
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .modifier(PreviewMod())
    }
}
