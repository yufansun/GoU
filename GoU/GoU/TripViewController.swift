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
    
    @IBOutlet weak var negotiateLabel: UILabel!
    
    @IBOutlet weak var ifPickup: UISwitch!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    var ref: FIRDatabaseReference!
    var rootRef: FIRDatabaseReference!
    var posts: [FIRDataSnapshot]! = []
    var msglength: NSNumber = 10
    fileprivate var _refHandle: FIRDatabaseHandle!
    
    var storageRef: FIRStorageReference!
    var remoteConfig: FIRRemoteConfig!
    
    var ifPickUpFlag: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView(frame: view.bounds)
        
        // hide keyboard
        self.hideKeyboardWhenTappedAround()
        
        self.ref = FIRDatabase.database().reference(withPath: "messages")
        // Do any additional setup after loading the view, typically from a nib.
        
        self.ifPickup.setOn(false, animated: true)
        ifPickUpFlag = false
        self.pickTextField.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func tapIfPickUp(_ sender: AnyObject) {
        if (ifPickUpFlag == true){
            ifPickUpFlag = false
            self.ifPickup.setOn(false, animated: true)
            self.pickTextField.isHidden = true
            self.negotiateLabel.isHidden = false
            self.pickTextField.text = ""
        } else{
            ifPickUpFlag = true
            self.ifPickup.setOn(true, animated: true)
            self.pickTextField.isHidden = false
            self.negotiateLabel.isHidden = true
            self.pickTextField.text = ""
        }
    }
    
    
    @IBAction func submitTrip(_ sender: UIButton) {
        let userID = (FIRAuth.auth()?.currentUser?.uid)! as String
        
        if(!pickTextField.isHidden && self.pickTextField.text == "")
        {
            showAlert()
        }
        
        if ((fromTextField.text?.isEmpty)! || (toTextField.text?.isEmpty)! ||
            (dateTextField.text?.isEmpty)! || (seatsTextField.text?.isEmpty)! ||
            (notesTextField.text?.isEmpty)!)
        {
            showAlert()
        }
        else
        {
            if (pickTextField.isHidden)
            {
                pickTextField.text = "Negotiate with rider"
            }
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
            let action = UIAlertAction(title: "Awesome", style: .default, handler: {(alert: UIAlertAction!) in self.showNextView()})
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
    
    func showNextView()
    {
        //let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MyTripsTableViewController") as! MyTripsTableViewController
        //self.present(next, animated: true, completion: nil)
        //self.navigationController?.pushViewController(nextVC, animated: true)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
