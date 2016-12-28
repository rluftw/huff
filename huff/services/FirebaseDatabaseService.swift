//
//  FirebaseService.swift
//  huff
//
//  Created by Xing Hui Lu on 12/25/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

// TODO: figure out how to reset this class for new users.
// idea is to destroy the past singleton and create a new one when called

import Foundation
import Firebase

enum ActiveRunAction {
    case Remove
    case Add
}

class FirebaseService {
    var databaseRef: FIRDatabaseReference!
    var addPersonalRunHandler: FIRDatabaseHandle?
    var remoteConfig: FIRRemoteConfig!
    
    let weekOfYear: Int!
    let year: Int!
    lazy var userNodeDatabaseRef: FIRDatabaseReference! = {
        return FIRDatabase.database().reference().child("users/\(FirebaseService.getCurrentUser().uid)")
    }()
    
    lazy var globalNodeDatabaseRef: FIRDatabaseReference! = {
        return FIRDatabase.database().reference().child("global_runs/week\(self.weekOfYear ?? 1)-\(self.year ?? 2017)")
    }()
    
    private static var fbService: FirebaseService?
    class func sharedInstance() -> FirebaseService {
        guard let service = fbService else {
            fbService = FirebaseService()
            return fbService!
        }
        return service
    }
    
    class func destroy() {
        fbService = nil
        print("service destroyed")
    }

    // MARK: - initialization
    init() {
        databaseRef = FIRDatabase.database().reference()
        
        let components = Calendar.current.dateComponents([.weekOfYear, .year], from: Date())
        weekOfYear = components.weekOfYear!
        year = components.year!
        
        // set up remote configurations
        let settings = FIRRemoteConfigSettings(developerModeEnabled: true)
        remoteConfig = FIRRemoteConfig.remoteConfig()
        remoteConfig.configSettings = settings!
    }
    
    // MARK: - database operations
    
    func fetchPersonalRuns(completionHandler: @escaping (FIRDataSnapshot)->Void) -> FIRDatabaseHandle {
        return userNodeDatabaseRef!.child("personal_runs")
            .queryOrdered(byChild: "timestamp")
            .observe(.childAdded, with: { (localSnapshot) in
                completionHandler(localSnapshot)
            })
    }
    
    func fetchBestPace(completionHandler: @escaping (FIRDataSnapshot)->Void) {
        userNodeDatabaseRef.child("personal_runs/best_pace")
            .observeSingleEvent(of: .value, with: { (localSnapshot) in
                completionHandler(localSnapshot)
            })
    }
    
    func fetchBestDistance(completionHandler: @escaping (FIRDataSnapshot)->Void) {
        userNodeDatabaseRef.child("personal_runs/best_distance")
            .observeSingleEvent(of: .value, with: { (localSnapshot) in
                completionHandler(localSnapshot)
            })
    }
    
    func fetchAccountNode(completionhandler: @escaping (FIRDataSnapshot)->Void) {
        userNodeDatabaseRef.observeSingleEvent(of: .value) { (localSnapshot) in
            completionhandler(localSnapshot)
        }
    }
    
    
    func observeLikedRuns(eventType: FIRDataEventType, completionHandler: @escaping (FIRDataSnapshot)->Void) -> FIRDatabaseHandle {
        return userNodeDatabaseRef.child("liked_runs").observe(eventType, with: { (localSnapshot) in
            completionHandler(localSnapshot)
        })
    }
    
    func removeRunWith(id: String, completionHandler: (()->Void)? = nil) {
        userNodeDatabaseRef.child("liked_runs/\(id)").removeValue()
        completionHandler?()
    }
    
    func fetchGlobalHSDistance(completionHandler: @escaping (FIRDataSnapshot)->Void) -> FIRDatabaseHandle {
        return globalNodeDatabaseRef
            .queryLimited(toFirst: 20)
            .observe(.childAdded, with: { (localSnapshot) in
                completionHandler(localSnapshot)
            })
    }
    
    func saveRun(run: Run) {
        userNodeDatabaseRef
            .child("personal_runs/week\(self.weekOfYear ?? 1)-\(self.year ?? 2017)")
            .childByAutoId()
            .setValue(run.toDict(), andPriority: run.timestamp)
    }
    
    func saveDistanceToGlobal() {
        userNodeDatabaseRef
            .child("personal_runs/week\(self.weekOfYear ?? 1)-\(self.year ?? 2017)")
            .observeSingleEvent(of: .value, with: { (localSnaphot) in
            guard let snapshot = localSnaphot.value as? [String: Any] else { return }
                
            var totalDistance: Double = 0
            for key in snapshot.keys {
                if let runDict = snapshot[key] as? [String: Any], let distance = runDict["distance"] as? Double {
                    totalDistance += distance
                }
            }
            self.globalNodeDatabaseRef
                .child("\(FirebaseService.getCurrentUser().uid)")
                .setValue([
                    "distance": totalDistance,
                    "username": FIRAuth.auth()!.currentUser!.email?.components(separatedBy: "@")[0] ?? FIRAuth.auth()!.currentUser!.displayName!
                    ], andPriority: totalDistance)
        })
    }
    
}


extension FirebaseService {
    // MARK: - utility methods
    
    func removeObserver(handler: UInt?) {
//        guard let handler = handler else { return }
        databaseRef.removeObserver(withHandle: handler!)
    }
    
    static func getCurrentUser() -> FIRUser {
        return FIRAuth.auth()!.currentUser!
    }
    
    func fetchActiveRunLikeStatus(completionHandler: @escaping (FIRDataSnapshot)->Void) {
        let assetsReference = userNodeDatabaseRef.child("liked_runs")
        
        assetsReference.observeSingleEvent(of: .value, with: { (localSnapshot) in
            completionHandler(localSnapshot)
        })
    }
    
    // used to like or unlike an active run
    func activeRunAction(action: ActiveRunAction, run: ActiveRun, completionHandler: ()->Void) {
        let assetsReference = userNodeDatabaseRef.child("liked_runs")
        action == .Remove ?
            assetsReference.child("\(run.assetID!)").removeValue():
            assetsReference.child("\(run.assetID!)").setValue(run.toDict())
        completionHandler()
    }
    
    func setAccountCreationDate() {
        userNodeDatabaseRef.setValue(["creation_date": Date().timeIntervalSince1970])
    }
    
    func updateBestDistance(distance: Double) {
        userNodeDatabaseRef.child("personal_runs/best_distance").setValue(distance)
    }
    
    func updateBestPace(run: Run) {
        userNodeDatabaseRef.child("personal_runs/best_pace").setValue(run.toDict())
    }
    
    func removeGlobalRunInfo() {
        globalNodeDatabaseRef.child(FirebaseService.getCurrentUser().uid).removeValue()
    }
    
    func removeUser() {
        userNodeDatabaseRef.removeValue()
    }
}
