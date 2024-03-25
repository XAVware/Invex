//
//  SettingsView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 6/4/23.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            Spacer()
            
            HStack {
                VStack {
                    VStack(alignment: .leading, spacing: 24) {
                        HStack {
                            Text("Company Info")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .fontDesign(.rounded)
                            Spacer()
                            Image(systemName: "pencil")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 16)
                        } //: HStack
                        
                        VStack(spacing: 12) {
                            HStack {
                                Text("Name:")
                                    .font(.headline)
                                    .foregroundStyle(.gray)
                                Spacer()
                                Text("XAVware")
                            } //: HStack
                            
                            HStack {
                                Text("Tax:")
                                    .font(.headline)
                                    .foregroundStyle(.gray)
                                Spacer()
                                Text("7.00 %")
                            } //: HStack
                        } //: VStack
                    } //: VStack
                    .padding(24)
                    .frame(maxWidth: 360, maxHeight: 140)
                    .background(Color("Purple050"))
                    .modifier(GlowingOutlineMod())
                    
                    
                    Spacer()
                } //: VStack
            } //: HStack
            .padding()
        } //: VStack
        .padding()
    }
    
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}


#Preview {
    ResponsiveView { props in
        RootView(uiProperties: props, currentDisplay: .settings)
            .environment(\.realm, DepartmentEntity.previewRealm)
    }
}
