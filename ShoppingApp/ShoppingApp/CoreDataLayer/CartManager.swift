//
//  CartManager.swift
//  ShoppingApp
//
//  Created by Namik Karabiyik on 1.03.2023.
//

import Foundation
import CoreData

class CartManager:GeneralManager,CartManagerProtocol
{
    func fetchCart() -> [Cart] {
        let request: NSFetchRequest<Cart> = Cart.fetchRequest()
        request.returnsObjectsAsFaults  = false
        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? [Cart]()
    }
    
    @discardableResult func insertCartItem(productId: Int32, amount: Int32, productPrice: Double) -> Cart? {
        guard let cartItem = NSEntityDescription.insertNewObject(forEntityName: "Cart", into: backgroundContext) as? Cart else { return nil}
        cartItem.productId = productId
        cartItem.productPrice = productPrice
        cartItem.amount = amount
        return cartItem
    }
    
    func updateCart(productId: Int32,amount:Int32, productPrice: Double) {
        let request: NSFetchRequest<Cart> = Cart.fetchRequest()
        
        request.predicate = NSPredicate(format: "productId = %@",
                                        argumentArray: [productId])
        
        do {
            let results = try backgroundContext.fetch(request)
            if results.count != 0 {
                let cartItem = results[0]
                if (amount == 0) {
                    self.remove(objectID: cartItem.objectID)
                }else {
                    cartItem.setValue(amount, forKey: "amount")
                }
                
            }else {
                insertCartItem(productId: productId, amount: amount, productPrice: productPrice)
                
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        self.save()
    }
    
    func fetchCartForId(productId:Int32)->Cart? {
        let request: NSFetchRequest<Cart> = Cart.fetchRequest()
        
        request.predicate = NSPredicate(format: "productId = %@",
                                        argumentArray: [productId])
        request.returnsObjectsAsFaults = false
        
        
        do {
            let results = try backgroundContext.fetch(request)
            if results.count != 0 {
                let cartItem = results[0]
                return cartItem
            }else {
                return nil
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func save() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                print("Save error \(error)")
            }
        }
    }
    
    func remove( objectID: NSManagedObjectID ) {
        let obj = backgroundContext.object(with: objectID)
        backgroundContext.delete(obj)
    }
    
    func resetCart() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: Cart.description())
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try backgroundContext.execute(deleteRequest)
            try backgroundContext.save()
        } catch {
            print ("There was an error")
        }
    }
    
    
}
