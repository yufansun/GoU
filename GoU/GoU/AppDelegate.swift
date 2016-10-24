//
//  AppDelegate.swift
//  GoU
//
//  Created by SunYufan on 10/4/16.
//  Copyright © 2016 SunYufan. All rights reserved.
//

import UIKit
import Firebase

struct Trip {
    var from: String
    var to: String
    var date: String
    var seats: String
    init(from: String, to: String, date: String, seats: String) {
        self.from = from
        self.to = to
        self.date = date
        self.seats = seats
    }
    mutating func setNew(from: String, to: String, date: String, seats: String) {
        self.from = from
        self.to = to
        self.date = date
        self.seats = seats
    }
}

var trip = Trip(from: "Ann Arbor",to: "Chicago",date: "10/18/2016",seats: "3")


var trips = [Trip]()

struct Location {
    //TODO: make it a enum for location
    var countryName: String
    var stateName: String
    var cityName: String
    
    init(countryName: String, stateName: String, cityName: String) {
        self.countryName = countryName
        self.stateName = stateName
        self.cityName = cityName
    }
    mutating func setNew(countryName: String, stateName: String, cityName: String) {
        self.countryName = countryName
        self.stateName = stateName
        self.cityName = cityName
    }
}

struct ContactInformation {
    var emailAddress: String
    var phoneNumber: String
    
    init(emailAddress: String, phoneNumber: String) {
        self.emailAddress = emailAddress
        self.phoneNumber = phoneNumber
    }
    mutating func setNew(emailAddress: String, phoneNumber: String) {
        self.emailAddress = emailAddress
        self.phoneNumber = phoneNumber
    }
}


struct CommonProfile {
    var lastName: String
    var firstName: String
    var gender: String //TODO: make it a enum
    var birthDate: String
    var contactInfo: ContactInformation;
    var currentLocation: Location
    var homeLocation: Location
    var aboutMe: String
    var schoolName: String //TODO: make it a enum
    var majorField: [String] //TODO: make it a enum
    var languages: [String] //TODO: make it a enum
    //TODO: more habit information
    

    init(lastName: String, firstName: String, gender: String, birthDate: String, contactInfo: ContactInformation, currentLocation: Location, homeLocation: Location, aboutMe: String, schoolName: String, majorField: [String], languages: [String]) {
        self.lastName = lastName
        self.firstName = firstName
        self.gender = gender
        self.birthDate = birthDate
        self.contactInfo = contactInfo
        self.currentLocation = currentLocation
        self.homeLocation = homeLocation
        self.aboutMe = aboutMe
        self.schoolName = schoolName
        self.majorField = majorField
        self.languages = languages
    }
    mutating func setNew(lastName: String, firstName: String, gender: String, birthDate: String, contactInfo: ContactInformation, currentLocation: Location, homeLocation: Location, aboutMe: String, schoolName: String, majorField: [String], languages: [String]) {
        self.lastName = lastName
        self.firstName = firstName
        self.gender = gender
        self.birthDate = birthDate
        self.contactInfo = contactInfo
        self.currentLocation = currentLocation
        self.homeLocation = homeLocation
        self.aboutMe = aboutMe
        self.schoolName = schoolName
        self.majorField = majorField
        self.languages = languages
    }
}

//mock data 
var loc = Location(countryName: "US", stateName: "Michigan", cityName: "Ann Arbor")

var contactInfo = ContactInformation(emailAddress: "lchenhao@umich.edu", phoneNumber: "+1-734-780-9882")

var majors = ["CS", "EE"]

var lan = ["English", "Chinese"]


var sampleProfile = CommonProfile(lastName: "Li", firstName: "Chenhao", gender: "Male", birthDate: "02/21/1995", contactInfo: contactInfo, currentLocation: loc, homeLocation: loc, aboutMe: "GoU is the best", schoolName: "University of Michigan", majorField: majors, languages: lan)


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

