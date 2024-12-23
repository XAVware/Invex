//
//  ItemTableView.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/21/24.
//

import SwiftUI
import RealmSwift




#Preview {
    InventoryListView()
        .environment(\.realm, DepartmentEntity.previewRealm)
        .environment(NavigationService())
}
