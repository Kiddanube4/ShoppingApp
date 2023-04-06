//
//  HomeViewControllerViewModel.swift
//  ShoppingApp
//
//  Created by Namik Karabiyik on 2.03.2023.
//

import Foundation
import UIKit
protocol HomeVmdelegate{
    func initDidFinish()
    func initDidfail()
}
class HomeViewControllerViewModel
{
    var products = [Product]()
    private var productManager = ProductManager()
    private var cartManager = CartManager()
    var delegate:HomeVmdelegate?
    var totalSum = 0.0
    
    func initProducts(){
        productManager.initDefaultValue { with in
            switch with {
            case "success":
                self.delegate?.initDidFinish()
            default:
                print(with)
                self.delegate?.initDidfail()
            }
        }
    }
    
     func getProducts() {
            products = productManager.fetchProducts()
        
    }
    
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
    
    
}
