//
//  ProductDetailVM.swift
//  ShoppingApp
//
//  Created by Namik Karabiyik on 4.03.2023.
//

import Foundation


class ProductDetailVM {
    private var cartManager = CartManager()
    var product = Product()
    
    init(product: Product = Product()) {
        self.product = product
    }
    
   @discardableResult func addToCart(amount: Int32, productId: Int32, productPrice: Double) -> Cart?  {
        let cartItem = cartManager.insertCartItem(productId: productId,
                                   amount: amount,
                                   productPrice: productPrice)
       //for test purposes
       return cartItem

    }
    
    func updateCart(amount: Int32, productId: Int32, productPrice: Double ) {
         cartManager.updateCart(productId: productId, amount: amount, productPrice: productPrice)
    }
    
    func fetchCartForItem(productId:Int32)-> Cart? {
        if let cartItem = cartManager.fetchCartForId(productId: productId) {
            return cartItem
        }
      
        return nil
    }
    
    
}
