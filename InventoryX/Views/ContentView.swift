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
    
    @ObservedResults(CategoryEntity.self) var categories
    
    @State var selectedCategory: CategoryEntity?
    
    var body: some View {
        NavigationSplitView(columnVisibility: $navMan.menuVisibility) {
            menu
                .navigationSplitViewColumnWidth(navMan.menuWidth)
        } detail: {
            ZStack {
                primaryBackground
                    .edgesIgnoringSafeArea(.all)

                HStack {
                    Spacer()
                    detail
                        .environmentObject(makeASaleViewModel)
                        .padding(.vertical)
                        .background(primaryBackground)
                        .frame(maxWidth: navMan.detailWidth, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.vertical)
                } //: HStack

                HStack {
                    content
//                        .environmentObject(makeASaleViewModel)
                        .padding(.top, 88)
                        .background(secondaryBackground)
                        .frame(maxWidth: navMan.contentWidth, maxHeight: .infinity)
                        .cornerRadius(10, corners: .allCorners)
                    
                    Spacer()
                } //: HStack
            } //: ZStack
            .edgesIgnoringSafeArea(.vertical)
            .toolbar(.hidden, for: .navigationBar)
            
        } //: Navigation Split
        .overlay(headerToolbar, alignment: .top)
        .onChange(of: categories) { newCategories in
            guard selectedCategory == nil, newCategories.count > 0 else { return }
            selectedCategory = newCategories.first!
        }
        .onChange(of: makeASaleViewModel.isConfirmingSale) { isConfirming in
            navMan.expandDetail(size: isConfirming ? .full : .quarter)
        }
        
    } //: Body
    
    private var headerToolbar: some View {
        HStack {
            Button {
                navMan.toggleMenu()
            } label: {
                Image(systemName: "sidebar.squares.leading")
                    .resizable()
                    .scaledToFit()
            }
            Spacer()
            Button {
                navMan.toggleCartPreview()
            } label: {
                Image(systemName: navMan.detailSize == .bar ? "cart" : "chevron.forward.2")
                    .resizable()
                    .scaledToFit()
//                    .frame(width: 30)
                    .foregroundColor(primaryBackground)
//                    .fontWeight(.semibold)
            }
            Spacer().frame(width: navMan.detailWidth)
            
        } //: HStack
        .modifier(TextMod(.body, .light, primaryBackground))
        .frame(height: 24)
        .padding(.vertical, 8)
        .padding(.horizontal)
    } //: Header Toolbar
    
    @ViewBuilder private var content: some View {
        switch navMan.currentDisplay {
        case .dashboard:
            DashboardView()
                .environmentObject(navMan)
        case .makeASale:
            MakeASaleView()
                .environmentObject(makeASaleViewModel)
                .onAppear {
                    navMan.expandDetail(size: .quarter, animation: nil)
                }
        case .addInventory:
            RestockView()
                .environmentObject(navMan)
        case .inventoryList:
            InventoryView()
                .environmentObject(navMan)
        case .salesHistory:
            SalesHistoryView()
                .environmentObject(navMan)
        case .inventoryStatus:
            InventoryStatusView()
                .environmentObject(navMan)
        case .settings:
            SettingsView()
                .environmentObject(navMan)
        }
    } //: Nav Content
    
    @ViewBuilder private var detail: some View {
        switch navMan.currentDisplay {
        case .dashboard:
            Text("Dashboard Detail")
        case .makeASale:
            CartView()
        case .addInventory:
            ItemDetailView(selectedItem: $navMan.selectedItem)
        case .inventoryList:
            ItemDetailView(selectedItem: $navMan.selectedItem)
        case .salesHistory:
            Text("Sales Detail")
        case .inventoryStatus:
            Text("Status Detail")
        case .settings:
            Text("Settings Detail")
        }
        
    } //: Detail
    
    @ViewBuilder private var menu: some View {
        //Decide whether or not to make this its own struct. It only needs navigationManager
        
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
