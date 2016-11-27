//
//  NetworkOperation.swift
//  huff
//
//  Created by Xing Hui Lu on 11/26/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import Foundation

class NetworkOperation {
    let urlSession = URLSession.shared
    
    class func sharedInstance() -> NetworkOperation {
        struct Singleton {
            static let networkOperation = NetworkOperation()
        }
        return Singleton.networkOperation
    }
    
    // creates a get http request (default) - returns the task for possible future use
    func getRequest(url: URL, completionHandler: @escaping (Data?,Error?)->Void) -> URLSessionTask {
        let urlRequest = URLRequest(url: url)
        let task = createTask(urlRequest: urlRequest, completionHandler: completionHandler)
        task.resume()
        return task
    }
    
    // creates a post http request - returns the task for possible future use
    func postRequest(url: URL, completionHandler: @escaping (Data?,Error?)->Void) -> URLSessionTask {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        // create the encoded base64 string
        let keyAndSecret = TwitterService.PrivateKeys.ConsumerKey + ":" + TwitterService.PrivateKeys.ConsumerSecret
        let encodedValue = Data(keyAndSecret.utf8).base64EncodedString()
        // create encoded consumer key and secret
        urlRequest.addValue("Basic " + encodedValue, forHTTPHeaderField: NetworkConstants.Authorization)
        urlRequest.addValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: NetworkConstants.ContentType)
        let task = createTask(urlRequest: urlRequest, completionHandler: completionHandler)
        task.resume()
        return task
    }
    
    // MARK: - helper methods
    func createTask(urlRequest: URLRequest, completionHandler: @escaping (Data?,Error?)->Void) -> URLSessionTask {
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

extension NetworkOperation {
    struct NetworkConstants {
        static let ContentType = "Content-Type"
        static let Authorization = "Authorization"
        static let GrantType = "grant_type"
    }
}
