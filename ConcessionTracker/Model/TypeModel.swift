//
//  TypeModel.swift
//  ConcessionTracker
//
//  Created by Ryan Smetana on 1/20/21.
//

import SwiftUI

struct Type: Identifiable {
    var id = UUID()
    var type: String
    var restockNumber: Int
}
