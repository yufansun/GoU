//
//  SignInViewController.swift
//  GoU
//
//  Created by SunYufan on 10/9/16.
//  Copyright © 2016 SunYufan. All rights reserved.
//

import UIKit

import Firebase

@objc(SignInViewController)
class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var ref: FIRDatabaseReference!
    var messages: [FIRDataSnapshot]! = []
    var msglength: NSNumber = 10
    fileprivate var _refHandle: FIRDatabaseHandle!
    
    var storageRef: FIRStorageReference!
    var remoteConfig: FIRRemoteConfig!
    var uid: String = ""
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = FIRAuth.auth()?.currentUser {
            self.signedIn(user)
        }
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func didTapSignIn(_ sender: AnyObject) {
        print(emailField.text)
        print(passwordField.text)
        // Sign In with credentials.
        
        guard let email = emailField.text, let password = passwordField.text else { return }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.showAlert(message: error.localizedDescription)
                
                print(error.localizedDescription)
                return
            }
            self.signedIn(user!)
            // no email verification in this release
//            if (!(FIRAuth.auth()?.currentUser?.isEmailVerified)!) {
//                self.showAlert(message: "Verify your email first!")
//                do {
//                    try FIRAuth.auth()?.signOut()
//                    AppState.sharedInstance.signedIn = false
//                } catch let signOutError as NSError {
//                    print ("Error signing out: \(signOutError.localizedDescription)")
//                }
//            }
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        // let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailRegEx = "[A-Z0-9a-z._%+-]+@umich.edu"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func didTapSignUp(_ sender: AnyObject) {
        guard let email = emailField.text, let password = passwordField.text else { return }
        
        // don't limit to umich students in this release
        // check the email ends with umich.edu
//        if(!isValidEmail(testStr: emailField.text!)) {
//            self.showAlert(message: "Please use your umich email address")
//            return
//        }
        
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.showAlert(message: error.localizedDescription)
                print(error.localizedDescription)
                return
            }
            
            
            // no email verification in this release
//            //send email verification
//            self.sendEmailVerification(withCompletionCallback: { (error) in
//                if error != nil{
//                    print(error!)
//                }
//                else{
//                    //verification email sent
//                    self.showAlert(message: "We just sent a verification email to you. Please go and verify!")
//                }
//            })
//            
//            
//            let prompt = UIAlertController.init(title: nil, message: "We just sent a verification email to you. Please go and verify!", preferredStyle: .alert)
//            let okAction = UIAlertAction.init(title: "I have verified", style: .default) { (action) in
//                print (FIRAuth.auth()?.currentUser?.isEmailVerified)
            
                self.setDisplayName(user!)
                
                //create initial profile
                self.uid = user!.uid
                self.configureDatabase()
                self.configureStorage()
                var data = [Constants.CommonProfileFields.userId: user!.uid]
                data[Constants.CommonProfileFields.saved] = "FALSE"
                data[Constants.CommonProfileFields.myPostsList] = ""
                data[Constants.CommonProfileFields.myRequestsList] = ""
                self.sendMessage(withData: data)
                
                var dataPhoto = [Constants.CommonProfileFields.userId: user!.uid]
                dataPhoto[Constants.CommonProfileFields.hasProfilePhoto] = "FALSE"
                self.updateProfilePhoto(withData: dataPhoto)
                
//                if (FIRAuth.auth()?.currentUser?.isEmailVerified)! {
//                    // verified
//                } else {
//                    self.showAlert(message: "Ooops, seem that you didn't verify")
//                    do {
//                        try FIRAuth.auth()?.signOut()
//                        AppState.sharedInstance.signedIn = false
//                    } catch let signOutError as NSError {
//                        print ("Error signing out: \(signOutError.localizedDescription)")
//                    }
//                    
//                }
//                
//            }
//            prompt.addAction(okAction)
//            self.present(prompt, animated: true, completion: nil);
            
            
            
        }
    }
    
    func sendEmailVerification(withCompletionCallback callback: @escaping FIRSendEmailVerificationCallback){
        FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: callback)
    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
    }
    
    func configureStorage() {
        storageRef = FIRStorage.storage().reference(forURL: "gs://gou-app-94faa.appspot.com")
    }
    
    func sendMessage(withData data: [String: String]) {
        var mdata = data
        // Push data to Firebase Database
        self.ref.child("commonProfiles").child(uid).setValue(mdata)
    }
    
    func updateProfilePhoto(withData data: [String: String]) {
        var mdata = data
        // Push data to Firebase Database
        self.ref.child("commonProfiles").child("profilePhoto").child(uid).setValue(mdata)
    }
    
    func setDisplayName(_ user: FIRUser) {
        let changeRequest = user.profileChangeRequest()
        changeRequest.displayName = user.email!.components(separatedBy: "@")[0]
        changeRequest.commitChanges(){ (error) in
            if let error = error {
                self.showAlert(message: error.localizedDescription)
                print(error.localizedDescription)
                return
            }
            self.signedIn(FIRAuth.auth()?.currentUser)
        }
    }
    
    @IBAction func didRequestPasswordReset(_ sender: AnyObject) {
        let prompt = UIAlertController.init(title: nil, message: "Email:", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty) {
                return
            }
            FIRAuth.auth()?.sendPasswordReset(withEmail: userInput!) { (error) in
                if let error = error {
                    self.showAlert(message: error.localizedDescription)
                    print(error.localizedDescription)
                    return
                }
            }
        }
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(okAction)
        present(prompt, animated: true, completion: nil);
    }
    
    func signedIn(_ user: FIRUser?) {
        MeasurementHelper.sendLoginEvent()
        
        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
        AppState.sharedInstance.photoURL = user?.photoURL
        AppState.sharedInstance.signedIn = true
        let notificationName = Notification.Name(rawValue: "onSignInCompleted")
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: nil)
        performSegue(withIdentifier: "SignInToGU", sender: nil)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
