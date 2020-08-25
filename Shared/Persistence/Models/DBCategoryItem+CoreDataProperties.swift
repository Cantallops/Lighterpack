//
//  DBCategoryItem+CoreDataProperties.swift
//  LighterPack
//
//  Created by acantallops on 2020/08/25.
//
//

import Foundation
import CoreData


extension DBCategoryItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBCategoryItem> {
        return NSFetchRequest<DBCategoryItem>(entityName: "DBCategoryItem")
    }

    @NSManaged public var consumable: Bool
    @NSManaged public var quantity: Int16
    @NSManaged public var star: Int16
    @NSManaged public var worn: Bool
    @NSManaged public var category: DBCategory
    @NSManaged public var item: DBItem

}

extension DBCategoryItem : Identifiable {

}
