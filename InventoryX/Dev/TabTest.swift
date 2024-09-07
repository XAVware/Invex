//
//  TabTest.swift
//  InventoryX
//
//  Created by Ryan Smetana on 9/6/24.
//

import SwiftUI

struct TabTest: View {
    
    @State var colVis: NavigationSplitViewVisibility = .detailOnly
    @State var mainDisplay: LSXDisplay = .pos
    @StateObject var posVM = PointOfSaleViewModel()

    var body: some View {
        NavigationSplitView(columnVisibility: $colVis, preferredCompactColumn: .constant(.detail)) {
            MenuView()
                .navigationSplitViewColumnWidth(280)
        } detail: {
            TabView(selection: $mainDisplay) {
                POSView()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationSplitViewColumnWidth(800)
                    .environmentObject(posVM)
                    .tabItem { 
                        Text("Make A Sale")
                    }.tag(LSXDisplay.pos)
                
                InventoryListView()
                    .navigationSplitViewColumnWidth(800)
                    .tabItem {
                        Text("Inventory")
                    }.tag(LSXDisplay.inventoryList)
                
                TestView()
                .tabItem {
                    Text("Nav")
                }.tag(LSXDisplay.settings)
                
            }
            .toolbar(.hidden, for: .navigationBar) 
            
//            .tabViewStyle(.page(indexDisplayMode: .always))
//            switch mainDisplay {
//            case .pos:              POSView().environmentObject(posVM).navigationSplitViewColumnWidth(800)
//            case .inventoryList:    InventoryListView()
//            case .settings:         SettingsView()
//            default:                EmptyView()
//            }
        }
        .navigationSplitViewStyle(.balanced)
        .animation(.snappy, value: colVis == .doubleColumn || colVis == .all)
        

    }
}

#Preview {
    TabTest()
        .environment(\.realm, DepartmentEntity.previewRealm)

}

struct TestView: View {
    @State var index: Int = 0
    var body: some View {
        TabView(selection: $index.animation(.snappy)) {
            VStack {
                Button {
//                    withAnimation(.interpolatingSpring) {
                        
                        index += 1
//                    }
                } label: {
                    Text("To tab 2")
                }
            }.tag(0)

            ZStack {
                Color.red.ignoresSafeArea()
                Text("Welcome")
            }.tag(1)
//                .transition(.slide)
        }
    }
}
