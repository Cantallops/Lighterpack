//
//  Library.swift
//  LighterPack
//
//  Created by acantallops on 2020/08/19.
//

import Foundation

struct Library: Codable {
    let version: String
    let totalUnit: WeigthUnit
    let itemUnit: WeigthUnit
    let defaultListId: Int
    let sequence: Int
    let showSidebar: Bool
    let currencySymbol: String
    let items: [Item]
    let categories: [Category]
    let lists: [GearList]
    let optionalFields: OptionalFields
}

struct OptionalFields: Codable {
    let images: Bool
    let price: Bool
    let worn: Bool
    let consumable: Bool
    let listDescription: Bool
}
