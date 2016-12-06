//
//  MyTripsViewController.swift
//  GoU
//
//  Created by hjq on 11/5/16.
//  Copyright © 2016 SunYufan. All rights reserved.
//

import UIKit
import Firebase

class MyTripsViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    var ref: FIRDatabaseReference!
    var userRef: FIRDatabaseReference!
    var tripRequests = ""
    var myPostTrips = [Trip]()
    var myRequestTrips = [Trip]()
    
    @IBOutlet weak var mySegment: UISegmentedControl!
    
    @IBOutlet weak var tripsTableView: UITableView!
    
    var userID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = FIRDatabase.database().reference(withPath: "messages")
        self.userRef = FIRDatabase.database().reference(withPath: "commonProfiles")
        
        userID = (FIRAuth.auth()?.currentUser?.uid)!
        self.ref.child("posts").observe(.value, with: { (snapshot) in
            self.myPostTrips = []
            self.myRequestTrips = []
            
            let key  = snapshot.key as String
            let value = snapshot.value as? NSDictionary
            if (value != nil) {
                let tripKeys = value?.allKeys as! [String]
                debugPrint("hello")
                debugPrint(key)
            
            
                for currTrip in tripKeys{
                    var trip = Trip()
                    trip.from = (value![currTrip]! as! NSDictionary)["from"]! as! String
                    trip.to = (value![currTrip]! as! NSDictionary)["to"]! as! String
                    trip.date = (value![currTrip]! as! NSDictionary)["date"]! as! String
                    trip.seats = (value![currTrip]! as! NSDictionary)["seats"]! as! String
                    trip.notes = (value![currTrip]! as! NSDictionary)["notes"]! as! String
                    trip.tripID = currTrip
                    trip.ownerID = (value![currTrip]! as! NSDictionary)["ownerID"]! as! String
                    trip.price = (value![currTrip]! as! NSDictionary)["price"]! as! String
                    trip.pickUp = (value![currTrip]! as! NSDictionary)["pickUp"]! as! String
                    trip.riderID = (value![currTrip]! as! NSDictionary)["riderID"]! as! String
                    self.tripRequests = (value![currTrip]! as! NSDictionary)["requestList"]! as! String
                
                    let requestArr = self.tripRequests.components(separatedBy: ",")
                    print(requestArr)
                
                
                    debugPrint(trip.ownerID)
                    // TODO: DO linear search?
                
                    if (trip.ownerID == self.userID) {
                        self.myPostTrips.append(trip)
                    }
                
                    if (requestArr.contains(self.userID)) {
                        self.myRequestTrips.append(trip)
                    }
                }
            }

            self.tripsTableView.delegate = self
            self.tripsTableView.dataSource = self
            self.tripsTableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        
        
        //tabBarController?.tabBar.items?[2].badgeValue = "2"

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath = self.tripsTableView.indexPathForSelectedRow

        
        
        
        let temp = segue.identifier
        print(temp)
        if(segue.identifier == "MyTripsTable2TripDetail") {
            if let destination = segue.destination as? TripDetailViewController {
                
                if (mySegment.selectedSegmentIndex == 0){
                    //My posts
                    destination.viewingCondition = 1
                    destination.myTrip = self.myPostTrips[(indexPath?.row)!]
                    
                }
                if (mySegment.selectedSegmentIndex == 1){
                    //My requests
                    destination.viewingCondition = 2
                    destination.myTrip = self.myRequestTrips[(indexPath?.row)!]
                    
                }
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var numRows = 0
        
        if (mySegment.selectedSegmentIndex == 0){
            //My posts
            numRows = self.myPostTrips.count
            print(numRows)
            
            
        }
        if (mySegment.selectedSegmentIndex == 1){
            //My requests
            //TO DO
            numRows = self.myRequestTrips.count
            print(numRows)
        }
        
        
        return numRows
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTripItem", for: indexPath)
        
        
        if (mySegment.selectedSegmentIndex == 0){
            //My posts
            cell.textLabel?.text = "\(self.myPostTrips[indexPath.row].from) - \(self.myPostTrips[indexPath.row].to) - \(self.myPostTrips[indexPath.row].date)"
            
            
//            cell.detailTextLabel?.text = "\(requesters.count) Requesters"
            
            cell.detailTextLabel?.text = "View Requesters"
            
//            if(myRequests[indexPath.row].riderID != ""){
//                cell.detailTextLabel?.text = "Matched"
//            }
//            
//            if (requesters.count <= 1){
//                cell.detailTextLabel?.text = "\(requesters.count) Requester"
//            }
//            
//            if(myTrips[indexPath.row].riderID != ""){
//                cell.detailTextLabel?.text = "Matched"
//            }
            
        }
        if (mySegment.selectedSegmentIndex == 1){
            //My requests
            cell.textLabel?.text = "\(self.myRequestTrips[indexPath.row].from) - \(self.myRequestTrips[indexPath.row].to) - \(self.myRequestTrips[indexPath.row].date)"
            
            //TO DO
            cell.detailTextLabel?.text = "No response"
            if(self.myRequestTrips[indexPath.row].riderID == userID){
                cell.detailTextLabel?.text = "Accepted"
            }
            if(self.myRequestTrips[indexPath.row].riderID != "" && self.myRequestTrips[indexPath.row].riderID != userID){
                cell.detailTextLabel?.text = "Failed"
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
     }
    
    
    @IBAction func switchView(_ sender: AnyObject) {
        self.tripsTableView.reloadData()
    }
    
    
    
    @IBAction func refresh(_ sender: AnyObject) {
        self.tripsTableView.reloadData()
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
