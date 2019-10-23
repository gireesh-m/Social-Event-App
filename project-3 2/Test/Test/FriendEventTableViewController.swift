//
//  FriendEventTableViewController.swift
//  Test
//
//  Created by Gireesh Mahajan on 5/18/17.
//  Copyright © 2017 Gireesh Mahajan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class FriendEventTableViewController: UITableViewController {
    
    var iid:String = ""
    let ref = FIRDatabase.database().reference(withPath: "Users")
    let ref2 = FIRDatabase.database().reference(withPath: "Events")
    var matchingItems: [String] = []
    var matchingEvents: [eventItem] = []
    let uid = FIRAuth.auth()?.currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTable()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    private func updateTable() {
        print("iid" + iid)
        ref.child(iid).child("eventshosted").observe(.value, with: { snapshot in
            var items:[String] = []
            print("looking")
            for item in snapshot.children {
                let eventId = (item as! FIRDataSnapshot).key
                items.append(eventId)
            }
            print("act", items.count)
            self.matchingItems = items
            print("1" + String(self.matchingItems.count))
            self.updateTable2()
        })
        
        
    }
    
    // this isn't really a necessary funciton, but i need to wait for firebase to finish, 
    // so this linked method stuff is kinda necessary
    private func updateTable2() {
        var items:[eventItem] = []
        for str in matchingItems {
            ref2.child(str).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                if (snapshot.exists()) {
                    let value = eventItem(snapshot: snapshot)
                    items.append(value)
                    self.matchingEvents = items
                    self.tableView.reloadData()
                }
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("count", matchingEvents.count)
        return matchingEvents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMain", for: indexPath) 
        let selectedItem = matchingEvents[indexPath.row]
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = selectedItem.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingEvents[indexPath.row]
        let eventItemRef = self.ref.child(uid!).child("rsvp").child(selectedItem.key)
        eventItemRef.setValue(selectedItem.key)

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
