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
    
    var tempTrip = Trip(from: "Ann Arbor",to: "Chicago",date: "10/18/2016",seats: "3", ownerID: "", tripID: "",notes: "")
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
/*
        self.userRef = FIRDatabase.database().reference(withPath: "commonProfiles")
        
        var firstName = ""
        self.userRef.child(tripViewing.ownerID).observe(.childAdded, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            firstName = value!["firstName"]! as! String
            
            NSLog(firstName)
            
        }) { (error) in
            print(error.localizedDescription)
        }
 */

        
        
        tempTrip = tripViewing
        self.info.text = "Waiting......"
        self.showInfo()
        
        
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
            + "Driver's notes: " + tempTrip.notes + "\n"
            + "Provided by " + tempTrip.ownerID + "\n"
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
        let alert = UIAlertController(title: "Thank You",
                                      message: "Send request to driver sucessfully!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Awesome", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        //TO DO: send the request to driver

    }

}
