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
