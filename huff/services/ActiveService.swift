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
        // find todays date and convert to string
        let todaysDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        // start date is tomorrows date
        let dateString = formatter.string(from: todaysDate.addingTimeInterval(60*60*24))
        let after4WeekString = formatter.string(from: todaysDate.addingTimeInterval(60*60*24*28))
        
        // build the parameters dict
        let parameters: [String: Any] = [ParameterKeys.Radius: 100,
                                            ParameterKeys.CurrentPage: 1,
                                            ParameterKeys.Query: "5K",
                                            ParameterKeys.Location: "\(location.coordinate.latitude), \(location.coordinate.longitude)",
                                            ParameterKeys.PerPage: 40,
                                            ParameterKeys.APIKey: ParameterValues.APIKey,
                                            ParameterKeys.Sort: "date_asc", //"distance",
                                            ParameterKeys.ExcludeChildren: "true",
                                            ParameterKeys.StartDate: dateString+".."+after4WeekString,
                                            ParameterKeys.Topic: "running"]
        let searchURL = getCompleteURL(parameters: parameters, scheme: Constants.Scheme, host: Constants.Host, method: Constants.Method)        
        let urlRequest = URLRequest(url: searchURL)
        _ = NetworkOperation.sharedInstance().request(urlRequest) { (data, error) -> Void in
            guard let data = data else {
                completionHandler(nil, error!)
                return
            }
            self.parseJSON(data: data, completionHandler: completionHandler)
        }
    }
}

extension ActiveService {
    fileprivate struct Constants {
        static let Scheme = "https"
        static let Host = "api.amp.active.com"
        static let Method = "/v2/search/"
    }
    
    fileprivate struct ParameterKeys {
        static let Location = "lat_lon"
        static let Radius = "radius"
        static let Query = "query"
        static let PerPage = "per_page"
        static let APIKey = "api_key"
        static let ExcludeChildren = "exclude_children"
        static let Sort = "sort"
        static let CurrentPage = "current_page"
        static let StartDate = "start_date"
        static let Topic = "topic"
    }
    
    fileprivate struct ParameterValues {
        static let APIKey = "***REMOVED***"
    }
}
