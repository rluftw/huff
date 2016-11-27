//
//  TwitterService.swift
//  huff
//
//  Created by Xing Hui Lu on 11/26/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import Foundation

class TwitterService {
    class func sharedInstance() -> TwitterService {
        struct Singleton {
            static let service = TwitterService()
        }
        return Singleton.service
    }
    
    func getBearerToken(completionHandler: @escaping ([String: AnyObject]?,Error?)->Void) {
        let requestTokenURL = getCompleteURL(parameters: [URLKeys.GrantType: "client_credentials" as AnyObject], method: MethodPath.ObtainToken)
        _ = NetworkOperation.sharedInstance().postRequest(url: requestTokenURL) { (data, error) -> Void in
            guard let data = data else {
                completionHandler(nil, error!)
                return
            }
            
            self.parseJSON(data: data, completionHandler: completionHandler)
        }
    }
    
    func search(searchQuery: String = Constants.SearchQuery, completion: (_ results: [String: AnyObject]?, _ error: Error?)->Void) {
        let searchURL = getCompleteURL(parameters: [URLKeys.Query: Constants.SearchQuery as AnyObject], method: MethodPath.Search)
        _ = NetworkOperation.sharedInstance().getRequest(url: searchURL) { (data, error) -> Void in

        
        }
    }
    
    fileprivate func getCompleteURL(parameters: [String: AnyObject], method: String) -> URL {
        var urlComponent = URLComponents()
        urlComponent.scheme = Constants.Scheme
        urlComponent.host = Constants.Host
        urlComponent.path = method
        urlComponent.queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            urlComponent.queryItems?.append(queryItem)
        }
        return urlComponent.url!
    }
    
    fileprivate func parseJSON(data: Data, completionHandler: ([String: AnyObject]?,Error?)->Void) {
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

extension TwitterService {
    fileprivate struct Constants {
        static let Scheme = "https"
        static let Host = "api.twitter.com"
        static let SearchQuery = "#huffrunapp"
    }
    
    fileprivate struct URLKeys {
        static let Query = "q"
        static let GrantType = "grant_type"
    }
    
    struct URLResponseValues {
        static let AccessToken = "access_token"
        static let TokenType = "token_type"
    }
    
    fileprivate struct MethodPath {
        static let ObtainToken = "/oauth2/token"
        static let Search = "/1.1/search/tweets.json"
    }
    
    struct PrivateKeys {
        static let ConsumerKey = "Consumer Key HERE"
        static let ConsumerSecret = "Consumer Secret HERE"
    }
}
