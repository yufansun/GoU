//
//  AppDelegate.swift
//  GoU
//
//  Created by SunYufan  and Chenhao Li on 10/4/16.
//  Copyright © 2016 SunYufan. All rights reserved.
//

import UIKit
import Firebase
import Foundation

struct Trip {
    var from: String //TO DO: Make it a location
    var to: String
    var date: String //TO DO: Make it a date
    var seats: String
    var ownerID: String
    var tripID: String
    var notes: String
    var price: String
    var pickUp: String
    var riderID: String

    
    init() {
        self.from = ""
        self.to = ""
        self.date = ""
        self.seats = ""
        self.ownerID = ""
        self.tripID = ""
        self.notes = ""
        self.pickUp = ""
        self.price = ""
        self.riderID = ""
    }
    
    init(from: String, to: String, date: String, seats: String, ownerID: String, tripID: String,notes: String, price: String, pickUp: String, riderID: String) {
        self.from = from
        self.to = to
        self.date = date
        self.seats = seats
        self.ownerID = ownerID
        self.tripID = tripID
        self.notes = notes
        self.pickUp = pickUp
        self.price = price
        self.riderID = riderID
    }
    mutating func setNew(from: String, to: String, date: String, seats: String, ownerID: String, tripID: String,notes: String, price: String, pickUp: String, riderID: String) {
        self.from = from
        self.to = to
        self.date = date
        self.seats = seats
        self.ownerID = ownerID
        self.tripID = tripID
        self.notes = notes
        self.pickUp = pickUp
        self.price = price
        self.riderID = riderID
    }
}

//var trip = Trip(from: "Your location",to: "Destination",date: "00/00/0000",seats: "0", ownerID: "", tripID: "",notes: "", price: "", pickUp: "", riderID: "")
//
//var tripViewing = Trip(from: "Ann Arbor",to: "Chicago",date: "10/18/2016",seats: "3", ownerID: "", tripID: "",notes: "", price: "", pickUp: "", riderID: "")
//
//var currentProfile = [:] as NSDictionary

var viewingCondition = 0
//0 : view trip detail from posts
//1 : view trip detail from myTrips->posts
//2 : view trip detail from myTrips->requests

var myTripsBadgeCount = 0


//var trips = [Trip]()
//var myTrips = [Trip]()
//var myRequests = [Trip]()
//var requesterArr = [String]()
//var requesters = [DriverViewProfile]()


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
    
    func getEmail() -> String {
        return self.emailAddress
    }
    
    init(emailAddress: String, phoneNumber: String) {
        self.emailAddress = emailAddress
        self.phoneNumber = phoneNumber
    }
    mutating func setNew(emailAddress: String, phoneNumber: String) {
        self.emailAddress = emailAddress
        self.phoneNumber = phoneNumber
    }
}

struct DriverProfile {
    var licenseNumber: String
    var drivingYears: String
    var vehicleInfo: VehicleInformation
    
    init(licenseNumber: String, drivingYears: String, vehicleInfo: VehicleInformation) {
        self.licenseNumber = licenseNumber
        self.drivingYears = drivingYears
        self.vehicleInfo = vehicleInfo
    }
    mutating func setNew(licenseNumber: String, drivingYears: String, vehicleInfo: VehicleInformation) {
        self.licenseNumber = licenseNumber
        self.drivingYears = drivingYears
        self.vehicleInfo = vehicleInfo
    }
}


struct VehicleInformation {
    var make: String
    var year: String
    //var photo
    init(make: String, year: String) {
        self.make = make
        self.year = year
    }
    
    mutating func setNew(make: String, year: String) {
        self.make = make
        self.year = year
    }
}

struct DriverViewProfile {
    var name: String //TO DO: Make it a location
    var gender: String
    var loc: String //TO DO: Make it a date
    var email: String
    var phone: String
    var aboutme: String
    var userID: String
    
    init() {
        self.name = ""
        self.gender = ""
        self.loc = ""
        self.email = ""
        self.phone = ""
        self.aboutme = ""
        self.userID = ""
    }
    
    init(name: String, gender: String, loc: String, email: String, phone: String, aboutme: String, userID: String) {
        self.name = name
        self.gender = gender
        self.loc = loc
        self.email = email
        self.phone = phone
        self.aboutme = aboutme
        self.userID = userID
    }
    mutating func setNew(name: String, gender: String, loc: String, email: String, phone: String, aboutme: String, userID: String) {
        self.name = name
        self.gender = gender
        self.loc = loc
        self.email = email
        self.phone = phone
        self.aboutme = aboutme
        self.userID = userID
        
    }
}

var driverInfo =  DriverViewProfile(name: "", gender: "", loc: "", email: "", phone: "", aboutme: "", userID: "")
var myPostList = ""

struct CommonProfile {
    var userId: String
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
    var driverPro: DriverProfile?
    var isDriver: String
    var myPostsList: String?
    var myRequestsList: String?
    //TODO: more habit information
    // TODO: add experience, trip (list of index)
    
    init(userid: String, lastName: String, firstName: String, gender: String, birthDate: String, contactInfo: ContactInformation, currentLocation: Location, homeLocation: Location, aboutMe: String, schoolName: String, majorField: [String], languages: [String], isDriver: String) {
        self.userId = userid
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
        self.isDriver = isDriver
    }
    
    mutating func setNew(userid: String, lastName: String, firstName: String, gender: String, birthDate: String, contactInfo: ContactInformation, currentLocation: Location, homeLocation: Location, aboutMe: String, schoolName: String, majorField: [String], languages: [String], isDriver: String) {
        self.userId = userid
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
        self.isDriver = isDriver
    }
    
    mutating func setDriverProfile(driverPro: DriverProfile) {
        self.driverPro = driverPro
    }
}

//mock data
var loc = Location(countryName: "US", stateName: "Michigan", cityName: "Ann Arbor")

var contactInfo = ContactInformation(emailAddress: "lchenhao@umich.edu", phoneNumber: "+1-734-780-9882")

var majors = ["CS", "EE"]

var lan = ["English", "Chinese"]


var sampleProfile = CommonProfile(userid: "lchenhao@umich.edu", lastName: "Li", firstName: "Chenhao", gender: "Male", birthDate: "02/21/1995", contactInfo: contactInfo, currentLocation: loc, homeLocation: loc, aboutMe: "GoU is the best", schoolName: "University of Michigan", majorField: majors, languages: lan, isDriver: "FALSE")


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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

