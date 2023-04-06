//
//  ProductApiModel.swift
//  ShoppingApp
//
//  Created by Namik Karabiyik on 28.02.2023.
//

import Foundation
struct ProductApiModel:Decodable
{
    var productName:String?
    var productDescription:String?
    var productPrice:Double?
    var productImage:String?
}
