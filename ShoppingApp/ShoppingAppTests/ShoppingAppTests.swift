//
//  ShoppingAppTests.swift
//  ShoppingAppTests
//
//  Created by Erdem Perşembe on 12.04.2022.
//

import XCTest
@testable import ShoppingApp

class ShoppingAppTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testUrlExtensionReturnApiUrl()
    {
        let apiUrl = URL.productApiUrl
        
        XCTAssertEqual(apiUrl, URL(string: "https://mocki.io/v1/6bb59bbc-e757-4e71-9267-2fee84658ff2"))
    }
    
    func testUrlMethodReturnsGET()
    {
        let httpMethod = HTTPMethod.get.rawValue
        
        XCTAssertEqual(httpMethod, "GET")
    }
    
    
    func testWebServiceProductapiReturnsProduct()
    {
        measure {
            WebService.getProducts(url: URL.productApiUrl, method: .get) { Products in
                XCTAssertNotNil(Products)
            } callBackError: { Error in
            }
        }
    }

}
