//
//  FormX.swift
//  InventoryX
//
//  Created by Ryan Smetana on 11/1/24.
//

import SwiftUI


@Observable
class XAVFormViewModel {
    var origValue: String = ""
    var showAlert: Bool = false
    
    var onTapOutside: (() -> Void)?
    var expandedContainer: UUID?
    var containers: [ContainerXModel] = []
    
    var pageTitle: String? {
        return containers.first(where: { $0.id == expandedContainer })?.title
    }
    /// Add ContainerX IDs to array so they can be toggled from a parent.
    /// Insert the ID at the given index. If the index is nil, append it to the array.
//    func addContainer(id: UUID, at index: Int? = nil) {
//        containers.insert(id, at: index ?? max(containers.count - 1, 0))
//    }
    
    func setOrigValue(_ value: String) {
        self.origValue = value
    }
    
    func addContainers(_ containers: [ContainerXModel]) {
//        self.containers = containers.map({ $0.id })
        self.containers = containers
    }
    
    func forceClose() {
        withAnimation {
            expandedContainer = nil
        }
    }
    
    func toggleContainer(id: UUID) {
        withAnimation {
            expandedContainer = expandedContainer == id ? nil : id
        }
    }
    
    func expandContainer(id: UUID) {
        withAnimation {
            expandedContainer = id
        }
    }
    
    // Confirms the container's field's current value has not changed
    func closeContainer(withValue currentVal: String) {
        guard self.origValue == currentVal else {
            print(origValue)
            print(currentVal)
            showAlert = true
            return
        }
        
        withAnimation {
            expandedContainer = nil
        }
        return
    }
    
}

struct FormX<C: View>: View {
    @Environment(\.horizontalSizeClass) var hSize
    @State var formVM: XAVFormViewModel = XAVFormViewModel()

    let content: C
    let title: String
    
    init(title: String, containers: [ContainerXModel], @ViewBuilder content: (() -> C)) {
        self.title = title
        self.content = content()
        formVM.addContainers(containers)
    }
    
    func setContainers(_ containers: [ContainerXModel]) {
        formVM.addContainers(containers)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
//                if let title = title {
                    Text(formVM.pageTitle ?? title)
                        .font(.largeTitle)
                        .fontDesign(.rounded)
                        .opacity(0.9)
//                }
                
                VStack(alignment: .leading, spacing: 4) {
                    content
                }
                .padding(.vertical)
                .environment(formVM)
                
//                Text(errorMessage ?? "")
//                    .foregroundStyle(.red)
//                    .padding()
                
                Spacer()
            }
            .padding(hSize == .regular ? 48 : 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .fontDesign(.rounded)
            
        } //: Scroll View
        .background(.bg)
        .scrollIndicators(.hidden)
        .toolbar(formVM.expandedContainer == nil ? .visible : .hidden, for: .navigationBar)
//        .overlay(Divider().background(Color.accentColor.opacity(0.01)), alignment: .top)
    }
    
}

struct ThemeFormSection<C: View>: View {
    @Environment(\.horizontalSizeClass) var hSize
    
    let content: C
    @State var title: String = ""
    
    init(title: String, @ViewBuilder content: (() -> C)) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 6) {
                content
            }
//            .padding(.vertical, 4)
//            .padding(0)
            .background(Color.fafafa)
        }
        .padding()
        .modifier(RoundedOutlineMod(cornerRadius: 9))
    }
    
}
