//
//  CartViewModel.swift
//  ShoppingApp
//
//  Created by Namik Karabiyik on 5.03.2023.
//

import Foundation
import CoreData

class CartViewModel {
    
    private var cartManager = CartManager()
    private var productManager = ProductManager()
    
    var totalSum = 0.0
    var products = [Product]()
    
    
    func getCart() -> [Cart] {
        return cartManager.fetchCart()
    }
    
    @discardableResult func getTotalPrice()-> Double{
        totalSum = 0.0
        let cart = getCart()
        for item in cart {
            totalSum += item.productPrice * Double(item.amount)
        }
        return totalSum
    }
    func getCellData<T>(at indexPath: IndexPath, from data: [T?]) -> T? {
        return data.isEmpty == true ? nil : data[indexPath.row]
    }
    
    func getProductById(productId: Int32)-> Product? {
        return productManager.fetchProductById(productId: productId)
    }
    
    func getCartProducts(){
        //get current cart
        let currentCart = getCart()
        products = []
        for cartItem in currentCart {
            guard  let product = productManager.fetchProductById(productId: cartItem.productId) else {return}
            products.append(product)
        }
        
       
    }
    
    func resetCart() {
        cartManager.resetCart()
    }
}
