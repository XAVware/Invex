//
//  NavFramework.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/9/24.
//

import SwiftUI


struct NavView<Content: View, Detail: View>: View {
    
    @Binding var currentDisplay: NewDisplayState
    let content: Content?
    let detail: Detail
    
    @State var colVis: NavigationSplitViewVisibility = .detailOnly
    @State var prefCol: NavigationSplitViewColumn = .detail
    @State var showingLockScreen: Bool = false
    
    init(display: Binding<NewDisplayState>, content: (() -> Content)? = nil, @ViewBuilder detail: () -> Detail) {
        self._currentDisplay = display
        self.content = content?()
        self.detail = detail()
        
        if content == nil {
            print("Content is nil")
        } else {
            print("Content is not nil")
        }
    }
    
    func changeDisplay(to newDisplay: NewDisplayState) {
        currentDisplay = newDisplay
        colVis = currentDisplay.primaryView

    }
    
    var body: some View {
        if currentDisplay.primaryView == .detailOnly {
            NavigationSplitView(columnVisibility: $colVis, preferredCompactColumn: $prefCol) {
                menu
            } detail: {
                detail
            }
        } else {
            NavigationSplitView(columnVisibility: $colVis, preferredCompactColumn: $prefCol) {
                menu
            } content: {
                content
            } detail: {
                detail
            }
        }
    }

    
    @ViewBuilder var menu: some View {
        VStack(spacing: 16) {
            HStack {
                
                Spacer()
            }
            Spacer()
            
            ForEach(NewDisplayState.allCases, id: \.self) { data in
                Button {
                    changeDisplay(to: data)
                } label: {
                    HStack(spacing: 16) {
                        Text(data.menuButtonText)
                        Spacer()
                        Image(systemName: data.menuIconName)
                        RoundedCorner(radius: 8, corners: [.topLeft, .bottomLeft])
                            .fill(.white)
                            .frame(width: 6)
                            .opacity(data == currentDisplay ? 1 : 0)
                            .offset(x: 3)
                    }
                    .modifier(MenuButtonMod(isSelected: data == currentDisplay))
                }
                
            } //: For Each
            
            Spacer()
            
            Button {
                showingLockScreen = true
            } label: {
                HStack(spacing: 16) {
                    Text("Lock")
                    Spacer()
                    Image(systemName: "lock")
                    RoundedCorner(radius: 8, corners: [.topLeft, .bottomLeft])
                        .fill(.white)
                        .frame(width: 6)
                        .opacity(0)
                        .offset(x: 3)
                } //: HStack
                .modifier(MenuButtonMod(isSelected: false))
            }

            
        } //: VStack
        .background(.accent)
        .fullScreenCover(isPresented: $showingLockScreen) {
            LockScreenView()
        }
    }
}

// Support optional footer
extension NavView where Content == EmptyView {
    init(display: Binding<NewDisplayState>, @ViewBuilder detail: () -> Detail) {
        self._currentDisplay = display
        self.content = nil
        self.detail = detail()
    }
}


#Preview {
    ResponsiveView { props in
        NewRootView(uiProperties: props, cartState: CartState.sidebar)
            .environment(\.realm, DepartmentEntity.previewRealm)
            .environmentObject(PointOfSaleViewModel())
    }
}


