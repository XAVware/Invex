//
//  AppError.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/25/24.
//

import Foundation

enum AppError: Error {
    case departmentAlreadyExists
    case numericThresholdRequired
    case invalidTaxPercentage
    case passcodesDoNotMatch
    case invalidMarkup
    
    var localizedDescription: String {
        switch self {
        case .departmentAlreadyExists:      "Department already exists with this name"
        case .numericThresholdRequired:     "Please enter a valid number for the restock threshold"
        case .invalidTaxPercentage:         "Please enter a valid tax rate percentage"
        case .passcodesDoNotMatch:          "The passcodes you entered do not match"
        case .invalidMarkup:                "Please enter a valid markup."
        }
    }
}
