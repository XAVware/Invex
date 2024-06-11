//
//  CartState.swift
//  InventoryX
//
//  Created by Ryan Smetana on 5/11/24.
//

import Foundation

enum CartState {
    case hidden
    case sidebar
//    case confirming
    
    var idealWidth: CGFloat {
        return switch self {
        case .hidden:       0
        case .sidebar:      240
//        case .confirming:   .infinity
        }
    }
}
