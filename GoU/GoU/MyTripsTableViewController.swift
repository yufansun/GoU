//
//  MyTripsTableViewController.swift
//  GoU
//
//  Created by hjq on 11/3/16.
//  Copyright © 2016 SunYufan. All rights reserved.
//

import UIKit
import Firebase

class MyTripsTableViewController: UITableViewController {
    
    
    var ref: FIRDatabaseReference!
    var userRef: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTrips = []
        
        self.ref = FIRDatabase.database().reference(withPath: "messages")

        
        let userID = FIRAuth.auth()?.currentUser?.uid
        self.ref.child("posts").observe(.childAdded, with: { (snapshot) in
            let key  = snapshot.key as String
            let value = snapshot.value as? NSDictionary
            debugPrint("hello")
            debugPrint(key)
            trip.from = value!["from"]! as! String
            trip.to = value!["to"]! as! String
            trip.date = value!["date"]! as! String
            trip.seats = value!["seats"]! as! String
            trip.notes = value!["notes"]! as! String
            trip.tripID = key as! String
            trip.ownerID = value!["ownerID"]! as! String
            trip.price = value!["price"]! as! String
            trip.pickUp = value!["pickUp"]! as! String
            
            
            debugPrint(trip.ownerID)
            // TODO: DO linear search?
            if (trip.ownerID == userID) {
                if (myTrips.isEmpty || myTrips[myTrips.endIndex - 1].tripID != trip.tripID) {
                    myTrips.append(trip)
                }
            }
            
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
            
            
            
        }) { (error) in
            print(error.localizedDescription)
        }

        
//        self.ref = FIRDatabase.database().reference(withPath: "messages")
//        self.userRef = FIRDatabase.database().reference(withPath: "commonProfiles")
//                
//        let postArr = myPostList.components(separatedBy: ",")
//        print(postArr)
//
//        
//        myTrips = []
//        
//        for myTripID in postArr {
//            if (myTripID != "") {
//            self.ref.child("posts").child(myTripID).observe(.value, with: { (snapshot) in
//                let key  = snapshot.key as String
//                let value = snapshot.value as? NSDictionary
//                debugPrint("hello")
//                debugPrint(key)
//                trip.from = value!["from"]! as! String
//                trip.to = value!["to"]! as! String
//                trip.date = value!["date"]! as! String
//                trip.seats = value!["seats"]! as! String
//                trip.notes = value!["notes"]! as! String
//                trip.tripID = key as! String
//                trip.ownerID = value!["ownerID"]! as! String
//                trip.price = value!["price"]! as! String
//                trip.pickUp = value!["pickUp"]! as! String
//                
//                
//                //            debugPrint(trip.ownerID)
//                // TODO: DO linear search?
//                
//                if (myTrips.isEmpty || myTrips[myTrips.endIndex - 1].tripID != trip.tripID) {
//                    myTrips.append(trip)
//                }
//                
//                self.tableView.delegate = self
//                self.tableView.dataSource = self
//                self.tableView.reloadData()
//                
//                
//                
//            }) { (error) in
//                print(error.localizedDescription)
//            }
//            }
//
//        }
//        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        
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
        return myTrips.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTripItem", for: indexPath)
        
        cell.textLabel?.text = "From \(myTrips[indexPath.row].from) To \(myTrips[indexPath.row].to) on \(myTrips[indexPath.row].date)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //TO DO: Check the ordering
        
        tripViewing = myTrips[indexPath.row]
        
        NSLog(tripViewing.ownerID)
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
