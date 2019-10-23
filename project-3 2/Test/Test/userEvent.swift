//
//  User.swift
//  Test
//
//  Created by Brandon Zhang on 3/27/17.
//  Copyright © 2017 Gireesh Mahajan. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct userEvent {
    
    let key: String
    var user: String
    let event: String
    let ref: FIRDatabaseReference?
    
    
    init(user: String, key: String, event: String) {
        self.key = key
        self.ref = nil
        self.user = user
        self.event = event
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        user = snapshotValue["user"] as! String
        event = snapshotValue["event"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "user": user,
            "event": event
            
        ]
    }
}

