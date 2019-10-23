//
//  User.swift
//  Test
//
//  Created by Brandon Zhang on 3/27/17.
//  Copyright © 2017 Gireesh Mahajan. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct User {
    
    let key: String
    var name: String
    let description: String
    let rating: String
    let profilePhoto: String
    
    let ref: FIRDatabaseReference?
    
    
    init(name: String, key: String, description: String, rating: String, photoData: String) {
        self.key = key
        self.name = name
        self.description = description
        self.ref = nil
        self.rating = rating
        self.profilePhoto = photoData
        
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        description = snapshotValue["description"] as! String
        rating = snapshotValue["rating"] as! String
        profilePhoto = snapshotValue["photo"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "description": description,
            "rating": rating,
            "photo": profilePhoto
        ]
    }
}

