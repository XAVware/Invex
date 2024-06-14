//
//  SplitInSplitView.swift
//  CustomSplitView
//
//  Created by Ryan Smetana on 5/17/24.
//


import SwiftUI
import Combine

enum Layout { case full, column }

// MARK: - Lazy Split Service
// Maybe move towards:
enum LazySplitColumn { case leftSidebar, primaryContent, detail, rightSidebar }

// Does this need to be a main actor?
//@MainActor
class LazySplitService {
    @Published var primaryRoot: DisplayState
    @Published var detailRoot: DetailPath?
    
    // TODO: Make these passthrough?
    @Published var primaryPath: NavigationPath = .init()
    //    let primaryPath = PassthroughSubject<NavigationPath, Never>()
    @Published var detailPath: NavigationPath = .init()
    
    static let shared = LazySplitService()
    
    init() {
        self.primaryRoot = DisplayState.allCases.first ?? .settings
    }
    
    func changeDisplay(to newDisplay: DisplayState) {
        detailPath = .init()
        //        primaryPath = .init()
        primaryRoot = newDisplay
    }
    
    func pushPrimary(_ display: DetailPath, isDetail: Bool) {
        primaryPath.append(display)
        print("Pushed primary")
    }
    
    func setDetailRoot(_ view: DetailPath) {
        self.detailRoot = view
    }
    
    /// Only call this from views appearing after the detail root
    func pushDetail(view: DetailPath) {
        detailPath.append(view)
    }
    
    func popPrimary() {
        if primaryPath.count > 0 {
            primaryPath.removeLast()
        }
    }
    
    func popDetail() {
        if detailPath.isEmpty {
            detailRoot = nil
        } else {
            detailPath.removeLast()
        }
    }
}





// MARK: - Lazy Split View Model
@MainActor final class LazySplitViewModel: ObservableObject {
    @Published var colVis: NavigationSplitViewVisibility = .detailOnly
    @Published var prefCol: NavigationSplitViewColumn = .detail
    
    @Published var detailPath: NavigationPath = .init()
    
    init() {
        configNavSubscribers()
        configAuthSubscribers()
    }
    
    func setLandscape(to isLandscape: Bool) {
        if isLandscape {
            hideMenu()
        }
    }
    
    // MARK: - Menu
    func sidebarToggleTapped() {
        colVis = colVis == .doubleColumn ? .detailOnly : .doubleColumn
        prefCol = colVis == .detailOnly ? .detail : .sidebar
    }
    
    func showMenu() {
        guard colVis != .doubleColumn && prefCol != .sidebar else { return }
        colVis = .doubleColumn
        prefCol = .sidebar
    }
    
    func hideMenu() {
        guard colVis != .detailOnly && prefCol != .detail else { return }
        colVis = .detailOnly
        prefCol = .detail
    }
    
    // MARK: - Navigation Subscriptions
    private let navService = LazySplitService.shared
    @Published var mainDisplay: DisplayState = .makeASale
    @Published var detailRoot: DetailPath?
    @Published var path: NavigationPath = .init()
    //    let path = PassthroughSubject<NavigationPath, Never>()
    
    func configNavSubscribers() {
        navService.$primaryRoot
            .sink { [weak self] display in
                self?.mainDisplay = display
            }.store(in: &cancellables)
        
        navService.$detailRoot
            .sink { [weak self] detailPath in
                self?.detailRoot = detailPath
            }.store(in: &cancellables)
        
        navService.$primaryPath
            .sink { [weak self] path in
                
                self?.path = path
                
            }.store(in: &cancellables)
        
        navService.$detailPath
            .sink { [weak self] detailPath in
                self?.detailPath = detailPath
            }.store(in: &cancellables)
    }
    
    
    
    // MARK: - Authentication / Onboarding
    private let service = AuthService.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var exists: Bool = false
    
    func configAuthSubscribers() {
        service.$exists
            .sink { [weak self] exists in
                self?.exists = exists
            }.store(in: &cancellables)
    }
    
    // MARK: - Onboarding
    func finishOnboarding() {
        exists = true
        mainDisplay = .makeASale
    }
}

struct LazySplit<S: View, C: View, D: View, T: ToolbarContent>: View {
    @Environment(\.horizontalSizeClass) var horSize
    @Environment(\.verticalSizeClass) var verSize
    
    @StateObject var vm: LazySplitViewModel
    @EnvironmentObject var toolbarVM: ToolbarViewModel
    
    @State var childColVis: NavigationSplitViewVisibility = .doubleColumn
    @State var childPrefCol: NavigationSplitViewColumn = .content
    
    let sidebar: S
    let content: C
    let contentToolbar: T
    let detail: D
    
    enum LazySplitStyle { case balanced, prominentDetail }
    @State var style: LazySplitStyle = .balanced
    
    init(viewModel: LazySplitViewModel, sidebar: (() -> S), content: (() -> C), detail: (() -> D), contentToolbar: (() -> T)) {
        self._vm = StateObject(wrappedValue: viewModel)
        self.sidebar = sidebar()
        self.content = content()
        self.contentToolbar = contentToolbar()
        self.detail = detail()
    }
    
    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height
            
            NavigationStack(path: $vm.path) {
                NavigationSplitView(columnVisibility: $vm.colVis,  preferredCompactColumn: $vm.prefCol) {
                    sidebar
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar(removing: .sidebarToggle)
                        .navigationSplitViewColumnWidth(240)
                } detail: {
                    Group {
                        if vm.mainDisplay.displayMode == .besideDetail {
                            NavigationSplitView(columnVisibility: $childColVis, preferredCompactColumn: $childPrefCol) {
                                content
                                    .toolbar(.hidden, for: .navigationBar) // D
                                // To display the first option by default, maybe add .onAppear { path append }
                            } detail: {
                                NavigationStack(path: $vm.detailPath) {
                                    detail
                                }
                                .navigationDestination(for: DetailPath.self) { detail in
                                    switch detail {
                                    case .item(let i, let t):       ItemDetailView(item: i, detailType: t)
                                    default: Color.blue
                                    }
                                    
                                }
                            }
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationSplitViewStyle(.balanced)
                            .toolbar(removing: .sidebarToggle)
                        } else {
                            content
                        }
                    }
                    .toolbar(.hidden, for: .navigationBar)
                }
                // Can I make this a modifier?
                .navigationDestination(for: DetailPath.self) { detail in
                    switch detail {
                    case .confirmSale(let items):   ConfirmSaleView(cartItems: items)
                    case .item(let i, let t):       ItemDetailView(item: i, detailType: t)
                    default: Color.red
                    }
                }
                .navigationTitle(vm.mainDisplay.viewTitle)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(removing: .sidebarToggle)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    sidebarToggle
                    contentToolbar
                }
                .modifier(LazySplitMod(isProminent: horSize == .compact && !isLandscape))
            } //: Navigation Stack
            
            // I intentionally put the hide/show menu functions in the view. I think it was causing issues with the menu animations, but it should be tested & compared to calling from VM.
            .onChange(of: isLandscape) { prev, landscape in
                if landscape {
                    vm.hideMenu()
                }
            }
            .onReceive(vm.$mainDisplay) { newDisplay in
                vm.hideMenu()
            }
            .onReceive(vm.$detailRoot) { detailRoot in
                // Pushing a view into the detail column by itself only works for iPad. childPrefCol needs to toggle between content and detail for iPhone.
                self.childPrefCol = detailRoot != nil ? .detail : .content
            }
            .environmentObject(toolbarVM)
        }
    } //: Body
    
    
    @ToolbarContentBuilder var sidebarToggle: some ToolbarContent {
        let isIphone = horSize == .compact || verSize == .compact
        let isXmark = isIphone && vm.prefCol == .sidebar
        
        ToolbarItem(placement: .topBarLeading) {
            Button("Close", systemImage: isXmark ? "xmark" : "sidebar.leading") {
                vm.sidebarToggleTapped()
                
                if toolbarVM.cartDisplayMode == .sidebar {
                    toolbarVM.hideCartSidebar()
                    // TODO: If the sidebar was originally open, open it again if the menu closes back to the same screen.
                }
            }
        }
    }
    
    struct LazySplitMod: ViewModifier {
        let isProminent: Bool
        func body(content: Content) -> some View {
            if isProminent {
                content.navigationSplitViewStyle(.prominentDetail)
            } else {
                content.navigationSplitViewStyle(.balanced)
            }
        }
    }
    
    
}

#Preview {
    RootView()
        .environment(\.realm, DepartmentEntity.previewRealm)
    
}
