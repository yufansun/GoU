//
//  RequestersTableViewController.swift
//  GoU
//
//  Created by AlexaLiu on 11/4/16.
//  Copyright © 2016 SunYufan. All rights reserved.
//

import UIKit
import Firebase

class RequestersTableViewController: UITableViewController {

    var ref: FIRDatabaseReference!
    var userRef: FIRDatabaseReference!
    var tripRequests = ""
    var requesters = [DriverViewProfile]()
    var trip = Trip()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide keyboard
        self.hideKeyboardWhenTappedAround()
        
        self.ref = FIRDatabase.database().reference(withPath: "messages")
        self.userRef = FIRDatabase.database().reference(withPath: "commonProfiles")
        
        
        self.userRef.observe(.value, with: { (snapshot) in
            self.requesters = []
            
            let value = snapshot.value as? NSDictionary
            let userKeys = value?.allKeys as! [String]
            debugPrint("hello")
            
            for currUser in userKeys{
                let saved = (value![currUser]! as! NSDictionary)["saved"]! as! String
                if (saved == "TRUE") {
                    var requester = DriverViewProfile()
                    let firstName = (value![currUser]! as! NSDictionary)["firstName"]! as! String
                    let lastName = (value![currUser]! as! NSDictionary)["lastName"]! as! String
                    requester.gender = (value![currUser]! as! NSDictionary)["gender"]! as! String
                    let city = (value![currUser]! as! NSDictionary)["currentCityName"]! as! String
                    let state = (value![currUser]! as! NSDictionary)["currentStateName"]! as! String
                    let country = (value![currUser]! as! NSDictionary)["currentCountryName"]! as! String
                    requester.email = (value![currUser]! as! NSDictionary)["emailAddress"]! as! String
                    requester.phone = (value![currUser]! as! NSDictionary)["phoneNumber"]! as! String
                    requester.aboutme = (value![currUser]! as! NSDictionary)["aboutMe"]! as! String
                    requester.userID = (value![currUser]! as! NSDictionary)["userId"]! as! String
                    self.tripRequests = (value![currUser]! as! NSDictionary)["myRequestsList"]! as! String
                    
                    
                    requester.name = firstName + " " + lastName
                    requester.loc = city + ", " + state + ", " + country
                    
                    let requestsArr = self.tripRequests.components(separatedBy: ",")
                    
                    // TODO: DO linear search?
                    
                    if (requestsArr.contains(self.trip.tripID)) {
                        self.requesters.append(requester)
                    }
                }
                
                
            }
            
            
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
            
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow
        let temp = segue.identifier
        print(temp)
        if(segue.identifier == "Requesters2Profile") {
            if let destination = segue.destination as? DriverProfileViewController {
                
                destination.myProfile = self.requesters[(indexPath?.row)!]
                destination.driverFlag = false
                destination.trip = self.trip
                print(1)
            }
        }

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var numRows = 0

        numRows = self.requesters.count
        print(numRows)

        return numRows
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "requesterItem", for: indexPath)
        

        cell.textLabel?.text = "\(self.requesters[indexPath.row].name) "
        
        cell.detailTextLabel?.text = "View Profile"
        
//        cell.detailTextLabel?.text = "0 Requester"
//        
//        if (requesters[indexPath.row].userID == tripViewing.riderID){
//        }
//        
        
        

        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
