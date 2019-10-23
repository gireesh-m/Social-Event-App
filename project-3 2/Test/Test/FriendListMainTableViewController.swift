//
//  FriendListMainTableViewController.swift
//  Test
//
//  Created by Gireesh Mahajan on 4/24/17.
//  Copyright © 2017 Gireesh Mahajan. All rights reserved.
//

import UIKit

import FirebaseAuth
import FirebaseDatabase

class FriendListMainTableViewController: UITableViewController {
    
    var resultSearchController:UISearchController? = nil
    
    var friendName:String = ""
    
    var matchingItems: [friendLink] = []
    
    let ref = FIRDatabase.database().reference(withPath: "Users")
    let ref2 = FIRDatabase.database().reference(withPath: "Friends")
    
    let uid = FIRAuth.auth()?.currentUser?.uid


    @IBAction func goBack(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let logScreen = storyboard.instantiateViewController(withIdentifier: "CreateEventMainPage")
        self.present(logScreen, animated: true, completion: nil)
    }
    
   

    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        updateTable()
        let friendSearchTable = storyboard!.instantiateViewController(withIdentifier: "friendListSearchTable") as! FriendListTableViewController
        resultSearchController = UISearchController(searchResultsController: friendSearchTable)
        resultSearchController?.searchResultsUpdater = friendSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search users"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        tableView.tableHeaderView = resultSearchController?.searchBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func updateTable() {
        ref2.observe(.value, with: { snapshot in
            var items:[friendLink] = []
            for item in snapshot.children {
                let eventItem1 = friendLink(snapshot: item as! FIRDataSnapshot)
                if (eventItem1.uid1.lowercased() == self.uid?.lowercased() || eventItem1.uid2.lowercased() == self.uid?.lowercased()) {
                    items.append(eventItem1)
                }
            }
            print(self.matchingItems.count)
            print("detaReload started")
            DispatchQueue.main.async {
                self.matchingItems = items
                self.tableView.reloadData()
            }
            print("detaReload finished")
        })
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMain", for: indexPath) as! FriendTableViewCell
        let selectedItem = matchingItems[indexPath.row]
        var photoData = ""
        if (selectedItem.uid1.lowercased() == uid?.lowercased()) {
            cell.lebelCell.text = selectedItem.name2
            ref.observe(.value, with: { snapshot in
                for item in snapshot.children {
                    let userTest = User(snapshot: item as! FIRDataSnapshot)
                    if (userTest.key.lowercased() == selectedItem.uid2.lowercased()) {
                        photoData = userTest.profilePhoto
                        let dataDecoded : Data = Data(base64Encoded: photoData, options: .ignoreUnknownCharacters)!
                        let decodedimage = UIImage(data: dataDecoded)
                        cell.imageCell.image = decodedimage
                    }
                }
            })
        } else if (selectedItem.uid2.lowercased() == uid?.lowercased()) {
            cell.lebelCell.text = selectedItem.name1
            ref.observe(.value, with: { snapshot in
                for item in snapshot.children {
                    let userTest = User(snapshot: item as! FIRDataSnapshot)
                    if (userTest.key.lowercased() == selectedItem.uid1.lowercased()) {
                        photoData = userTest.profilePhoto
                    }
                }
            })
        }
        
        return cell
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
extension FriendListMainTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row]
        var iid:String = ""
        if (selectedItem.uid1 == uid) {
            iid = selectedItem.uid2
        } else if (selectedItem.uid2 == uid) {
            iid = selectedItem.uid1
        }
        print("reall iid" + iid)
        let storyboard = UIStoryboard(name: "friends", bundle: nil)
        let logScreen = storyboard.instantiateViewController(withIdentifier: "FriendEventTableViewController") as! FriendEventTableViewController
        logScreen.iid = iid
        self.present(logScreen, animated: true, completion: nil)
        
        
        
        
        
    }
}
