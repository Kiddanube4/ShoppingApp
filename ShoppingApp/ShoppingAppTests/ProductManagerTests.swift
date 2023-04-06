//
//  ProductManagerTests.swift
//  ShoppingAppTests
//
//  Created by Namik Karabiyik on 28.02.2023.
//

import XCTest
import CoreData

@testable import ShoppingApp


class ProductManagerTests:XCTestCase
{
    var mockProductManager:ProductManager!
    var saveNotificationCompleteHandler: ((Notification)->())?
    
    //MARK: mock in-memory persistant store
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PersistantProductManager", managedObjectModel: self.managedObjectModel)
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
        //create fake data before each test
        initStubs()
        mockProductManager = ProductManager(container: mockPersistantContainer)
        
        //Listen to the change in context
        NotificationCenter.default.addObserver(self, selector: #selector(contextSaved(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave , object: nil)
    }
    
    override func tearDown() {
        // destroy fake data after each test
        NotificationCenter.default.removeObserver(self)
        flushData()
        super.tearDown()
    }
    
    func testCreateProduct()
    {
        //given
        let productId:Int32 = 1
        let productName:String = "product1"
        let productDescription:String = "desc1"
        let productPrice:Double = 10.5
        let productImageUrl:Data = Data()
        
        //when
        measure {
            let newProduct = mockProductManager.insertProduct(productName: productName, productDescription: productDescription, productPrice: productPrice, productImageUrl: productImageUrl, productId: productId)
            
            //then
            //check if its nil
            XCTAssertNotNil(newProduct)
            //check if the values match without any corruption or loss
            XCTAssertEqual(newProduct!.productId, 1)
            XCTAssertEqual(newProduct!.productName, "product1")
            XCTAssertEqual(newProduct!.productDescription, "desc1")
            XCTAssertEqual(newProduct!.productPrice, 10.5)
            XCTAssertEqual(newProduct!.productImageUrl, Data())
        }
    }
    
    func testProductManagerFetchAll()
    {
        //given
        
        //when
        let allData = mockProductManager.fetchProducts()
        
        //then
        XCTAssertEqual(allData.count, 4)
    }
    
    func testInitDefaultValue()
    {
        //given
        
        //when
        mockProductManager = ProductManager()
        
        //then
        XCTAssertNotNil(mockProductManager)
    }
    
    
    func testSave()
    {
        //given
        let productId:Int32 = 2
        let productName:String = "product2"
        let productDescription:String = "desc2"
        let productPrice:Double = 10.2
        let productImageUrl:Data = Data()
        
        expectationForSaveNotification()
        mockProductManager.insertProduct(productName: productName, productDescription: productDescription, productPrice: productPrice, productImageUrl: productImageUrl, productId: productId)
        //when
        
        
        //then
        expectation(forNotification: NSNotification.Name(rawValue: Notification.Name.NSManagedObjectContextDidSave.rawValue), object: nil, handler: nil)
        mockProductManager.save()
        waitForExpectations(timeout: 1.0, handler: nil)
        
    }
    
    
    

    
    
}

extension ProductManagerTests
{
    
    //MARK: Convinient function for notification
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
    
    //MARK: Creat some fakes
    func initStubs() {

        
        func insertProduct(productId: Int32,
                           productName: String,
                           productDescription:String,
                           productPrice: Double,
                           productImageUrl:String) -> Product? {
            let datastr = productImageUrl.data(using: .ascii)
            let obj = NSEntityDescription.insertNewObject(forEntityName: "Product", into: mockPersistantContainer.viewContext)
            let productDatabaseModel = ["productId":productId,
                                        "productName":productName,
                                        "productDescription":productDescription,
                                        "productPrice":productPrice,
                                        "productImageUrl":datastr]  as [String : Any]
            obj.setValuesForKeys(productDatabaseModel)
       
            
            return obj as? Product
        }
        
        _ = insertProduct(productId: 1, productName: "product1", productDescription: "desc1", productPrice: 20.5, productImageUrl: "imgurl1")
        _ = insertProduct(productId: 2, productName: "product2", productDescription: "desc2", productPrice: 10.1, productImageUrl: "imgUrl2")
        _ = insertProduct(productId: 3, productName: "product3", productDescription: "desc3", productPrice: 20.5, productImageUrl: "imgUrl3")
        _ = insertProduct(productId: 4, productName: "product4", productDescription: "desc4", productPrice: 10.1, productImageUrl: "imgUrl4")
        
        do {
            try mockPersistantContainer.viewContext.save()
        }  catch {
            print("create fakes error \(error)")
        }

    }
    
    
    func flushData() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        let objs = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            mockPersistantContainer.viewContext.delete(obj)
        }
        
        try! mockPersistantContainer.viewContext.save()
    }
}
