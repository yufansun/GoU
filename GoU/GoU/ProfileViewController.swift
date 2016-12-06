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

class ProfileViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var currentCountryTextField: UITextField!
    @IBOutlet weak var currentStateTextField: UITextField!
    @IBOutlet weak var currentCityTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    
    
    @IBOutlet weak var aboutMeTextField: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var genderPicker: UIPickerView!
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var profilePhotoButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var vehicleInfoView: UIView!
    @IBOutlet weak var isDriverSwitch: UISwitch!
    @IBOutlet weak var vehicleModelTextField: UITextField!
    @IBOutlet weak var vehicleYearTextField: UITextField!
    // MARK: Properties
    var ref: FIRDatabaseReference!
    var messages: [FIRDataSnapshot]! = []
    var msglength: NSNumber = 10
    fileprivate var _refHandle: FIRDatabaseHandle!
    
    var storageRef: FIRStorageReference!
    var remoteConfig: FIRRemoteConfig!
    var uid: String = ""
    
    var genderOptions = ["Female", "Male", "Other"]
    
    var isDriver = "FALSE"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide keyboard
        self.hideKeyboardWhenTappedAround()
        
        // make the view scrollable
        scrollView = UIScrollView(frame: view.bounds)

        configureDatabase()
        configureStorage()
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
        
        self.setVehicleView(isHide: "TRUE")
        
        profilePhotoButton.window?.windowLevel = CGFloat.greatestFiniteMagnitude
        ref.child("commonProfiles").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let saved = value?["saved"] as! String
            if (saved == "TRUE") {
                self.firstnameTextField.text = value?["firstName"] as? String
                self.lastNameTextField.text = value?["lastName"] as? String
                self.genderTextField.text = value?["gender"] as? String
                self.emailTextField.text = value?["emailAddress"] as? String
                self.phoneTextField.text = value?["phoneNumber"] as? String
                self.currentCountryTextField.text = value?["currentCountryName"] as? String
                self.currentStateTextField.text = value?["currentStateName"] as! String
                self.currentCityTextField.text = value?["currentCityName"] as! String
                self.majorTextField.text = value?["majorField"] as! String
                self.aboutMeTextField.text = value?["aboutMe"] as! String
                let phoneNumber = value?["phoneNumber"] as! String
                
                self.isDriver = value?["isDriver"] as! String
                if (self.isDriver == "TRUE") {
                    self.isDriverSwitch.setOn(true, animated: true)
                    self.setVehicleView(isHide: "False")
                    self.vehicleModelTextField.text = value?["vehicleModel"] as? String
                    self.vehicleYearTextField.text = value?["vehicleYear"] as? String
                } else {
                    self.isDriverSwitch.setOn(false, animated: true)
                    self.setVehicleView(isHide: "TRUE")
                }
                
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        updateProfilePhotoView()
        
        //picker
        var genderPickerView = UIPickerView()
        
        genderPickerView.delegate = self
        
        genderTextField.inputView = genderPickerView
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
    }
    
    func configureStorage() {
        storageRef = FIRStorage.storage().reference(forURL: "gs://gou-app-94faa.appspot.com")
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
                data[Constants.CommonProfileFields.isDriver] = self.isDriver
                
                if (self.isDriver == "TRUE") {
                    data[Constants.DriverProfileFields.vehicleModel] = self.vehicleModelTextField.text!
                    data[Constants.DriverProfileFields.vehicleYear] = self.vehicleYearTextField.text!
                }
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
    
    @IBAction func didTapEditProfilePhoto(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            picker.sourceType = UIImagePickerControllerSourceType.camera
        } else {
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        present(picker, animated: true, completion:nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion:nil)
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        
        // if it's a photo from the library, not an image from the camera
        if #available(iOS 8.0, *), let referenceURL = info[UIImagePickerControllerReferenceURL] {
            let assets = PHAsset.fetchAssets(withALAssetURLs: [referenceURL as! URL], options: nil)
            let asset = assets.firstObject
            asset?.requestContentEditingInput(with: nil, completionHandler: { [weak self] (contentEditingInput, info) in
                let imageFile = contentEditingInput?.fullSizeImageURL
                let filePath = "\(uid)/\(Int(Date.timeIntervalSinceReferenceDate * 1000))/\((referenceURL as AnyObject).lastPathComponent!)"
                guard let strongSelf = self else { return }
                strongSelf.storageRef.child(filePath)
                    .putFile(imageFile!, metadata: nil) { (metadata, error) in
                        if let error = error {
                            let nsError = error as NSError
                            print("Error uploading: \(nsError.localizedDescription)")
                            return
                        }
                        var data = [Constants.CommonProfileFields.userId: self?.uid]
                        data[Constants.CommonProfileFields.hasProfilePhoto] = "TRUE"
                        data[Constants.CommonProfileFields.profilePhotoURL] = strongSelf.storageRef.child((metadata?.path)!).description
                        strongSelf.updateProfilePhoto(withData: data as! [String : String])
                }
            })
        } else {
            guard let image = info[UIImagePickerControllerOriginalImage] as! UIImage? else { return }
            let imageData = UIImageJPEGRepresentation(image, 0.8)
            let imagePath = "\(uid)/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            self.storageRef.child(imagePath)
                .put(imageData!, metadata: metadata) { [weak self] (metadata, error) in
                    if let error = error {
                        print("Error uploading: \(error)")
                        return
                    }
                    guard let strongSelf = self else { return }
                    var data = [Constants.CommonProfileFields.userId: self?.uid]
                    data[Constants.CommonProfileFields.hasProfilePhoto] = "TRUE"
                    data[Constants.CommonProfileFields.profilePhotoURL] = strongSelf.storageRef.child((metadata?.path)!).description
                    strongSelf.updateProfilePhoto(withData: data as! [String : String])
            }
        }
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
        updateProfilePhotoView()
    }
    
    func updateProfilePhotoView() {
        ref.child("commonProfiles").child("profilePhoto").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let hasProfilePhoto = value?["hasProfilePhoto"] as! String
            if (hasProfilePhoto == "TRUE") {
                let imageURL = value?[Constants.CommonProfileFields.profilePhotoURL]
                //if let imageURL = value?[Constants.CommonProfileFields.profilePhotoURL] {
                if (imageURL as AnyObject).hasPrefix("gs://") {
                    FIRStorage.storage().reference(forURL: imageURL as! String).data(withMaxSize: INT64_MAX){ (data, error) in
                        if let error = error {
                            print("Error downloading: \(error)")
                            return
                        }
                        self.profilePhoto?.image = UIImage.init(data: data!)
                    }
                } else if let URL = URL(string: imageURL as! String), let data = try? Data(contentsOf: URL) {
                    self.profilePhoto?.image = UIImage.init(data: data)
                }
            }
            else {
                self.profilePhoto?.image = UIImage(named: "ic_account_circle")
            }
            
            // }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Alert",
                                      message: "Please complete the information", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: picker
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return genderOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = genderOptions[row]
    }
    
    //MARK: Vehicle info
    @IBAction func didTapIsDriverSwitch(_ sender: Any) {
        if (self.isDriver == "TRUE") {
            self.isDriver = "FALSE"
            self.isDriverSwitch.setOn(false, animated: true)
            self.setVehicleView(isHide: "TRUE")
        } else {
            self.isDriver = "TRUE"
            self.isDriverSwitch.setOn(true, animated: true)
            self.setVehicleView(isHide: "FALSE")
        }
    }
    
    func setVehicleView (isHide: String) {
        if (isHide == "TRUE") {
            self.vehicleInfoView.isHidden = true
            self.saveButton.frame = CGRect.init(x: 190.0, y: 750.0, width: 160.0, height: 40.0)
        } else {
            self.vehicleInfoView.isHidden = false
            self.saveButton.frame = CGRect.init(x: 190.0, y: 900.0, width: 160.0, height: 40.0)
        }
    }
    
    
    
}

