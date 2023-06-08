//
//  DashboardView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 6/5/23.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var navMan: NavigationManager
    @State var currentDisplay: DisplayStates = .makeASale
//    @State private var columnVisibility = NavigationSplitViewVisibility.automatic
    
    var dateString: String {
        let date = Date.now
        var string: String = ""
        let weekday = date.formatted(.dateTime.weekday(.wide))
        string.append("\(weekday), ")
        let monthAndDay = "\(Date.now.formatted(.dateTime.month(.wide).day(.defaultDigits)))"
        string.append(monthAndDay)
        return string
    }
    
    var body: some View {
        GeometryReader { geo in
            
            HStack(spacing: 0.03 * geo.size.width) {
                VStack(alignment: .leading, spacing: 0.03 * geo.size.width) {
                    HStack(spacing: 0) {
                        Text("Inventory")
                            .modifier(TextMod(.title, .semibold, Color(XSS.S.color30)))
                            .offset(y: -2)
                        
                        Text("X")
                            .modifier(TextMod(.largeTitle, .semibold, Color(XSS.S.color30)))
                            .italic()
                            .offset(x: -2)
                    } //: HStack
                    .foregroundColor(Color(XSS.S.color30))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .scaleEffect(1.5, anchor: .leading)
                    
                    Spacer()
                    settingsButton
                        .frame(maxWidth: 0.24 * geo.size.width, maxHeight: 0.15 * geo.size.height)
                        .padding()
                        .background(Color(XSS.S.color90))
                        .cornerRadius(16)
                        .shadow(radius: 8)
                    
                    salesButton
                        .frame(maxWidth: 0.24 * geo.size.width, maxHeight: 0.15 * geo.size.height)
                        .padding()
                        .background(Color(XSS.S.color90))
                        .cornerRadius(16)
                        .shadow(radius: 8)
                    
                    inventoryButton
                        .frame(maxWidth: 0.24 * geo.size.width, maxHeight: 0.15 * geo.size.height)
                        .padding()
                        .background(Color(XSS.S.color90))
                        .cornerRadius(16)
                        .shadow(radius: 8)
                } //: VStack
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .trailing, spacing: 0.03 * geo.size.width) {
                    HStack(spacing: 0.02 * geo.size.width) {
                        Spacer()
                        dateTimeLabel
                    } //: HStack
                    Spacer()
                    
                    makeASaleButton
                        .frame(maxWidth: 0.40 * geo.size.width, maxHeight: 0.15 * geo.size.height)
                        .padding()
                        .background(primaryBackground)
                        .cornerRadius(16)
                        .shadow(radius: 8)
                } //: VStack
                .frame(maxWidth: 0.40 * geo.size.width)
                
                
                
                
            } //: VStack
            .frame(maxWidth: .infinity)
            .padding()
            
        } //: Geometry Reader
    } //: Body
    
    private var dateTimeLabel: some View {
        VStack(alignment: .trailing) {
            Text("\(Date.now.formatted(date: .omitted, time: .shortened))")
                .modifier(TextMod(.system(size: 84), .bold))
            
            Text(dateString)
                .modifier(TextMod(.largeTitle, .semibold))
        }
    } //: Date Time Label
    
    private var makeASaleButton: some View {
        Button {
            navMan.changeDisplay(to: .makeASale)
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
