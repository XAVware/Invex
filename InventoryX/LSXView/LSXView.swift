//
//  LazySplit.swift
//  CustomSplitView
//
//  Created by Ryan Smetana on 5/22/24.
//

import SwiftUI
import Combine


/// - Parameters
///     - S: The view to be displayed in the left/sidebar column of the split view.
///     - C: The view to be displayed in the middle/content column of the split view.
///     - D: The view to be displayed in the right/detail column of the split view.

struct LSXView<S: View, C: View, D: View>: View {
    @StateObject var vm: LSXViewModel
    @Environment(\.horizontalSizeClass) var horSize
    @Environment(\.verticalSizeClass) var verSize
    
    @State var childColVis: NavigationSplitViewVisibility = .doubleColumn
    @State var childPrefCol: NavigationSplitViewColumn = .content
    
    let sidebar: S
    let content: C
    let detail: D
    
    init(viewModel: LSXViewModel, @ViewBuilder sidebar: (() -> S), @ViewBuilder content: (() -> C), @ViewBuilder detail: (() -> D)) {
        self._vm = StateObject(wrappedValue: viewModel)
        self.sidebar = sidebar()
        self.content = content()
        self.detail = detail()
    }
        
    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height
            NavigationStack(path: $vm.primaryPath) {
                
                primarySplit
                    // TODO: Document in LSX that this needs to be included in order for the toolbar title and toolbar button to appear on the home view
                    .navigationDestination(for: LSXDisplay.self) { detail in
                        switch detail {
                        default:                Text("Err with full screen detail view")
                        }
                    }
                
                    .toolbar(.hidden, for: .navigationBar)
                    .modifier(LazySplitMod(isProminent: horSize == .compact && !isLandscape))
                    .overlay(
                        Color.white.opacity(0.01)
                            .frame(width: geo.safeAreaInsets.leading + 6)
                            .ignoresSafeArea()
                        , alignment: .leading
                    )
            } //: Navigation Stack
            .tint(.accent)
            .onAppear {
                vm.setHorIsCompact(isCompact: horSize == .compact)
            }
            .onChange(of: isLandscape) { _, landscape in
                vm.setHorIsCompact(isCompact: horSize == .compact)
                // Hide the menu if orientation changes to landscape
                if landscape && horSize != .compact {
                    vm.hideMenu()
                }
            }
            .onReceive(vm.$mainDisplay) { newDisplay in
                // Hide the menu when the main display changes.
                vm.hideMenu()
            }
            .onReceive(vm.$detailRoot) { detailRoot in
                // Toggle between content and detail on compact HorizontalSizeClass
                self.childPrefCol = detailRoot != nil ? .detail : .content
            }
        } //: Geometry Reader
    } //: Body
    
    @ViewBuilder private var primarySplit: some View {
        NavigationSplitView(columnVisibility: $vm.colVis,  preferredCompactColumn: $vm.prefCol) {
            sidebar
                .toolbar(removing: .sidebarToggle) // A
                .toolbar { menuToolbar }
            
        } detail: {
            contentLayout
            
                .navigationBarBackButtonHidden() // Hides back button resulting from moving toolbar control back to views.
//                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Close", systemImage: "sidebar.leading") {
                            vm.sidebarToggleTapped()
                        }
                    }
                }
        } //: Navigation Split View
    } //: Primary Split
    
    @ViewBuilder private var contentLayout: some View {
        if vm.mainDisplay.displayMode == .besideDetail {
            innerSplit
//                .navigationBarTitleDisplayMode(.inline) // D
                .navigationSplitViewStyle(.balanced)
                .toolbar(removing: .sidebarToggle) // E
        } else {
            content
        }
    } //: Content Layout
    
    @ViewBuilder private var innerSplit: some View {
        NavigationSplitView(columnVisibility: $childColVis, preferredCompactColumn: $childPrefCol) {
            content
                .toolbar(.hidden, for: .navigationBar) // C
        } detail: {
            GeometryReader { geo in
                NavigationStack(path: $vm.detailPath) {
                    detail
                        .frame(width: geo.size.width) // Forces detail to not compress when menu is opened on screen besidesDetail
                }
            }
        }
    } //: Inner Split View
    
    @ToolbarContentBuilder private var menuToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("Close", systemImage: "xmark") {
                vm.sidebarToggleTapped()
            }
            .opacity(horSize == .compact ? 1 : 0)
        }
        
    }
    
    struct LazySplitMod: ViewModifier {
        let isProminent: Bool
        func body(content: Content) -> some View {
            if isProminent { content.navigationSplitViewStyle(.prominentDetail) }
            else { content.navigationSplitViewStyle(.balanced) }
        }
    }
}

#Preview {
    RootView()
}
