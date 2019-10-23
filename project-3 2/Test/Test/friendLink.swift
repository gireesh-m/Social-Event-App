//
//  friendLink.swift
//  Test
//
//  Created by Gireesh Mahajan on 3/31/17.
//  Copyright © 2017 Gireesh Mahajan. All rights reserved.
//

import Foundation
import Firebase

struct friendLink {
    let key: String
    let uid1: String
    let uid2: String
    let name1: String
    let name2: String
    let ref: FIRDatabaseReference?
    
    
    init(uid1: String, uid2: String, name1: String, name2: String) {
        self.key = uid1+uid2
        self.uid1 = uid1
        self.uid2 = uid2
        self.name1 = name1
        self.name2 = name2
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        uid1 = snapshotValue["uid1"] as! String
        uid2 = snapshotValue["uid2"] as! String
        name1 = snapshotValue["name1"] as! String
        name2 = snapshotValue["name2"] as! String

        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "uid1": uid1,
            "uid2": uid2,
            "name1": name1,
            "name2": name2
        ]
    }
}
