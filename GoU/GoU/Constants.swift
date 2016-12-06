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
    
    
    struct CommonProfileFields {
        static let userId = "userId"
        static let lastName = "lastName"
        static let firstName = "firstName"
        static let gender = "gender"
        static let birthDate = "birthDate"
        static let contactInfo = "contactInfo"
        static let currentLocation = "currentLocation"
        static let homeLocation = "homeLocation"
        static let aboutMe = "aboutMe"
        static let schoolName = "schoolName"
        static let majorField = "majorField"
        static let languages = "languages"
        static let emailAddress = "emailAddress"
        static let phoneNumber = "phoneNumber"
        static let currentCountryName = "currentCountryName"
        static let currentStateName = "currentStateName"
        static let currentCityName = "currentCityName"
        static let homeCountryName = "homeCountryName"
        static let homeStateName = "homeStateName"
        static let homeCityName = "homeCityName"
        static let saved = "saved"
        static let isDriver = "isDriver"
        static let myPostsList =  "myPostsList"
        static let myRequestsList = "myRequestsList"
        static let hasProfilePhoto = "hasProfilePhoto"
        static let profilePhotoURL = "profilePhotoURL"
    }
    
    struct DriverProfileFields {
        static let vehicleModel = "vehicleModel"
        static let vehicleYear = "vehicleYear"
    }
    
    struct MessageFields {
        static let name = "name"
        static let text = "text"
        static let photoURL = "photoURL"
        static let imageURL = "imageURL"
    }
    
    struct PostsFields {
        
    }
}
