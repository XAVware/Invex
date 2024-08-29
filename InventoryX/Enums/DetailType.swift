//
//  DetailPath.swift
//  CustomSplitView
//
//  Created by Ryan Smetana on 5/19/24.
//

import SwiftUI

enum DetailType: Identifiable, Hashable {
    case onboarding
    case create
    case read
    case update
//    , delete
    
    var id: DetailType { return self }
}
