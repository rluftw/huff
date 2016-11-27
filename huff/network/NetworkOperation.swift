//
//  NetworkOperation.swift
//  huff
//
//  Created by Xing Hui Lu on 11/26/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import Foundation

enum HTTPMethod {
    case POST
    case GET
}

class NetworkOperation {
    let urlSession = URLSession.shared
    
    class func sharedInstance() -> NetworkOperation {
        struct Singleton {
            static let networkOperation = NetworkOperation()
        }
        return Singleton.networkOperation
    }
    
    func request(_ urlRequest: URLRequest, completionHandler: @escaping (Data?,Error?)->Void) -> URLSessionTask {
        let task = createTask(urlRequest: urlRequest, completionHandler: completionHandler)
        task.resume()
        return task
    }
    
    // MARK: - helper methods
    fileprivate func createTask(urlRequest: URLRequest, completionHandler: @escaping (Data?,Error?)->Void) -> URLSessionTask {
        let task = urlSession.dataTask(with: urlRequest) { (data, response, error) -> Void in
            // check if there are any errors in the results
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            // check the http response code (must be 200...299)
            guard let urlResponse = response as? HTTPURLResponse, 200...299 ~= urlResponse.statusCode else {
                print("status code: \(response as! HTTPURLResponse).statusCode)")
                
                let error = NSError(domain: "Invalid http response code", code: 10, userInfo: nil)
                completionHandler(nil, error)
                return
            }
            // lastly check if there's any data
            guard data != nil else {
                let error = NSError(domain: "No data returned", code: -1, userInfo: nil)
                completionHandler(nil, error)
                return
            }
            
            completionHandler(data, nil)
        }
        return task
    }
}
