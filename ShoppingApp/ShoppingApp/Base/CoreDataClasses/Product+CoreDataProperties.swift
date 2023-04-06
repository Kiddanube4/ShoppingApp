//
//  Product+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by Namik Karabiyik on 28.02.2023.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var productName: String?
    @NSManaged public var productDescription: String?
    @NSManaged public var productPrice: Double
    @NSManaged public var productImageUrl: Data?
    @NSManaged public var productId: Int32

}

extension Product : Identifiable {

}
