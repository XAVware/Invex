

import Foundation
import RealmSwift


class Sale: Object {
    @objc dynamic var timestamp: Date = Date()
    var items = List<SaleItem>()
    @objc dynamic var total: Double = 0.00

}
