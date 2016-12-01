//
//  ActiveService.swift
//  huff
//
//  Created by Xing Hui Lu on 11/30/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import Foundation
import CoreLocation

class ActiveService: Service {
    class func sharedInstance() -> ActiveService {
        struct Singleton {
            static let activeService = ActiveService()
        }
        return Singleton.activeService
    }
    
    func search(location: CLLocation, completionHandler: @escaping ([String: AnyObject]?,Error?)->Void) {
        let parameters: [String: Any] = [ParameterKeys.Radius: 50,
                                               ParameterKeys.Query: "5k",
                                               ParameterKeys.Location: "\(location.coordinate.latitude),\(location.coordinate.longitude)",
                                               ParameterKeys.PerPage: 40,
                                               ParameterKeys.APIKey: ParameterValues.APIKey]
        let searchURL = getCompleteURL(parameters: parameters, scheme: Constants.Scheme, host: Constants.Host, method: Constants.Method)
        let urlRequest = URLRequest(url: searchURL)
        _ = NetworkOperation.sharedInstance().request(urlRequest) { (data, error) -> Void in
            guard let data = data else {
                completionHandler(nil, error!)
                return
            }
            // TODO: this return may be in xml format instead of json.
            self.parseJSON(data: data, completionHandler: completionHandler)
        }

    }
}

extension ActiveService {
    fileprivate struct Constants {
        static let Scheme = "http"
        static let Host = "developer.active.com"
        static let Method = "/docs/v2_activity_api_search"
    }
    
    fileprivate struct ParameterKeys {
        static let Location = "lat_lon"
        static let Radius = "radius"
        static let Query = "q"
        static let PerPage = "per_page"
        static let APIKey = "api_key"
    }
    
    fileprivate struct ParameterValues {
        static let APIKey = "API Key Here"
    }
}
