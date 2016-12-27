//
//  FirebaseRemoteConfigService.swift
//  huff
//
//  Created by Xing Hui Lu on 12/26/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import Foundation
import Firebase

extension FirebaseService {
    // MARK: - remote configuration
    
    func fetchQuotes(completionHandler: @escaping (String?, String?)->Void) {
        remoteConfig.fetch(withExpirationDuration: 0) { (status: FIRRemoteConfigFetchStatus, error: Error?) in
            if status == .success {
                print("remote fetch successful")
                
                self.remoteConfig.activateFetched()
                let quote = self.remoteConfig["quote"]
                let author = self.remoteConfig["author"]
                
                if quote.source != .static && author.source != .static {
                    DispatchQueue.main.async(execute: {
                        completionHandler(quote.stringValue, author.stringValue)
                    })
                }
            }
            
        }
    }
}
