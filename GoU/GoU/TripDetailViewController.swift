//
//  tripDetailViewController.swift
//  GoU
//
//  Created by hjq on 10/31/16.
//  Copyright © 2016 SunYufan. All rights reserved.
//

// TODO: dynamic button go to rider's profile

import UIKit
import Firebase

class TripDetailViewController: UIViewController {
    
    
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var matchTripButton: UIButton!
    @IBOutlet weak var viewDriverProfileButton: UIButton!
    @IBOutlet weak var viewRequestersButton: UIButton!
    
    var userRef: FIRDatabaseReference!
    var ref: FIRDatabaseReference!
    var driverProfile = DriverViewProfile()
    var myTrip = Trip()
    var viewingCondition: Int!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsDisplay()
        
        viewDriverProfileButton.isHidden = true
        viewRequestersButton.isHidden = true
        matchTripButton.isHidden = true
        
        
        self.userRef = FIRDatabase.database().reference(withPath: "commonProfiles")
        
        self.userRef.child(self.myTrip.ownerID).observe(.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let firstName = value!["firstName"]! as! String
            let lastName = value!["lastName"]! as! String
            self.driverProfile.gender = value!["gender"]! as! String
            let city = value!["currentCityName"]! as! String
            let state = value!["currentStateName"]! as! String
            let country = value!["currentCountryName"]! as! String
            self.driverProfile.email = value!["emailAddress"]! as! String
            self.driverProfile.phone = value!["phoneNumber"]! as! String
            self.driverProfile.aboutme = value!["aboutMe"]! as! String
            
            self.driverProfile.name = firstName + " " + lastName
            self.driverProfile.loc = city + ", " + state + ", " + country
            self.driverProfile.userID = self.myTrip.ownerID
            print("a")
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.ref = FIRDatabase.database().reference(withPath: "messages")
        
        if(self.viewingCondition == 0){
            viewDriverProfileButton.isHidden = false
            matchTripButton.isHidden = false
            
            showInfo()
        }
        
        if(self.viewingCondition == 1){
            //view from myTrips->post
            viewRequestersButton.isHidden = false
            if (self.myTrip.riderID != ""){
            
                viewDriverProfileButton.setTitle("View your rider's profile", for: .normal)
                viewDriverProfileButton.isHidden = false
                viewRequestersButton.isHidden = true
            }
            
            showInfo()
            
            //TO DO
        }
        if(self.viewingCondition == 2){
            //view from myTrips->requests
            //TO DO
            showInfo()
            
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showInfo()
    {
        self.info.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.info.numberOfLines = 0
        
        self.info.text = "Waiting......"
        
        
        self.info.text = "From " + self.myTrip.from + " To " + self.myTrip.to + "\n"
            + "On " + self.myTrip.date + "\n"
            + self.myTrip.seats + " seats available\n"
            + "Price: " + self.myTrip.price + "\n"
            + "Pick Up Info: " + self.myTrip.pickUp + "\n"
            + "Driver's notes: " + self.myTrip.notes + "\n"
        if (self.viewingCondition == 1) {
            if (self.myTrip.riderID == "") {
                self.info.text! += "No selected Rider.\n"
            }
            else {
                self.info.text! += "You have selected a Rider.\n"
            }
        }
        else if (self.viewingCondition == 2) {
            let userID = (FIRAuth.auth()?.currentUser?.uid)! as String
            if (self.myTrip.riderID == "") {
                self.info.text! += "The driver has not chosen a rider.\n"
            }
            else if (userID == self.myTrip.riderID){
                self.info.text! += "The driver has chosen you as the rider!\n"
            }
            else {
                self.info.text! += "The driver has chosen someone else as the rider QAQ\n"
            }

        }
        self.view.setNeedsDisplay()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let temp = segue.identifier
        print(temp)
        if(segue.identifier == "TripDetail2Profile") {
            if let destination = segue.destination as? DriverProfileViewController {
            
                destination.myProfile = self.driverProfile
                destination.driverFlag = true
                destination.trip = self.myTrip
                print(1)
            }
        }
        if (segue.identifier == "TripDetail2Requesters") {
            if let destination = segue.destination as? RequestersTableViewController {
                destination.trip = self.myTrip
                print(1)
            }
        }
    }
    
    
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @IBAction func sendRequest(_ sender: AnyObject) {
        self.ref = FIRDatabase.database().reference(withPath: "messages")
        
        var reqList = ""
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("posts").child(self.myTrip.tripID).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            reqList = reqList + userID! + ","
            var path = "messages/" + userID! + "/myPostsList"
            self.ref.child("posts").child(self.myTrip.tripID).child("requestList").setValue(reqList)
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.userRef.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            reqList = value?["myRequestsList"] as! String
            reqList = reqList + self.myTrip.tripID + ","
            self.userRef.child(userID!).child("myRequestsList").setValue(reqList)
        }) { (error) in
            print(error.localizedDescription)
        }

        
        
        
        
        let alert = UIAlertController(title: "Thank You",
                                      message: "Sent request to driver successfully!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Awesome", style: .default, handler: {(alert: UIAlertAction!) in self.showNextView()})
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        //TO DO: send the request to driver
    }
    
    func showNextView()
    {
        self.navigationController?.popToRootViewController(animated: true)
    }

    
    @IBAction func viewDriver(_ sender: AnyObject) {
        

    }
    @IBAction func viewRequesters(_ sender: AnyObject) {
        

    }
    
}
