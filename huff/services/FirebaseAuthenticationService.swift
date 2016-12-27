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
}
