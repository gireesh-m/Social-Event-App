//
//  FriendListViewController.swift
//  Test
//
//  Created by Gireesh Mahajan on 3/25/17.
//  Copyright © 2017 Gireesh Mahajan. All rights reserved.
//

import UIKit
import FirebaseDatabase



class FriendListViewController: UIViewController {

    var resultSearchController:UISearchController? = nil
    
    var friendName:String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
