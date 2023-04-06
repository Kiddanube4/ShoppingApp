//
//  Cart+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by Namik Karabiyik on 1.03.2023.
//
//

import Foundation
import CoreData


extension Cart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cart> {
        return NSFetchRequest<Cart>(entityName: "Cart")
    }

    @NSManaged public var productId: Int32
    @NSManaged public var amount: Int32
    @NSManaged public var productPrice: Double

}

extension Cart : Identifiable {

}
