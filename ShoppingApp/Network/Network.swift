//
//  Network.swift
//  ShoppingApp
//
//  Created by Fazlan on 9/16/19.
//  Copyright © 2019 Fazlan. All rights reserved.
//

import Foundation
import Alamofire

typealias CompletionHandler = (_ response: DataResponse<Any>?, _ error: Error?) -> Void


class NetworkRequest: NSObject {
    
    //creating global varibale
    static let shared = NetworkRequest()
    
    
    //MARK: Functions
    
    //sending a post request
    func sendPostRequest(url: String, requestType: HTTPMethod, param: [String: Any], completion: @escaping CompletionHandler) -> () {
        //requesting
        Alamofire.request(url, method: requestType, parameters: param, encoding: JSONEncoding.default, headers: nil).validate().responseJSON {
            response in
            
            switch response.result {
            case .success:
                print("Request Response Succeed")
                completion(response, nil)
            case .failure(let error):
                completion(response, error)
                print("Request Failed No Response")
            }
        }
    }
    
}
