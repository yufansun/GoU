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
    
    var tempTrip = Trip(from: "Ann Arbor",to: "Chicago",date: "10/18/2016",seats: "3", ownerID: "", tripID: "",notes: "", price: "", pickUp: "", riderID: "")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsDisplay()
        tempTrip = tripViewing
        
        viewDriverProfileButton.isHidden = true
        viewRequestersButton.isHidden = true
        matchTripButton.isHidden = true
        
        
        self.userRef = FIRDatabase.database().reference(withPath: "commonProfiles")
        self.userRef.child(tripViewing.ownerID).observe(.value, with: { (snapshot) in
            let key  = snapshot.key as String
            let value = snapshot.value as? NSDictionary
            let firstName = value!["firstName"]! as! String
            let lastName = value!["lastName"]! as! String
            driverInfo.gender = value!["gender"]! as! String
            let city = value!["currentCityName"]! as! String
            let state = value!["currentStateName"]! as! String
            let country = value!["currentCountryName"]! as! String
            driverInfo.email = value!["emailAddress"]! as! String
            driverInfo.phone = value!["phoneNumber"]! as! String
            driverInfo.aboutme = value!["aboutMe"]! as! String
            
            driverInfo.name = firstName + " " + lastName
            driverInfo.loc = city + ", " + state + ", " + country
            print("a")
            
        }) { (error) in
            print(error.localizedDescription)
        }

        
        if(viewingCondition == 0){
            viewDriverProfileButton.isHidden = false
            matchTripButton.isHidden = false
            
            showInfo()
        }
        
        if(viewingCondition == 1){
            //view from myTrips->post
            viewRequestersButton.isHidden = false
            if (tripViewing.riderID != ""){
            
                viewDriverProfileButton.setTitle("View your rider's profile", for: .normal)
                viewDriverProfileButton.isHidden = false
                viewRequestersButton.isHidden = true
            }
            
            showInfo()
            
            //TO DO
        }
        if(viewingCondition == 2){
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
        
        
        self.info.text = "From " + tempTrip.from + " To " + tempTrip.to + "\n"
            + "On " + tempTrip.date + "\n"
            + tempTrip.seats + " seats available\n"
            + "Price: " + tempTrip.price + "\n"
            + "Pick Up Info: " + tempTrip.pickUp + "\n"
            + "Driver's notes: " + tempTrip.notes + "\n"
        if (viewingCondition == 1) {
            if (tempTrip.riderID == "") {
                self.info.text! += "No selected Rider.\n"
            }
            else {
                self.info.text! += "You have selected a Rider.\n"
                self.userRef.child(tempTrip.riderID).observe(.value, with: { (snapshot) in
                    let key  = snapshot.key as String
                    let value = snapshot.value as? NSDictionary
                    let firstName = value!["firstName"]! as! String
                    let lastName = value!["lastName"]! as! String
                    driverInfo.gender = value!["gender"]! as! String
                    let city = value!["currentCityName"]! as! String
                    let state = value!["currentStateName"]! as! String
                    let country = value!["currentCountryName"]! as! String
                    driverInfo.email = value!["emailAddress"]! as! String
                    driverInfo.phone = value!["phoneNumber"]! as! String
                    driverInfo.aboutme = value!["aboutMe"]! as! String
                    driverInfo.userID = value!["userId"]! as! String
                    
                    driverInfo.name = firstName + " " + lastName
                    driverInfo.loc = city + ", " + state + ", " + country
                    print("a")
                    
                }) { (error) in
                    print(error.localizedDescription)
                }

                
            }
        }
        else if (viewingCondition == 2) {
            let userID = (FIRAuth.auth()?.currentUser?.uid)! as String
            if (tempTrip.riderID == "") {
                self.info.text! += "The driver has not chosen a rider.\n"
            }
            else if (userID == tempTrip.riderID){
                self.info.text! += "The driver has chosen you as the rider!\n"
            }
            else {
                self.info.text! += "The driver has chosen someone else as the rider QAQ\n"
            }

        }
        self.view.setNeedsDisplay()
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
        ref.child("posts").child(tripViewing.tripID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            reqList = value?["requestList"] as! String
            //            print("in database postlist is " + postList)
            reqList = reqList + userID! + ","
            //            print("after postlist is " + postList)
            var path = "messages/" + userID! + "/myPostsList"
            self.ref.child("posts").child(tripViewing.tripID).child("requestList").setValue(reqList)
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.userRef.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            reqList = value?["myRequestsList"] as! String
            //            print("in database postlist is " + postList)
            reqList = reqList + tripViewing.tripID + ","
            //            print("after postlist is " + postList)
//            var path = "commonProfiles/" + userID! + "/myPostsList"
            self.userRef.child(userID!).child("myRequestsList").setValue(reqList)
        }) { (error) in
            print(error.localizedDescription)
        }

        
        
        
        
        let alert = UIAlertController(title: "Thank You",
                                      message: "Send request to driver sucessfully!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Awesome", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        //TO DO: send the request to driver
    }
    
    @IBAction func viewRequesters(_ sender: AnyObject) {
        self.ref = FIRDatabase.database().reference(withPath: "messages")
        
        var requesterList = ""
        self.ref.child("posts").child(tripViewing.tripID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let requesterList = value?["requestList"] as! String
            requesterArr = requesterList.components(separatedBy: ",")
            let temp = requesterArr
            print(requesterArr)
            
        }) { (error) in
            print(error.localizedDescription)
        }
        

    }
    
}
