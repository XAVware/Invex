//
//  UIColorOverride.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/24/24.
//

import SwiftUI

extension UIColor {
    static let classInit: Void = {
        /// After trial and error, as of 4.18.24 Apple is using UIColor.opaqueSeparator as the color of the divider that appears between NavigationSplitViews.
        let orig = class_getClassMethod(UIColor.self, #selector(getter: opaqueSeparator))
        let new = class_getClassMethod(UIColor.self, #selector(getter: customDividerColor))
        method_exchangeImplementations(orig!, new!)
    }()

    @objc open class var customDividerColor: UIColor {
        return UIColor(Color.clear)
    }
}
