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
    
    init(user: FIRUser, photo: UIImage?, status: String?, dateJoined: TimeInterval?) {
        self.photo = photo
        self.displayName = user.displayName ?? user.email?.components(separatedBy: "@")[0] ?? user.uid
        self.accountStatus = user.isEmailVerified
        self.uid = user.uid
        self.email = user.email
     
        self.status = status
        self.accountCreationDate = dateJoined
    }
}
