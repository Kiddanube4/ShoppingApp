//
//  WebService.swift
//  ShoppingApp
//
//  Created by Namik Karabiyik on 28.02.2023.
//

import Foundation

protocol WebServiceProtocol
{
    static func getProducts(url:URL,method:HTTPMethod,callBackSuccess:@escaping(_ result:[ProductApiModel])->Void,callBackError:@escaping(_ error:String)->Void)
}

class WebService:WebServiceProtocol
{
    static func getProducts(url: URL,method:HTTPMethod, callBackSuccess: @escaping ([ProductApiModel]) -> Void, callBackError: @escaping (String) -> Void) {
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 40.0)
        request.httpMethod = method.rawValue
        URLSession.shared.dataTask(with: request){ data,response,error in
            if let httpResponse = response as? HTTPURLResponse{
                //check if the status code is in acceptible range
                if 200 ..< 300 ~= httpResponse.statusCode
                {
                    //200 to 300 is acceptable range
                    guard let jsonData = data else {return}
                    let decoder = JSONDecoder()
                    if let products = try? decoder.decode([ProductApiModel].self, from: jsonData) {
                        DispatchQueue.main.async {
                            callBackSuccess(products)
                        }
                    }else
                    {
                        //json conversion failure
                       callBackError("Could not retrive products")
                    }
                }else
                {
                    callBackError("")
                }
            }
        }.resume()
    }
    
    
}


