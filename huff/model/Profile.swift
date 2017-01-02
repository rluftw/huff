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
    var photo: UIImage?
    var displayName: String?
    var accountStatus: Bool?
    var accountCreationDate: TimeInterval?
    var uid: String?
    var email: String?
    var status: String?
    var favoriteActiveRuns = [ActiveRun]()
    
    init(user: FIRUser, photo: UIImage?, status: String?, dateJoined: TimeInterval?) {
        self.photo = photo
        displayName = user.displayName ?? user.email?.components(separatedBy: "@")[0] ?? user.uid
        accountStatus = user.isEmailVerified
        uid = user.uid
        email = user.email
     
        self.status = status
        accountCreationDate = dateJoined
    }
}
