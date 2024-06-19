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


// Hashable because 'Instance method 'append' requires that 'DetailPath' conform to 'Hashable'
enum DetailPath: Identifiable, Hashable {
    var id: DetailPath { return self }
    
    case company(CompanyEntity, DetailType)
    case passcodePad([PasscodeViewState])
    case department(DepartmentEntity?, DetailType)
    case item(ItemEntity?, DetailType)
    case confirmSale
}



enum LazySplitDisplayMode { case detailOnly, besideDetail }

