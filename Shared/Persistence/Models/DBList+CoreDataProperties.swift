//
//  DBList+CoreDataProperties.swift
//  LighterPack
//
//  Created by acantallops on 2020/08/19.
//
//

import Foundation
import CoreData


extension DBList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBList> {
        return NSFetchRequest<DBList>(entityName: "DBList")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var desc: String
    @NSManaged public var externalId: String
    @NSManaged public var categories: NSOrderedSet
    @NSManaged public var order: Int16

}

// MARK: Generated accessors for categories
extension DBList {

    @objc(insertObject:inCategoriesAtIndex:)
    @NSManaged public func insertIntoCategories(_ value: DBCategory, at idx: Int)

    @objc(removeObjectFromCategoriesAtIndex:)
    @NSManaged public func removeFromCategories(at idx: Int)

    @objc(insertCategories:atIndexes:)
    @NSManaged public func insertIntoCategories(_ values: [DBCategory], at indexes: NSIndexSet)

    @objc(removeCategoriesAtIndexes:)
    @NSManaged public func removeFromCategories(at indexes: NSIndexSet)

    @objc(replaceObjectInCategoriesAtIndex:withObject:)
    @NSManaged public func replaceCategories(at idx: Int, with value: DBCategory)

    @objc(replaceCategoriesAtIndexes:withCategories:)
    @NSManaged public func replaceCategories(at indexes: NSIndexSet, with values: [DBCategory])

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: DBCategory)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: DBCategory)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSOrderedSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSOrderedSet)

}

extension DBList : Identifiable {

}

extension DBList {

    var categoriesArray: [DBCategory] {
        (categories.array as? [DBCategory]) ?? []
    }

    var quantity: Int16 {
        categoriesArray.reduce(Int16(0)) { $0 + $1.quantity }
    }

    var price: Float {
        categoriesArray.reduce(0.0) { $0 + $1.price }
    }

    var weight: Float {
        categoriesArray.reduce(0.0) { $0 + $1.weight }
    }
}

