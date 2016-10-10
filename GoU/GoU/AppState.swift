//
//  AppState.swift
//  GoU
//
//  Created by SunYufan on 10/9/16.
//  Copyright © 2016 SunYufan. All rights reserved.
//

import Foundation

class AppState: NSObject {
    
    static let sharedInstance = AppState()
    
    var signedIn = false
    var displayName: String?
    var photoURL: URL?
}

