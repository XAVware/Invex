//
//  AppError.swift
//  InventoryX
//
//  Created by Ryan Smetana on 3/25/24.
//

import Foundation

enum AppError: Error {
    case departmentAlreadyExists
    case departmentDoesNotExist
    case departmentHasItems
    case departmentIsNil
    case invalidCost
    case invalidCompanyName
    case invalidDepartment
    case invalidItemName
    case invalidTaxPercentage
    case invalidMarkup
    case invalidPrice
    case invalidQuantity
    case noPasscodeProcesses
    case noPasscodeFound
    case numericThresholdRequired
    case passcodesDoNotMatch
    case thawingDepartmentError
    case thawingItemError
    
    var localizedDescription: String {
        switch self {
        case .departmentAlreadyExists:      "Department already exists with this name"
        case .numericThresholdRequired:     "Please enter a valid number for the restock threshold"
        case .invalidTaxPercentage:         "Please enter a valid tax rate percentage"
        case .passcodesDoNotMatch:          "The passcodes you entered do not match"
        case .invalidMarkup:                "Please enter a valid markup."
        case .noPasscodeProcesses:          "No processes set"
        case .noPasscodeFound:              "Attempting to confirm passcode but no initial passcode was found"
        case .invalidCompanyName:           "Please enter a valid company name"
        case .invalidDepartment:            "Invalid department"
        case .thawingDepartmentError:       "Error thawing department"
        case .thawingItemError:             "Error thawing item"
        case .invalidItemName:              "Please enter a valid item name"
        case .invalidQuantity:              "Please enter a valid quantity"
        case .invalidPrice:                 "Please enter a valid price"
        case .invalidCost:                  "Please enter a valid unity cost"
        case .departmentHasItems:           "You need to move the items to a different department before you can delete it."
        case .departmentDoesNotExist:       "Department does not exist."
        case .departmentIsNil:              "Please select a department"
        }
    }
}
