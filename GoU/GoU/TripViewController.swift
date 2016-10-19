//
//  driverViewController.swift
//  GoU
//
//  Created by SunYufan on 10/5/16.
//  Copyright © 2016 SunYufan. All rights reserved.
//

import UIKit

class TripViewController: UIViewController {
    //MARK: properties
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var seatsTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submit(){
        if (fromTextField.text == "" || toTextField.text == "" ||
            dateTextField.text == "" || seatsTextField.text == "")
        {
            showAlert()
        }
        
        else
        {
            trip.from = fromTextField.text!
            trip.to = toTextField.text!
            trip.date = dateTextField.text!
            trip.seats = seatsTextField.text!
            trips.append(trip)
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
