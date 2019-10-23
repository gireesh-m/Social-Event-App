//
//  eventItem.swift
//  Test
//
//  Created by Gireesh Mahajan on 3/6/17.
//  Copyright © 2017 Gireesh Mahajan. All rights reserved.
//

import Foundation
import FirebaseDatabase



struct eventItem {
    
    let key: String
    let name: String
    let date: String
    let description: String
    let location: String
    let cord1: String
    let cord2: String
    let creator: String
    let creatorName: String
    let ref: FIRDatabaseReference?
  
    
    init(name: String, date: String, key: String = "", description: String, location: String, cord1:String, cord2:String, creator:String, creatorName: String) {
        self.key = key
        self.name = name
        self.date = date
        self.description = description
        self.ref = nil
        self.cord1 = cord1
        self.cord2 = cord2
        self.location = location
        self.creator = creator
        self.creatorName = creatorName
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        date = snapshotValue["date"] as! String
        description = snapshotValue["description"] as! String
        location = snapshotValue["location"] as! String
        cord1 = snapshotValue["cord1"] as! String
        cord2 = snapshotValue["cord2"] as! String
        creator = snapshotValue["creator"] as! String
        creatorName = snapshotValue["creatorName"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "date": date,
            "description": description,
            "location": location,
            "cord1": cord1,
            "cord2": cord2,
            "creator": creator,
            "creatorName": creatorName
        ]
    }
    
}

