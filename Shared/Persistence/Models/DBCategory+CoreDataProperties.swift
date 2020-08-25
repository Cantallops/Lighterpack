//
//  DBCategory+CoreDataProperties.swift
//  LighterPack
//
//  Created by acantallops on 2020/08/20.
//
//

import Foundation
import CoreData


extension DBCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBCategory> {
        return NSFetchRequest<DBCategory>(entityName: "DBCategory")
    }

    @NSManaged public var hexColor: String
    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var items: NSOrderedSet
    @NSManaged public var list: DBList

}

// MARK: Generated accessors for items
extension DBCategory {

    @objc(insertObject:inItemsAtIndex:)
    @NSManaged public func insertIntoItems(_ value: DBCategoryItem, at idx: Int)

    @objc(removeObjectFromItemsAtIndex:)
    @NSManaged public func removeFromItems(at idx: Int)

    @objc(insertItems:atIndexes:)
    @NSManaged public func insertIntoItems(_ values: [DBCategoryItem], at indexes: NSIndexSet)

    @objc(removeItemsAtIndexes:)
    @NSManaged public func removeFromItems(at indexes: NSIndexSet)

    @objc(replaceObjectInItemsAtIndex:withObject:)
    @NSManaged public func replaceItems(at idx: Int, with value: DBCategoryItem)

    @objc(replaceItemsAtIndexes:withItems:)
    @NSManaged public func replaceItems(at indexes: NSIndexSet, with values: [DBCategoryItem])

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: DBCategoryItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: DBCategoryItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSOrderedSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSOrderedSet)

}

extension DBCategory : Identifiable {

}
