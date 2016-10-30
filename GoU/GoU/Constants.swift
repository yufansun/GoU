//
//  Constants.swift
//  GoU
//
//  Created by LiChenhao on 10/29/16.
//  Copyright © 2016 SunYufan. All rights reserved.
//

import Foundation
struct Constants {
    
    struct NotificationKeys {
        static let SignedIn = "onSignInCompleted"
    }
    
    struct Segues {
        static let SignInToFp = "SignInToFP"
        static let FpToSignIn = "FPToSignIn"
    }
    
    struct CommonProfileFields {
        static let userId = "userId"
        static let lastName = "lastName"
        static let firstName = "firstName"
        static let gender = "genger"
        static let birthDate = "birthDate"
        static let contactInfo = "contactInfo"
        static let currentLocation = "currentLocation"
        static let homeLocation = "homeLocation"
        static let aboutMe = "aboutMe"
        static let schoolName = "schoolName"
        static let majorField = "majorField"
        static let languages = "languages"
    }
    
    struct MessageFields {
        static let name = "name"
        static let text = "text"
        static let photoURL = "photoURL"
        static let imageURL = "imageURL"
    }
}
