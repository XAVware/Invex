//
//  LazyNavViewModel.swift
//  CustomSplitView
//
//  Created by Ryan Smetana on 5/19/24.
//

import SwiftUI
import Combine

@MainActor final class LazyNavViewModel: ObservableObject {
    @Published var path: NavigationPath = .init()
    @Published var mainDisplay: DisplayState = .makeASale
    @Published var colVis: NavigationSplitViewVisibility = .detailOnly
    @Published var prefCol: NavigationSplitViewColumn = .detail
    
    
    private let service = AuthService.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var exists: Bool = false
    
    init() {
        configureSubscribers()
    }
    
    func configureSubscribers() {
        service.$exists
            .sink { [weak self] exists in
                self?.exists = exists
            }
            .store(in: &cancellables)
    }
    
    func changeDisplay(to newDisplay: DisplayState) {
        mainDisplay = newDisplay
        colVis = .detailOnly
        prefCol = .detail
        path = .init()
    }
    
    func toggleSidebar() {
        colVis = colVis == .doubleColumn ? .detailOnly : .doubleColumn
        prefCol = colVis == .detailOnly ? .detail : .sidebar
    }
    
    // Don't need this if using NavigationLink(value:label:). Will work when using Button.
    func pushView(_ display: DetailPath) {
        path.append(display)
    }
    
    deinit {
        print("Lazy Nav View Model deinitialized")
    }
}
