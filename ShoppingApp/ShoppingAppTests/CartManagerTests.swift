//
//  CartManagerTests.swift
//  ShoppingAppTests
//
//  Created by Namik Karabiyik on 1.03.2023.
//

import Foundation
import CoreData
import XCTest
 
@testable import ShoppingApp


class CartManagerTests:XCTestCase
{
    var mockCartManager:CartManager!
    var saveNotificationCompleteHandler: ((Notification)->())?
    
    //MARK: mock in-memory persistant store
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PersistantCartManager", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
            
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
    
    override func setUp() {
        initStubs()
        mockCartManager = CartManager(container: mockPersistantContainer)
        
        //Listen to the change in context
        NotificationCenter.default.addObserver(self, selector: #selector(contextSaved(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave , object: nil)
        
    }
    
    override func tearDown() {
        NotificationCenter.default.removeObserver(self)
        flushData()
        super.tearDown()
    }
    
    
    func testCreatecartItem()
    {
        //given
        let productId:Int32 = 1
        let productPrice:Double = 20.2
        let amount:Int32 = 2
        
        //when
        let newCartItem = mockCartManager.insertCartItem(productId: productId, amount: amount, productPrice: productPrice)
        
        //then
        XCTAssertNotNil(newCartItem)
        //check for value match
        XCTAssertEqual(newCartItem!.productId, productId)
        XCTAssertEqual(newCartItem!.productPrice, productPrice)
        XCTAssertEqual(newCartItem!.amount, amount)
    }
    
    func testFetchAllCartItems()
    {
        //given
        
        //when
        let allCartItems = mockCartManager.fetchCart()
        
        //then
        XCTAssertEqual(allCartItems.count, 3)
    }
    
    func testSave()
    {
        //given
        let productId:Int32 = 2
        let amount:Int32 = 10
        let productPrice:Double = 10.2

        //when
        expectationForSaveNotification()
        mockCartManager.insertCartItem(productId: productId, amount: amount, productPrice: productPrice)
       
        
        
        //then
        expectation(forNotification: NSNotification.Name(rawValue: Notification.Name.NSManagedObjectContextDidSave.rawValue), object: nil, handler: nil)
        mockCartManager.save()
        waitForExpectations(timeout: 1.0, handler: nil)
        
    }
}

extension CartManagerTests
{
    
    @discardableResult func expectationForSaveNotification() -> XCTestExpectation {
        let expect = expectation(description: "Context Saved")
        waitForSavedNotification { (notification) in
            expect.fulfill()
        }
        return expect
    }
    
    func waitForSavedNotification(completeHandler: @escaping ((Notification)->()) ) {
        saveNotificationCompleteHandler = completeHandler
    }
    
    func contextSaved( notification: Notification ) {
        print("\(notification)")
        saveNotificationCompleteHandler?(notification)
    }
    
    
    func initStubs() {
        
       @discardableResult func insertCartItem(productId: Int32,
                            amount:Int32,
                            productPrice: Double) -> Cart? {
            let obj = NSEntityDescription.insertNewObject(forEntityName: "Cart", into: mockPersistantContainer.viewContext)
            let productDatabaseModel = ["productId":productId,
                                        "productPrice":productPrice,
                                        "amount":amount
                                          ]  as [String : Any]
            obj.setValuesForKeys(productDatabaseModel)
       
            
            return obj as? Cart
        }
        insertCartItem(productId: 1, amount: 5, productPrice: 50)
        insertCartItem(productId: 3, amount: 7, productPrice: 20)
        insertCartItem(productId: 6, amount: 9, productPrice: 10)
        
        
        
        do {
            try mockPersistantContainer.viewContext.save()
        }  catch {
            print("create fakes error \(error)")
        }

    }
    
    func flushData() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let objs = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            mockPersistantContainer.viewContext.delete(obj)
        }
        
        try! mockPersistantContainer.viewContext.save()
    }
}
