//
//  ContentView.swift
//  InventoryX
//
//  Created by Smetana, Ryan on 4/24/23.
//

import SwiftUI
import RealmSwift


struct ContentView: View {
    @EnvironmentObject var navMan: NavigationManager
    @StateObject var makeASaleViewModel: MakeASaleViewModel = MakeASaleViewModel()
    
    //    @ObservedResults(CategoryEntity.self) var categories
    
    @State var selectedCategory: CategoryEntity?
    //    @State var currentDisplay: DisplayStates = .makeASale
    //    @State var menuIsHidden: Bool = false
    //    @State var menuVisibility: NavigationSplitViewVisibility = .detailOnly
    
    var body: some View {
//        ZStack {
//                primaryBackground
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .edgesIgnoringSafeArea(.all)
//                HStack {
//                    Spacer(minLength: 0)
//
////                    CartView()
////                        .environmentObject(makeASaleViewModel)
////                        .frame(width: navMan.detailWidth)
////                        .frame(maxHeight: .infinity)
////                        .padding()
////                        .background(primaryBackground)
////                        .frame(width: navMan.contentWidth)
//
//                } //: HStack
                
//            GeometryReader { geo in
                NavigationSplitView(columnVisibility: $navMan.menuVisibility) {
                    menu
                        .navigationSplitViewColumnWidth(navMan.menuWidth)
                } detail: {
                    ZStack {
                        HStack {
                            Spacer()
                            CartView()
                                .environmentObject(makeASaleViewModel)
                                .padding(.vertical)
                                .background(primaryBackground)
                                .frame(maxWidth: navMan.detailWidth, maxHeight: .infinity)
                                .edgesIgnoringSafeArea(.vertical)
                        } //: HStack
                        HStack {
                            content
                                .environmentObject(makeASaleViewModel)
                                .background(secondaryBackground)
                                .frame(width: navMan.contentWidth)
                            
                            Spacer()
                        } //: HStack
                    }
                    .onAppear {
                        navMan.expandDetail(size: .quarter, animation: nil)
                    }
                }
                
//                .tint(navMan.menuVisibility == .all ? secondaryBackground : primaryBackground)
//
////                .onChange(of: categories) { newCategories in
////                    print("Called")
////                    guard selectedCategory == nil, newCategories.count > 0 else { return }
////                    selectedCategory = newCategories.first!
////                }
//                .onChange(of: makeASaleViewModel.isConfirmingSale) { isConfirming in
//                    navMan.expandDetail(size: .full)
//                }
//            }  //: Geometry Reader
            
//            HStack(spacing: 0) {
//                if !menuIsHidden {
//                    MenuView(currentDisplay: self.$currentDisplay)
//                        .frame(maxWidth: geo.size.width * 0.15)
//                }
//                navContent
//            } //: HStack
//            .onChange(of: categories) { newCategories in
//                guard selectedCategory == nil, newCategories.count > 0 else { return }
//                selectedCategory = newCategories.first!
//            }
//        }
//        .edgesIgnoringSafeArea(.all)
        
    } //: Body
    
    @ViewBuilder private var content: some View {
        switch navMan.currentDisplay {
        case .dashboard:
            DashboardView()
                .environmentObject(navMan)
        case .makeASale:
            MakeASaleView()
                .environmentObject(makeASaleViewModel)
        case .addInventory:
            RestockView()
        case .inventoryList:
            InventoryView()
        case .salesHistory:
            SalesHistoryView()
        case .inventoryStatus:
            InventoryStatusView()
        case .settings:
            SettingsView()
        }
    } //: Nav Content
    
    
    @ViewBuilder private var menu: some View {
        VStack {
            HStack(spacing: 16) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                VStack {
                    Text("Ryan")
                        .modifier(TextMod(.title3, .medium, secondaryBackground))
                    Text("Admin")
                        .modifier(TextMod(.footnote, .regular, lightFgColor))
                }
                
            } //: HStack
            .foregroundColor(secondaryBackground)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            
            Divider()
                .background(secondaryBackground)
                .padding(.vertical)
            
            ForEach(DisplayStates.allCases, id: \.self) { displayState in
                Button {
                    navMan.changeDisplay(to: displayState)
//                    navMan.currentDisplay = displayState
                } label: {
                    Image(systemName: displayState.iconName)
                        .imageScale(.medium)
                        .bold()
                    
                    Text("\(displayState.menuButtonText)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .frame(height: 50)
                .overlay(navMan.currentDisplay == displayState ? lightFgColor.opacity(0.3).cornerRadius(5).padding(.horizontal, 4) : nil)
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.forward")
                    .imageScale(.medium)
                    .bold()
                
                Text("Sign Out")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .frame(height: 50)
        } //: VStack
        .background(primaryBackground)
        .modifier(TextMod(.title3, .semibold, lightFgColor))
    } //: Menu
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(NavigationManager())
            .modifier(PreviewMod())
        
    }
}
