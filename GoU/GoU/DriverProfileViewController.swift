//
//  DriverProfileViewController.swift
//  GoU
//
//  Created by AlexaLiu on 11/3/16.
//  Copyright © 2016 SunYufan. All rights reserved.
//
// TODO: button when viewingcondition == 1, select the user as the rider.

import UIKit
import Firebase

class DriverProfileViewController: UIViewController {

    
    @IBOutlet weak var info: UILabel!
    
    
    @IBOutlet weak var acceptRequest: UIButton!
    
    var userRef: FIRDatabaseReference!
    var ref: FIRDatabaseReference!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsDisplay()
        
        showInfo()
        
        acceptRequest.isHidden = true

        self.info.text = "Waiting......"
        
        
        if(viewingCondition == 1 && tripViewing.riderID == ""){
            acceptRequest.isHidden = false
        }
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
        
        let temp = driverInfo
        self.info.text = "Driver Name: " + driverInfo.name + "\n"
            + "Gender: " + driverInfo.gender + "\n"
            + "Location " + driverInfo.loc + "\n"
            + "Email Address: " + driverInfo.email + "\n"
            + "Phone Number: " + driverInfo.phone + "\n"
        self.view.setNeedsDisplay()
    }

    
    @IBAction func acceptRequest(_ sender: AnyObject) {
        //TO DO: show alert
        let temp1 = tripViewing.tripID
        let temp2 = driverInfo.userID
        self.ref = FIRDatabase.database().reference(withPath: "messages")

        self.ref.child("posts").child(tripViewing.tripID).child("riderID").setValue(driverInfo.userID)
        

        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
