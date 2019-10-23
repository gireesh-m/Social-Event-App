//
//  RestaurantAnnotation.swift
//  Test
//
//  Created by Gireesh Mahajan on 3/14/17.
//  Copyright © 2017 Gireesh Mahajan. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class RestaurantAnnotation: NSObject, MKAnnotation {
    
  
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var info: String?
    var creator: String?
    var eta: String?
    var date: String?
    var eventId: String?
    var creatorname: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
