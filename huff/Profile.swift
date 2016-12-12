//
//  Profile.swift
//  huff
//
//  Created by Xing Hui Lu on 12/11/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import Foundation
import Firebase

class Profile {
    var photoURL: URL?
    var displayName: String?
    var accountStatus: Bool!
    var accountCreationDate: TimeInterval?
    var uid: String!
    var email: String?
    
    init(user: FIRUser) {
        photoURL = user.photoURL
        displayName = user.displayName ?? user.email?.components(separatedBy: "@")[0] ?? user.uid
        accountStatus = user.isEmailVerified
        uid = user.uid
        email = user.email
    }
}
