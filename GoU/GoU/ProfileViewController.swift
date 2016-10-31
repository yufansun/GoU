//
//  ProfileViewController.swift
//  GoU
//
//  Created by SunYufan on 10/4/16.
//  Copyright © 2016 SunYufan. All rights reserved.
//

import Photos
import UIKit

import Firebase

class ProfileViewController: UIViewController {
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var currentCountryTextField: UITextField!
    @IBOutlet weak var currentStateTextField: UITextField!
    @IBOutlet weak var currentCityTextField: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    // MARK: Properties
    var ref: FIRDatabaseReference!
    var messages: [FIRDataSnapshot]! = []
    var msglength: NSNumber = 10
    fileprivate var _refHandle: FIRDatabaseHandle!
    
    var storageRef: FIRStorageReference!
    var remoteConfig: FIRRemoteConfig!
    var uid: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureDatabase()
        configureStorage()
        configureRemoteConfig()
        fetchConfig()
        logViewLoaded()
        var name = ""
        if let user = FIRAuth.auth()?.currentUser {
            name = user.displayName!
            var email = user.email
            var photoUrl = user.photoURL
            uid = user.uid;  // The user's ID, unique to the Firebase project.
        } else {
            // No user is signed in.
        }
        usernameLabel.text = name
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            AppState.sharedInstance.signedIn = false
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
//    deinit {
//        self.ref.child("commonProfiles").removeObserver(withHandle: _refHandle)
//    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        //TODO: fetch user profile to local variable if already has profile
        // Listen for new messages in the Firebase database
        //        _refHandle = self.ref.child("messages").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
        //            guard let strongSelf = self else { return }
        //            strongSelf.messages.append(snapshot)
        //            strongSelf.clientTable.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
        //            })
    }
    
    func configureStorage() {
        storageRef = FIRStorage.storage().reference(forURL: "gs://gou-app-94faa.appspot.com")
    }
    
    func configureRemoteConfig() {
    }
    
    func fetchConfig() {
    }
    
    func logViewLoaded() {
    }
    
    func loadAd() {
    }
    
    @IBAction func didTapSave(_ sender: AnyObject) {
        if (firstnameTextField.text! == "" || lastNameTextField.text! == "" ||
            phoneTextField.text! == "" || currentCountryTextField.text! == "" || currentStateTextField.text! == "" || currentCityTextField.text! == "" || genderTextField.text! == "" || emailTextField.text! == "") {
            showAlert()
        } else {
            
            let contactInfo = ContactInformation.init(emailAddress: emailTextField.text!, phoneNumber: phoneTextField.text!)
            let firstName = firstnameTextField.text!
            let lastName = lastNameTextField.text!
            let gender = genderTextField.text!
            
            let currentLocation = Location.init(countryName: currentCountryTextField.text! , stateName: currentStateTextField.text!, cityName: currentCityTextField.text!)
            
            //            CommonProfile.init(userid: "test.umich.edu",lastName: lastName, firstName: firstName, gender: "female", birthDate: "01/01/1995", contactInfo: contactInfo, currentLocation: currentLocation, homeLocation: currentLocation, aboutMe: "aboutMe", schoolName: "UMich", majorField: ["Computer Science"], languages: ["Chinese","English"])
            
            //update profile in database
            var data = [Constants.CommonProfileFields.userId: uid]
            data[Constants.CommonProfileFields.currentCountryName] = currentLocation.countryName
            data[Constants.CommonProfileFields.currentStateName] = currentLocation.stateName
            data[Constants.CommonProfileFields.currentCityName] = currentLocation.cityName
            data[Constants.CommonProfileFields.firstName] = firstName
            data[Constants.CommonProfileFields.lastName] = lastName
            data[Constants.CommonProfileFields.gender] = gender
            data[Constants.CommonProfileFields.phoneNumber] = contactInfo.phoneNumber
            data[Constants.CommonProfileFields.emailAddress] = contactInfo.emailAddress
            data[Constants.CommonProfileFields.saved] = "TRUE"
            
            sendMessage(withData: data)
            
            
            
            let alert = UIAlertController(title: "Thank You",
                                          message: "User information updated sucessfully", preferredStyle: .alert)
            let action = UIAlertAction(title: "Awesome", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    func sendMessage(withData data: [String: String]) {
        var mdata = data
        // Push data to Firebase Database
        self.ref.child("commonProfiles").child(uid).setValue(mdata)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Alert",
                                      message: "Please complete the information", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

