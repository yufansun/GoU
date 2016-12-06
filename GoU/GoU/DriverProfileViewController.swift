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

    var myProfile = DriverViewProfile()
    var trip = Trip()
    var driverFlag: Bool!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsDisplay()
        showInfo()
        
        acceptRequest.isHidden = true

        self.info.text = "Waiting......"
        
        
        if(!self.driverFlag && trip.riderID == ""){
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
        
        self.info.text = "Driver Name: " + self.myProfile.name + "\n"
            + "Gender: " + self.myProfile.gender + "\n"
            + "Location " + self.myProfile.loc + "\n"
            + "Email Address: " + self.myProfile.email + "\n"
            + "Phone Number: " + self.myProfile.phone + "\n"
            + "About Me: " + self.myProfile.aboutme + "\n"
        self.view.setNeedsDisplay()
    }

    
    @IBAction func acceptRequest(_ sender: AnyObject) {
        //TO DO: show alert
        self.ref = FIRDatabase.database().reference(withPath: "messages")

        self.ref.child("posts").child(self.trip.tripID).child("riderID").setValue(self.myProfile.userID)
        
        showAlert()

    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Success",
                                      message: "Rider matched!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in self.showNextView()})
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showNextView()
    {
        self.navigationController?.popToRootViewController(animated: true)
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
