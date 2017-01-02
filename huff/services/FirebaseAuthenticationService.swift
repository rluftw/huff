//
//  FirebaseAuthenticationService.swift
//  huff
//
//  Created by Xing Hui Lu on 12/26/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import Foundation
import Firebase

extension FirebaseService {
    // MARK: - user authentication
    
    func createAccount(email: String, password: String, completionHandler: @escaping (FIRUser?, Error?)->Void) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: completionHandler)
    }
    
    func setupUser(userDict: [String: Any]) {
        userNodeDatabaseRef.setValue(userDict)
    }
    
    func signInWithSocialNetwork(credentials: FIRAuthCredential, completionHandler: @escaping (FIRUser?, Error?)->Void) {
        FIRAuth.auth()?.signIn(with: credentials, completion: completionHandler)
    }
    
    func signInWithEmail(email: String, password: String, completionHandler: @escaping (FIRUser?, Error?)->Void) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: completionHandler)
    }

    func deleteAccount(completion: @escaping (Error?)->Void) {
        FirebaseService.getCurrentUser().delete { (error) in
            completion(error)
        }
    }

    func logout(completion: @escaping (Error?)->Void) {
        do {
            try FIRAuth.auth()?.signOut()
            completion(nil)
        } catch let error {
            print("there was an error signing this user out: \(error.localizedDescription)")
            completion(error)
        }
    }
}
