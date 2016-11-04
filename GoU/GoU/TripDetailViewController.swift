//
//  tripDetailViewController.swift
//  GoU
//
//  Created by hjq on 10/31/16.
//  Copyright © 2016 SunYufan. All rights reserved.
//

import UIKit
import Firebase

class TripDetailViewController: UIViewController {
    

    @IBOutlet weak var info: UILabel!
    
 
    @IBOutlet weak var match: UIButton!
 
    
    var userRef: FIRDatabaseReference!
    var ref: FIRDatabaseReference!
    
    var tempTrip = Trip(from: "Ann Arbor",to: "Chicago",date: "10/18/2016",seats: "3", ownerID: "", tripID: "",notes: "", price: "", pickUp: "")
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsDisplay()
        tempTrip = tripViewing
        
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

        
        
        
        
        self.info.text = "Waiting......"
        showInfo()
        
        
        // Do any additional setup after loading the view.
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
    

    
    @IBAction func submit(_ sender: UIButton) {
        
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

        
        
        
        let alert = UIAlertController(title: "Thank You",
                                      message: "Send request to driver sucessfully!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Awesome", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        //TO DO: send the request to driver

    }

}
