//
//  SettingsView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 6/4/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings")
                .modifier(TextMod(.largeTitle, .semibold, .black))
            
            Button {
                RealmMinion.deleteAllFromRealm()
            } label: {
                Text("Erase All Data and Reset")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            
            Button {
                RealmMinion.createRandomSales(qty: 100)
            } label: {
                Text("Create 100 Random Sales")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            
            Button {
                RealmMinion.createRandomSalesToday(qty: 20)
            } label: {
                Text("Create 20 Random Sales Today")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            
            Spacer()
        } //: VStack
        .background(secondaryBackground)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
