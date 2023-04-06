//
//  ProductManager.swift
//  ShoppingApp
//
//  Created by Namik Karabiyik on 28.02.2023.
//

import Foundation
import CoreData
import UIKit

class ProductManager:GeneralManager, ProductManagerProtocol {
 
    
    func initDefaultValue(onComplete:@escaping(_ with:String)->()) {
        // check if no product is added
        if fetchProducts().count == 0 {
            // give products Id's so we can search them later
            var productId = 0
            WebService.getProducts(url: URL.productApiUrl, method: .get) { Products in
                for product in Products {
                    guard let productImgData = product.productImage?.toData(isRaw: true) else {return}
                    
                    self.insertProduct(productName: product.productName ?? "",
                                       productDescription: product.productDescription ?? "",
                                       productPrice: product.productPrice ?? 0.0,
                                       productImageUrl: productImgData,
                                       productId: Int32(productId))
                    self.save()
                    // auto increment Id after each insert
                    productId += 1
                }
                onComplete("success")
            } callBackError: { Error in
                onComplete(Error.description)
            }
        }else {
            onComplete("products already set")
        }
        
    }
    
    func fetchProducts() -> [Product] {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.returnsObjectsAsFaults  = false
        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? [Product]()
    }
    
    
    func fetchProductById(productId: Int32)-> Product? {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        
        request.predicate = NSPredicate(format: "productId = %@",
                                        argumentArray: [productId])
        request.returnsObjectsAsFaults = false
        
        
        do {
            let results = try backgroundContext.fetch(request)
            if results.count != 0 {
                let product = results[0]
                return product
            }else {
                return nil
            }
        }catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    
    
    @discardableResult func insertProduct(productName: String, productDescription: String, productPrice: Double, productImageUrl: Data, productId: Int32)-> Product? {
        guard let product = NSEntityDescription.insertNewObject(forEntityName: "Product", into: backgroundContext) as? Product else { return nil}
        product.productId = productId
        product.productName = productName
        product.productDescription = productDescription
        product.productImageUrl  = productImageUrl
        product.productPrice = productPrice
        return product
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
    
    
}
