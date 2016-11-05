//
//  driverViewController.swift
//  GoU
//
//  Created by SunYufan on 10/5/16.
//  Copyright © 2016 SunYufan. All rights reserved.
//

import UIKit
import Firebase

class TripViewController: UIViewController {
    //MARK: properties
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var seatsTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var pickTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    var ref: FIRDatabaseReference!
    var rootRef: FIRDatabaseReference!
    var posts: [FIRDataSnapshot]! = []
    var msglength: NSNumber = 10
    fileprivate var _refHandle: FIRDatabaseHandle!
    
    var storageRef: FIRStorageReference!
    var remoteConfig: FIRRemoteConfig!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = FIRDatabase.database().reference(withPath: "messages")
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func submitTrip(_ sender: UIButton) {
        let userID = (FIRAuth.auth()?.currentUser?.uid)! as String
        
    
        
        if ((fromTextField.text?.isEmpty)! || (toTextField.text?.isEmpty)! ||
            (dateTextField.text?.isEmpty)! || (seatsTextField.text?.isEmpty)! ||
            (notesTextField.text?.isEmpty)!)
        {
            showAlert()
        }
            
        else
        {
            let postKey = ref.child("posts").childByAutoId().key as String
            self.ref.child("posts").child(postKey).setValue(["from": fromTextField.text!,
                                                             "to": toTextField.text!,
                                                             "date": dateTextField.text!,
                                                             "seats": seatsTextField.text!,
                                                             "notes": notesTextField.text!,
                                                             "price": priceTextField.text!,
                                                             "pickUp": pickTextField.text!,
                                                             "ownerID": userID,
                                                             "requestList": "",
                                                             "riderID": ""
                ])
            
            self.ref.child("posts").observe(.childAdded, with: { (snapshot) in
                let key  = snapshot.key as String
                let value = snapshot.value as? NSDictionary
                debugPrint("hello")
                debugPrint(key)
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
            //chenhao's code
            //Note: I use the postKey here!!!
            self.rootRef = FIRDatabase.database().reference()
            
            var postList = ""
            let userID = FIRAuth.auth()?.currentUser?.uid
            rootRef.child("commonProfiles").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                postList = value?[Constants.CommonProfileFields.myPostsList] as! String
                print("in database postlist is " + postList)
                postList = postList + postKey + ","
                print("after postlist is " + postList)
                var path = "commonProfiles/" + userID! + "/myPostsList"
                self.rootRef.child(path).setValue(postList)
            }) { (error) in
                print(error.localizedDescription)
            }
            //end
            
            let alert = UIAlertController(title: "Thank You",
                                          message: "Create sucessfully", preferredStyle: .alert)
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
