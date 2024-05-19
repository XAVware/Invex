//
//  MenuState.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/11/24.
//

import Foundation

// TODO: Pass UI width to closed state to determine if it should be shown as a compact sidebar or disappear entirely
enum MenuState: Equatable {
    case open
    case compact
    case closed
    
    var idealWidth: CGFloat {
        return switch self {
        case .open:     280
        case .compact:  64
        case .closed:   0
        }
    }
    

}
