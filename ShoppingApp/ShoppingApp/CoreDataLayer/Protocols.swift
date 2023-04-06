//
//  Protocols.swift
//  ShoppingApp
//
//  Created by Namik Karabiyik on 28.02.2023.
//

import Foundation
import CoreData
protocol ProductManagerProtocol
{
    func fetchProducts()->[Product]
    
    @discardableResult func insertProduct(productName:String
                       ,productDescription:String
                       ,productPrice:Double,
                       productImageUrl:Data,
                       productId:Int32) -> Product?
    
    func save()
    
    func fetchProductById(productId: Int32)-> Product?
}


protocol CartManagerProtocol
{
    func fetchCart()->[Cart]
    
    @discardableResult func insertCartItem(productId:Int32,
                                           amount: Int32,
                                           productPrice: Double) -> Cart?
    func save()
    
    func fetchCartForId(productId:Int32)->Cart?
}
