//
//  Service.swift
//  huff
//
//  Created by Xing Hui Lu on 11/30/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import Foundation

class Service {
    func getCompleteURL(parameters: [String: Any], scheme: String, host: String, method: String) -> URL {
        var urlComponent = URLComponents()
        urlComponent.scheme = scheme
        urlComponent.host = host
        urlComponent.path = method
        urlComponent.queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            urlComponent.queryItems?.append(queryItem)
        }
        return urlComponent.url!
    }
    
    func parseJSON(data: Data, completionHandler: ([String: AnyObject]?,Error?)->Void) {
        var parseError: Error?
        let parsedResults: [String: AnyObject]?
        do {
            parsedResults = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject]
        } catch let error {
            parseError = error
            parsedResults = nil
        }
        guard let error = parseError else {
            completionHandler(parsedResults, nil)
            return
        }
        completionHandler(nil, error)
    }
}
