//
//  URLService+Extensions.swift
//  ShoppingApp
//
//  Created by Namik Karabiyik on 28.02.2023.
//

import Foundation
enum HTTPMethod: String {
    //enum for all httpMethods other methods can be added later if needed
    // for example "PATCH" or "DELETE" or "POST"
    case get = "GET"

}

struct EndPoints
{
    //create an enum for all endpoints concat with baseUrl
   static let productEndpoint = "/6bb59bbc-e757-4e71-9267-2fee84658ff2"
}

struct ApiConstant
{
    //api constants such as baseUrl
    static let baseUrl = "https://mocki.io/v1"
}

extension URL
{
    //concat baseUrl with endPoint url add new variables in the futuce if a new endpoint is published
    static var productApiUrl: URL { URL(string: ApiConstant.baseUrl + EndPoints.productEndpoint) ?? URL(string: "")! }
}



 


