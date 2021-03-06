//
//  TwitterService.swift
//  huff
//
//  Created by Xing Hui Lu on 11/26/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import Foundation

class TwitterService: Service {
    let MyKeychainWrapper = KeychainWrapper()
    
    class func sharedInstance() -> TwitterService {
        struct Singleton {
            static let service = TwitterService()
        }
        return Singleton.service
    }
    
    func getBearerToken(completionHandler: @escaping ([String: AnyObject]?,Error?)->Void) {
        let requestTokenURL = getCompleteURL(parameters: [URLKeys.GrantType: "client_credentials"], scheme: Constants.Scheme, host: Constants.Host, method: MethodPath.ObtainToken)
        var urlRequest = URLRequest(url: requestTokenURL)
        urlRequest.httpMethod = "POST"
        // create the encoded base64 string
        let keyAndSecret = TwitterService.PrivateKeys.ConsumerKey + ":" + TwitterService.PrivateKeys.ConsumerSecret
        let encodedValue = Data(keyAndSecret.utf8).base64EncodedString()
        // create encoded consumer key and secret
        urlRequest.addValue("Basic " + encodedValue, forHTTPHeaderField: NetworkConstants.Authorization)
        urlRequest.addValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: NetworkConstants.ContentType)
        
        _ = NetworkOperation.sharedInstance().request(urlRequest) { (data, error) -> Void in
            guard let data = data else {
                completionHandler(nil, error!)
                return
            }
            self.parseJSON(data: data, completionHandler: completionHandler)
        }
    }
    
    // *** NOTE *** the twitter search api only searched for tweets in the past 7 days
    func search(searchQuery: String = Constants.SearchQuery, completionHandler: @escaping ([String: AnyObject]?,Error?)->Void) {
        var bearerToken: String!
        // check if we have a bearer token in keychain
        if !UserDefaults.standard.bool(forKey: StorageKeys.IsBearerStored) {
            print("No bearer token stored - attempting to request for one.")
            
            getBearerToken { (resultDict, error) in
                guard let results = resultDict else {
                    return
                }
                bearerToken = results[TwitterService.URLResponseValues.AccessToken] as! String
                // store the actual bearer token
                self.MyKeychainWrapper.mySetObject(bearerToken, forKey: kSecValueData)
                self.MyKeychainWrapper.writeToKeychain()
                // store the boolean value of whether the bearer token is there
                UserDefaults.standard.set(true, forKey: StorageKeys.IsBearerStored)
                UserDefaults.standard.synchronize()
                self.performSearch(bearerToken: bearerToken, completionHandler: completionHandler)
            }
        } else {
            bearerToken = MyKeychainWrapper.myObject(forKey: kSecValueData) as? String
            performSearch(bearerToken: bearerToken, completionHandler: completionHandler)
        }
        
    }
    
    private func performSearch(bearerToken: String?, searchQuery: String = Constants.SearchQuery, completionHandler: @escaping ([String: AnyObject]?,Error?)->Void) {
        
        let searchURL = getCompleteURL(parameters: [URLKeys.Query: Constants.SearchQuery], scheme: Constants.Scheme, host: Constants.Host, method: MethodPath.Search)
        var urlRequest = URLRequest(url: searchURL)
        urlRequest.addValue("Bearer \(bearerToken ?? "")", forHTTPHeaderField: NetworkConstants.Authorization)
        _ = NetworkOperation.sharedInstance().request(urlRequest) { (data, error) -> Void in
            guard let data = data else {
                completionHandler(nil, error!)
                return
            }
            self.parseJSON(data: data, completionHandler: completionHandler)
        }

    }
    
}

extension TwitterService {
    struct StorageKeys {
        static let IsBearerStored = "isBearerStored"
    }
    
    struct Constants {
        static let Scheme = "https"
        static let Host = "api.twitter.com"
        static let SearchQuery = "#huffapp"
    }
    
    struct NetworkConstants {
        static let ContentType = "Content-Type"
        static let Authorization = "Authorization"
        static let GrantType = "grant_type"
    }
    
    struct URLKeys {
        static let Query = "q"
        static let GrantType = "grant_type"
    }
    
    struct URLResponseValues {
        static let AccessToken = "access_token"
        static let TokenType = "token_type"
    }
    
    struct MethodPath {
        static let ObtainToken = "/oauth2/token"
        static let Search = "/1.1/search/tweets.json"
    }
    
    struct PrivateKeys {
        static let ConsumerKey = "<Consumer Key>"
        static let ConsumerSecret = "<Consumer Secret>"
    }
}
