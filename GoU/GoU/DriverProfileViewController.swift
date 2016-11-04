//
//  DriverProfileViewController.swift
//  GoU
//
//  Created by AlexaLiu on 11/3/16.
//  Copyright © 2016 SunYufan. All rights reserved.
//

import UIKit
import Firebase

class DriverProfileViewController: UIViewController {

    
    @IBOutlet weak var info: UILabel!
    
    
    var userRef: FIRDatabaseReference!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsDisplay()
        
        

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
        
        
        self.info.text = "Driver Name: " + driverInfo.name + "\n"
            + "Gender: " + driverInfo.gender + "\n"
            + "Location " + driverInfo.loc + "\n"
            + "Email Address: " + driverInfo.email + "\n"
            + "Phone Number: " + driverInfo.phone + "\n"
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

}
