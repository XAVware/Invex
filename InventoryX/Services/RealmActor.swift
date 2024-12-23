//
//  RealmActor.swift
//  InventoryX
//
//  Created by Ryan Smetana on 4/15/24.
//

import Foundation
import RealmSwift


/// TODO: Should be:
/// 1. detailViewSubmitted() should pass the current Object to the view model.
/// 2. View model should do validation of form field types before passing the cleaned data to RealmActor.
/// 3. Query to check if Object exists.
///     - If it does, the user is modifying.
///     - If not, the user is creating a new object.

// TODO: Move form validation back into ViewModels. Only pass this actor type validated data so it is easier to troubleshoot.
actor RealmActor {
//    deinit {
//        debugPrint("RealmActor deinitialized")
//        debugPrint("-> Lifespan: \(bornTime.timeIntervalSinceNow)")
//    }
    
//    let bornTime: Date
    
//    init() {
////        debugPrint("RealActor Initialized")
//        bornTime = Date()
//    }
    
    @MainActor
    func fetchCompany() throws -> CompanyEntity? {
        let realm = try Realm()
        return realm.objects(CompanyEntity.self).first
    }
    
    /// Company data saves differently than departments and items. Since there can only be one company
    /// there's no need to track create/modify states. When the save button is tapped, check if a
    /// company exists, if yes then `modify/update` otherwise `create`.
    func saveCompany(name: String, tax: String) async throws {
        let name = name.replacingOccurrences(of: " ", with: "")
        guard !name.isEmpty                 else { throw AppError.invalidCompanyName }
        guard let taxRate = Double(tax)     else { throw AppError.invalidTaxPercentage }
        
        let company = CompanyEntity(name: name, taxRate: taxRate)
        let realm = try await Realm()
        
        try await realm.asyncWrite {
            if let company = realm.objects(CompanyEntity.self).first {
                // Company exists, update record
                company.name = name
                company.taxRate = taxRate
            } else {
                // Company doesn't exist. Create record
                realm.add(company)
            }
        }
    }
    
    // MARK: - DEPARTMENTS
    /// Fetch all departments
    @MainActor func fetchDepartments() async throws -> Results<DepartmentEntity> {
        let realm = try await Realm()
        return realm.objects(DepartmentEntity.self)
    }
    
    /// Create a new department
    func addDepartment(name: String, restockThresh: String, markup: String) async throws {
        guard let restockThresh = Int(restockThresh)    else { throw AppError.numericThresholdRequired }
        guard let markup = Double(markup)               else { throw AppError.invalidMarkup }
        let realm = try await Realm()
        let department = DepartmentEntity(name: name, restockNum: restockThresh, defMarkup: markup)
        try await realm.asyncWrite {
            realm.add(department)
        }
    }
    
    /// Update an existing department
    @MainActor func updateDepartment(dept: DepartmentEntity, newName: String, thresh: String, markup: String) async throws {
        guard let thresh = Int(thresh)      else { throw AppError.numericThresholdRequired }
        guard let markup = Double(markup)   else { throw AppError.invalidMarkup }
        guard let dept = dept.thaw()        else { throw AppError.thawingDepartmentError }
        
        let realm = try await Realm()
        try await realm.asyncWrite {
            dept.name = newName
            dept.restockNumber = thresh
            dept.defMarkup = markup
        }
    }
    
    @MainActor func deleteDepartment(id: RealmSwift.ObjectId) async throws {
        let realm = try await Realm()
        guard let dept = realm.object(ofType: DepartmentEntity.self,
                                      forPrimaryKey: id) else { throw AppError.departmentDoesNotExist }
        guard dept.items.isEmpty else { throw AppError.departmentHasItems }
        
        try await realm.asyncWrite {
            realm.delete(dept)
        }
    }
    
    /// Sales use a SaleEntity model instead of ItemEntity, so there's no risk of losing sale data.
    @MainActor func deleteItem(withId id: ObjectId) async throws {
        // Make sure item is not currently in cart.
        let realm = try await Realm()
        guard let item = realm.object(ofType: ItemEntity.self, forPrimaryKey: id) else { throw AppError.noItemFound }
        
        try await realm.asyncWrite {
            realm.delete(item)
        }
    }
    
    // MARK: - ITEMS
    @MainActor func fetchAllItems() throws -> Results<ItemEntity> {
        let realm = try Realm()
        return realm.objects(ItemEntity.self)
    }
    
    @MainActor func fetchItem(withId id: ObjectId) throws -> ItemEntity {
        let realm = try Realm()
        return realm.object(ofType: ItemEntity.self, forPrimaryKey: id) ?? ItemEntity()
    }
    
    // TODO: Change to only request ID
    func saveItem(dept: DepartmentEntity?, name: String, att: String, qty: String, price: String, cost: String) async throws {
        guard let dept = dept           else { throw AppError.invalidDepartment }
        guard name.isNotEmpty           else { throw AppError.invalidItemName }
        guard let price = Double(price) else { throw AppError.invalidPrice }
                
        let cost = Double(cost) ?? 0
        let qty = Int(qty) ?? 0
        
        let newItem = ItemEntity(name: name, attribute: att, retailPrice: price, avgCostPer: cost, onHandQty: qty)
        let realm = try await Realm()
        try await realm.asyncWrite {
            realm.objects(DepartmentEntity.self).first(where: { $0._id == dept._id })?.items.append(newItem)
        }
    } //: Save Item
    
    @MainActor func updateItem(item: ItemEntity, name: String, att: String, qty: String, price: String, cost: String) async throws {
        let price = price.replacingOccurrences(of: "$", with: "")
        let cost = cost.replacingOccurrences(of: "$", with: "")
        
        guard name.isNotEmpty                   else { throw AppError.invalidItemName }
        guard let qty = Int(qty)                else { throw AppError.invalidQuantity }
        guard let price = Double(price)         else { throw AppError.invalidPrice }
        guard let cost = Double(cost)           else { throw AppError.invalidCost }
        guard let existingItem = item.thaw()    else { throw AppError.thawingItemError }
        
        let realm = try await Realm()
        try await realm.asyncWrite {
            existingItem.name = name
            existingItem.attribute = att
            existingItem.onHandQty = qty
            existingItem.retailPrice = price
            existingItem.unitCost = cost
        }
        
    }
    
    @MainActor func moveItems(from fromDept: DepartmentEntity, to toDept: DepartmentEntity) async throws {
        let realm = try await Realm()
        let itemsToMove = fromDept.items
        guard itemsToMove.count > 0 else {
            debugPrint("Department has no items to move")
            return
        }
        guard let fromDept = fromDept.thaw(), let toDept = toDept.thaw() else { throw AppError.thawingDepartmentError }
        try await realm.asyncWrite {
            toDept.items.append(objectsIn: itemsToMove)
            fromDept.items.removeAll()
        }
    }
    
    // New
    @MainActor
    func moveItems(withIds itemIds: [ObjectId], toDepartmentId: ObjectId) async throws {
        let realm = try await Realm()
        guard let targetDept = realm.object(ofType: DepartmentEntity.self, forPrimaryKey: toDepartmentId) else {
            return
        }
        
        try await realm.asyncWrite {
            for itemId in itemIds {
                if let item = realm.object(ofType: ItemEntity.self, forPrimaryKey: itemId),
                   let sourceDept = item.department.first {
                    sourceDept.items.remove(at: sourceDept.items.firstIndex(of: item)!)
                    targetDept.items.append(item)
                }
            }
        }
    }
    
    // New
    @MainActor
    func deleteItems(withIds itemIds: [ObjectId]) async throws {
        let realm = try await Realm()
        try await realm.asyncWrite {
            for itemId in itemIds {
                if let item = realm.object(ofType: ItemEntity.self, forPrimaryKey: itemId) {
                    realm.delete(item)
                }
            }
        }
    }
    
    // MARK: - SALES
    func saveSale(items: Array<SaleItemEntity>, total: Double) async throws {
        let newSale = SaleEntity(timestamp: Date(), total: total)
        
        let realm = try await Realm()
        try await realm.asyncWrite {
            realm.add(newSale)
            newSale.items.append(objectsIn: items)
        }
    }
    
    @MainActor func adjustStock(for item: ItemEntity, by amt: Int) async throws {
        if let invItem = item.thaw() {
            let newOnHandQty = invItem.onHandQty - amt
            let realm = try await Realm()
            try await realm.asyncWrite {
                invItem.onHandQty = newOnHandQty
            }
        }
    }
    
    @MainActor func sellItem(withId itemId: ObjectId, by amt: Int) async throws {
        let realm = try await Realm()
        if let invItem = realm.object(ofType: ItemEntity.self, forPrimaryKey: itemId) {
            let newOnHandQty = invItem.onHandQty - amt
            try await realm.asyncWrite {
                invItem.onHandQty = newOnHandQty
            }
        }
        
//        if let invItem = item.thaw() {
//            let newOnHandQty = invItem.onHandQty - amt
//            let realm = try await Realm()
//            try await realm.asyncWrite {
//                invItem.onHandQty = newOnHandQty
//            }
//        }
    }
    
    /// Try to get the number of sales, otherwise return 0
    @MainActor func getSalesCount() -> Int {
        let realm = try? Realm()
        let count = realm?.objects(SaleEntity.self).count ?? 0
        return count + 1
    }
    
    func deleteAll() async throws {
        let realm = try await Realm()
        try await realm.asyncWrite {
            realm.deleteAll()
        }
    }
}



extension AppError {
    private func authError(_ origError: Error) -> AppError {
        if let error = origError as? AppError {
            return switch error {
            case .departmentAlreadyExists:      AppError.departmentAlreadyExists
            case .departmentHasItems:           AppError.departmentHasItems
            case .departmentDoesNotExist:       AppError.departmentDoesNotExist
            case .departmentIsNil:              AppError.departmentIsNil
            case .invalidTaxPercentage:         AppError.invalidTaxPercentage
            case .invalidMarkup:                AppError.invalidMarkup
            case .invalidCompanyName:           AppError.invalidCompanyName
            case .invalidDepartment:            AppError.invalidDepartment
            case .invalidItemName:              AppError.invalidItemName
            case .invalidQuantity:              AppError.invalidQuantity
            case .invalidPrice:                 AppError.invalidPrice
            case .invalidCost:                  AppError.invalidCost
            case .numericThresholdRequired:     AppError.numericThresholdRequired
            case .noPasscodeProcesses:          AppError.noPasscodeProcesses
            case .noPasscodeFound:              AppError.noPasscodeFound
            case .noItemFound:                  AppError.noItemFound
            case .passcodesDoNotMatch:          AppError.passcodesDoNotMatch
            case .thawingDepartmentError:       AppError.thawingDepartmentError
            case .thawingItemError:             AppError.thawingItemError
            default:                            AppError.otherError(origError)
            }
        } else {
            return AppError.otherError(origError)
        }
    }
}
