//
//  ProfileViewController.swift
//  GoU
//
//  Created by SunYufan and Chenhao Li on 10/4/16.
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
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var languageFirstTextField: UITextField!
    
    @IBOutlet weak var aboutMeTextField: UITextView!
    @IBOutlet weak var languageSecondTextField: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
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
        // make the view scrollable
        scrollView = UIScrollView(frame: view.bounds)
        //var cellViewFrame: UIView?
        //cellViewFrame = UIView(frame: CGRect( x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height + 120))
        //scrollView.contentSize = (cellViewFrame?.bounds.size)!
        
        // Do any additional setup after loading the view, typically from a nib.
        configureDatabase()
        configureStorage()
        configureRemoteConfig()
        fetchConfig()
        logViewLoaded()
        var name = ""
        var email = ""
        if let user = FIRAuth.auth()?.currentUser {
            name = user.displayName!
            email = user.email!
            var photoUrl = user.photoURL
            uid = user.uid;  // The user's ID, unique to the Firebase project.
        } else {
            // No user is signed in.
        }
        usernameLabel.text = name
        emailTextField.text = email
        
        ref.child("commonProfiles").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let saved = value?["saved"] as! String
            if (saved == "TRUE") {
                self.firstnameTextField.text = value?["firstName"] as! String
                self.lastNameTextField.text = value?["lastName"] as! String
                self.genderTextField.text = value?["gender"] as! String
                self.emailTextField.text = value?["emailAddress"] as! String
                self.phoneTextField.text = value?["phoneNumber"] as! String
                self.currentCountryTextField.text = value?["currentCountryName"] as! String
                self.currentStateTextField.text = value?["currentStateName"] as! String
                self.currentCityTextField.text = value?["currentCityName"] as! String
                self.majorTextField.text = value?["majorField"] as! String
                self.aboutMeTextField.text = value?["aboutMe"] as! String
                let phoneNumber = value?["phoneNumber"] as! String
                print("&&&&&&&&")
                print(phoneNumber)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
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
    
    
    @IBAction func didTapSave(_ sender: AnyObject) {
        if (firstnameTextField.text! == "" || lastNameTextField.text! == "" ||
            phoneTextField.text! == "" || currentCountryTextField.text! == "" || currentStateTextField.text! == "" || currentCityTextField.text! == "" || genderTextField.text! == "" || emailTextField.text! == "") {
            showAlert()
        } else {
            
            let contactInfo = ContactInformation.init(emailAddress: emailTextField.text!, phoneNumber: phoneTextField.text!)
            let firstName = firstnameTextField.text!
            let lastName = lastNameTextField.text!
            let gender = genderTextField.text!
            let major = majorTextField.text!
            let aboutMe = aboutMeTextField.text!
            
            let currentLocation = Location.init(countryName: currentCountryTextField.text! , stateName: currentStateTextField.text!, cityName: currentCityTextField.text!)
            
            var postList = ""
            var requestList = ""
            ref.child("commonProfiles").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                postList = value?[Constants.CommonProfileFields.myPostsList] as! String
                requestList = value?[Constants.CommonProfileFields.myRequestsList] as! String
                //update profile in database
                var data = [Constants.CommonProfileFields.userId: self.uid]
                data[Constants.CommonProfileFields.currentCountryName] = currentLocation.countryName
                data[Constants.CommonProfileFields.currentStateName] = currentLocation.stateName
                data[Constants.CommonProfileFields.currentCityName] = currentLocation.cityName
                data[Constants.CommonProfileFields.firstName] = firstName
                data[Constants.CommonProfileFields.lastName] = lastName
                data[Constants.CommonProfileFields.gender] = gender
                data[Constants.CommonProfileFields.phoneNumber] = contactInfo.phoneNumber
                data[Constants.CommonProfileFields.majorField] = major
                data[Constants.CommonProfileFields.aboutMe] = aboutMe
                data[Constants.CommonProfileFields.emailAddress] = contactInfo.emailAddress
                data[Constants.CommonProfileFields.saved] = "TRUE"
                data[Constants.CommonProfileFields.myPostsList] = postList
                data[Constants.CommonProfileFields.myRequestsList] = requestList
                data[Constants.CommonProfileFields.isDriver] = "FALSE"//TODO: JUST FOR NOW
                
                self.sendMessage(withData: data)
            }) { (error) in
                print(error.localizedDescription)
            }
            
            
            
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

