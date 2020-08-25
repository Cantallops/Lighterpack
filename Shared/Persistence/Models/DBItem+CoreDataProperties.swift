//
//  DBItem+CoreDataProperties.swift
//  LighterPack
//
//  Created by acantallops on 2020/08/19.
//
//

import Foundation
import CoreData


extension DBItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBItem> {
        return NSFetchRequest<DBItem>(entityName: "DBItem")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var desc: String
    @NSManaged public var weight: Float
    @NSManaged public var authorUnit: String
    @NSManaged public var price: Float
    @NSManaged public var url: String
    @NSManaged public var image: String
    @NSManaged public var imageURL: String
    @NSManaged public var categoryItems: NSOrderedSet

}

// MARK: Generated accessors for categoryItems
extension DBItem {

    @objc(insertObject:inCategoryItemsAtIndex:)
    @NSManaged public func insertIntoCategoryItems(_ value: DBCategoryItem, at idx: Int)

    @objc(removeObjectFromCategoryItemsAtIndex:)
    @NSManaged public func removeFromCategoryItems(at idx: Int)

    @objc(insertCategoryItems:atIndexes:)
    @NSManaged public func insertIntoCategoryItems(_ values: [DBCategoryItem], at indexes: NSIndexSet)

    @objc(removeCategoryItemsAtIndexes:)
    @NSManaged public func removeFromCategoryItems(at indexes: NSIndexSet)

    @objc(replaceObjectInCategoryItemsAtIndex:withObject:)
    @NSManaged public func replaceCategoryItems(at idx: Int, with value: DBCategoryItem)

    @objc(replaceCategoryItemsAtIndexes:withCategoryItems:)
    @NSManaged public func replaceCategoryItems(at indexes: NSIndexSet, with values: [DBCategoryItem])

    @objc(addCategoryItemsObject:)
    @NSManaged public func addToCategoryItems(_ value: DBCategoryItem)

    @objc(removeCategoryItemsObject:)
    @NSManaged public func removeFromCategoryItems(_ value: DBCategoryItem)

    @objc(addCategoryItems:)
    @NSManaged public func addToCategoryItems(_ values: NSOrderedSet)

    @objc(removeCategoryItems:)
    @NSManaged public func removeFromCategoryItems(_ values: NSOrderedSet)

}

extension DBItem : Identifiable {

}
