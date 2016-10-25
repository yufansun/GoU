//
//  ProfileViewController.swift
//  GoU
//
//  Created by SunYufan on 10/4/16.
//  Copyright © 2016 SunYufan. All rights reserved.
//

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var name = ""
        var uid = ""
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
    
    @IBAction func didTapSave(_ sender: AnyObject) {
        if (firstnameTextField.text! == "" || lastNameTextField.text! == "" ||
            phoneTextField.text! == "" || currentCountryTextField.text! == "" || currentStateTextField.text! == "" || currentCityTextField.text! == "") {
            showAlert()
        } else {

            let contactInfo = ContactInformation.init(emailAddress: "test.umich.edu", phoneNumber: phoneTextField.text!)
            let firstName = firstnameTextField.text!
            let lastName = lastNameTextField.text!
            
            let currentLocation = Location.init(countryName: currentCountryTextField.text! , stateName: currentStateTextField.text!, cityName: currentCityTextField.text!)
            CommonProfile.init(lastName: lastName, firstName: firstName, gender: "female", birthDate: "01/01/1995", contactInfo: contactInfo, currentLocation: currentLocation, homeLocation: currentLocation, aboutMe: "aboutMe", schoolName: "UMich", majorField: ["Computer Science"], languages: ["Chinese","English"])
            
            //TODO: update profile in database
            
            
            let alert = UIAlertController(title: "Thank You",
                                          message: "User information updated sucessfully", preferredStyle: .alert)
            let action = UIAlertAction(title: "Awesome", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Alert",
                                      message: "Please complete the information", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

