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
    var databaseRef: DatabaseReference!
    var addPersonalRunHandler: DatabaseHandle?
    var remoteConfig: RemoteConfig!
    
    let weekOfYear: Int!
    let year: Int!
    lazy var userNodeDatabaseRef: DatabaseReference! = {
        let userNodeRef = Database.database().reference().child("users/\(FirebaseService.getCurrentUser().uid)")
        userNodeRef.keepSynced(true)
        return userNodeRef
    }()
    
    lazy var globalNodeDatabaseRef: DatabaseReference! = {
        let globalNodeRef = Database.database().reference().child("global_runs/week\(self.weekOfYear ?? 1)-\(self.year ?? 2017)")
        globalNodeRef.keepSynced(false)
        return globalNodeRef
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
    }

    // MARK: - initialization
    init() {
        databaseRef = Database.database().reference()
        
        let components = Calendar.current.dateComponents([.weekOfYear, .year], from: Date())
        weekOfYear = components.weekOfYear!
        year = components.year!
        
        // set up remote configurations
        let settings = RemoteConfigSettings(developerModeEnabled: true)
        remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.configSettings = settings!
    }
    
    // MARK: - database operations
    
    func fetchPersonalRuns(completionHandler: @escaping (DataSnapshot)->Void) -> DatabaseHandle {
        return userNodeDatabaseRef!.child("personal_runs")
            .queryOrdered(byChild: "timestamp")
            .observe(.childAdded, with: { (localSnapshot) in
                completionHandler(localSnapshot)
            })
    }
    
    func fetchBestPace(completionHandler: @escaping (DataSnapshot)->Void) -> DatabaseHandle{
        return userNodeDatabaseRef.child("personal_runs/best_pace")
            .observe(.value, with: { (localSnapshot) in
                completionHandler(localSnapshot)
            })
    }
    
    func fetchBestDistance(completionHandler: @escaping (DataSnapshot)->Void) -> DatabaseHandle{
        return userNodeDatabaseRef.child("personal_runs/best_distance")
            .observe(.value, with: { (localSnapshot) in
                completionHandler(localSnapshot)
            })
    }
    
    func fetchAccountNode(completionhandler: @escaping (DataSnapshot)->Void) {
        userNodeDatabaseRef.observeSingleEvent(of: .value) { (localSnapshot) in
            completionhandler(localSnapshot)
        }
    }
    
    
    func observeLikedRuns(eventType: DataEventType, completionHandler: @escaping (DataSnapshot)->Void) -> DatabaseHandle {
        return userNodeDatabaseRef.child("liked_runs").observe(eventType, with: { (localSnapshot) in
            completionHandler(localSnapshot)
        })
    }
    
    func removeRunWith(id: String, completionHandler: (()->Void)? = nil) {
        userNodeDatabaseRef.child("liked_runs/\(id)").removeValue()
        completionHandler?()
    }
    
    func fetchGlobalHSDistance(completionHandler: @escaping (DataSnapshot)->Void) -> DatabaseHandle {
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
                
                let dataToSet: [String: Any] = [
                "distance": totalDistance,
                "username": Auth.auth().currentUser!.email?.components(separatedBy: "@")[0] ?? Auth.auth().currentUser!.displayName!
            ]
            self.globalNodeDatabaseRef
                .child("\(FirebaseService.getCurrentUser().uid)")
                .setValue(dataToSet, andPriority: totalDistance)
        })
    }
    
}


extension FirebaseService {
    // MARK: - utility methods
    
    func removeObserver(handler: UInt?) {
        guard let handler = handler else { return }
        databaseRef.removeObserver(withHandle: handler)
    }
    
    static func getCurrentUser() -> User {
        return Auth.auth().currentUser!
    }
    
    func fetchActiveRunLikeStatus(completionHandler: @escaping (DataSnapshot)->Void) {
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
    
    static func enablePersistence(enabled: Bool) {
        Database.database().isPersistenceEnabled = enabled
    }
}
