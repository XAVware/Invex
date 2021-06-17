

import SwiftUI
import RealmSwift

class Item: Object {
    @objc dynamic var name: String          = ""
    @objc dynamic var subtype: String       = ""
    @objc dynamic var itemType: String      = ""
    @objc dynamic var retailPrice: Double   = 0.00
    @objc dynamic var avgCostPer: Double    = 0.00
    @objc dynamic var onHandQty: Int        = 0
}

class Category: Object {
    @objc dynamic var name: String          = ""
    @objc dynamic var restockNumber         = 0
}
