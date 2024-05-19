//
//  DetailPath.swift
//  CustomSplitView
//
//  Created by Ryan Smetana on 5/19/24.
//

import Foundation

enum DetailPath: Identifiable, Hashable {
    var id: DetailPath { return self }
    case company
    case setPasscode
    case department
    case item
    
    var viewTitle: String {
        return switch self {
        case .setPasscode:  "Set a passcode"
        case .department:   "Add a department"
        case .item:         "Add an item"
        case .company:      "Company"
        }
    }
}
