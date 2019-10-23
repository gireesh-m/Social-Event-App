//
//  MainPage.swift
//  Test
//
//  Created by Gireesh Mahajan on 3/14/17.
//  Copyright © 2017 Gireesh Mahajan. All rights reserved.
//

import Foundation
//Searching code adapted from http://sweettutos.com/2015/04/24/swift-mapkit-tutorial-series-how-to-search-a-place-address-or-poi-in-the-map/

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseAuth
import FirebaseDatabase


class MainPage: UIViewController, MKMapViewDelegate, UISearchBarDelegate {
    
    let uid = FIRAuth.auth()?.currentUser?.uid
    let refUser = FIRDatabase.database().reference(withPath: "Users")

    var names:[String]!
    var images:[UIImage]!
    var descriptions:[String]!
    var coordinates:[[String]]!
    var currentRestaurantIndex: Int = 0
    var locationManager: CLLocationManager! // A reference to the location manager
    
    //Variables needed for searching
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    let ref = FIRDatabase.database().reference(withPath: "Events")
    
    let CLManager = CLLocationManager()
    
    @IBAction func showSearchBar(_ sender: Any) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    @IBAction func logoutAccount(_ sender: Any) {
        print("clicked")
        if FIRAuth.auth()?.currentUser != nil{
            do{
                try FIRAuth.auth()?.signOut()
                
                let storyboard = UIStoryboard(name: "HomeScreen", bundle: nil)
                
                let screen = storyboard.instantiateViewController(withIdentifier: "homePage")
                
                self.present(screen, animated: true, completion: nil)
                
            } catch let error as NSError{
                print(error.localizedDescription)
                
            }
        }
    }
    
    @IBAction func createEvent(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateEventMainPage") as UIViewController
        present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func locClick(_ sender: Any) {
        CLManager.startUpdatingLocation()
    }
    
    @IBAction func showNext(_ sender: Any) {
        
        // 1
        if currentRestaurantIndex > names.count - 1{
            currentRestaurantIndex = 0
        }
        
        // 2
        //let coordinate = coordinates[currentRestaurantIndex] as! [Double]
        let latitude: Double   = Double(coordinates[currentRestaurantIndex][0])!
        let longitude: Double  = Double(coordinates[currentRestaurantIndex][1])!
        let locationCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        var point = RestaurantAnnotation(coordinate: locationCoordinates)
        // var point = MKPointAnnotation(coordinate: locationCoordinates)
        point.title = names[currentRestaurantIndex]
        point.info = descriptions[currentRestaurantIndex]
        print("event", point.title)
        // point.image = images[currentRestaurantIndex]
        // 3
        // Calculate Transit ETA Request
        let request = MKDirectionsRequest()
        /* Source MKMapItem */
        let sourceItem = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate, addressDictionary: nil))
        request.source = sourceItem
        /* Destination MKMapItem */
        let destinationItem = MKMapItem(placemark: MKPlacemark(coordinate: locationCoordinates, addressDictionary: nil))
        request.destination = destinationItem
        request.requestsAlternateRoutes = false
        // Looking for Transit directions, set the type to Transit
        request.transportType = .transit
        // Center the map region around the restaurant coordinates
        //mapView.setCenter(locationCoordinates, animated: true)
        // You use the MKDirectionsRequest object constructed above to initialise an MKDirections object
        let directions = MKDirections(request: request)
        directions.calculateETA { (etaResponse, error) -> Void in
            if let error = error {
                print("Error while requesting ETA : \(error.localizedDescription)")
                point.eta = error.localizedDescription
            }else{
                point.eta = "\(Int((etaResponse?.expectedTravelTime)!/60)) min"
            }
            // 4
            var isExist = false
            for annotation in self.mapView.annotations{
                if annotation.coordinate.longitude == point.coordinate.longitude && annotation.coordinate.latitude == point.coordinate.latitude{
                    isExist = true
                    point = annotation as! RestaurantAnnotation
                }
            }
            if !isExist{
                self.mapView.addAnnotation(point)
            }
            self.mapView.selectAnnotation(point, animated: true)
            self.currentRestaurantIndex += 1
            
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        
        
//        var names: [String] = []
//        
//        var descriptions: [String] = []
//        
//        var coordinates: [[String]] = []
//
        names = []
        coordinates = []
        descriptions = []
        
        ref.observe(.value, with: { snapshot in
            for item in snapshot.children {
                let eventItem1 = eventItem(snapshot: item as! FIRDataSnapshot)
                self.names.append(eventItem1.name)
                print(eventItem1.cord1)
                print(eventItem1.cord2)
                self.coordinates.append([eventItem1.cord1, eventItem1.cord2])
                self.descriptions.append(eventItem1.description)
                let creator = eventItem1.creator
                let date = eventItem1.date
                let latitude: Double   = Double(eventItem1.cord1)!
                let longitude: Double  = Double(eventItem1.cord2)!
                let locationCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
                var point = RestaurantAnnotation(coordinate: locationCoordinates)
                // var point = MKPointAnnotation(coordinate: locationCoordinates)
                point.title = eventItem1.name
                point.info = eventItem1.description
                point.creator = creator
                point.date = date
                point.eventId = eventItem1.key
                point.creatorname = eventItem1.creatorName
                
               /** let request = MKDirectionsRequest()
                /* Source MKMapItem */
                let sourceItem = MKMapItem(placemark: MKPlacemark(coordinate: self.mapView.userLocation.coordinate, addressDictionary: nil))
                request.source = sourceItem
                /* Destination MKMapItem */
                let destinationItem = MKMapItem(placemark: MKPlacemark(coordinate: locationCoordinates, addressDictionary: nil))
                request.destination = destinationItem
                request.requestsAlternateRoutes = false
                // Looking for Transit directions, set the type to Transit
                request.transportType = .transit
                // Center the map region around the restaurant coordinates
                //mapView.setCenter(locationCoordinates, animated: true)
                // You use the MKDirectionsRequest object constructed above to initialise an MKDirections object
                let directions = MKDirections(request: request)
                directions.calculateETA { (etaResponse, error) -> Void in
                    if let error = error {
                        print("Error while requesting ETA : \(error.localizedDescription)")
                        point.eta = error.localizedDescription
                    }else{
                        point.eta = "\(Int((etaResponse?.expectedTravelTime)!/60)) min"
                    }
                }*/

                var isExist = false
                for annotation in self.mapView.annotations{
                    if annotation.coordinate.longitude == point.coordinate.longitude && annotation.coordinate.latitude == point.coordinate.latitude{
                        isExist = true
                        point = annotation as! RestaurantAnnotation
                    }
                }
                if !isExist{
                    self.mapView.addAnnotation(point)
                }
               // self.mapView.selectAnnotation(point, animated: true)
               // self.currentRestaurantIndex += 1
                
                

            }
            
            self.currentRestaurantIndex = 0 // Start with the first Restaurant in the array
            print("name count", self.names.count)
            // Ask for user permission to access location infos
            self.locationManager = CLLocationManager()
            self.locationManager.requestWhenInUseAuthorization()
            // Show the user current location
            self.mapView.showsUserLocation = true
            self.mapView.delegate = self
        })
        
        
        //All this information should be pulled from the database, but for now it is hardcoded
        //For search, we should have it search for any of these things, and if the string matches
        //anything perfectly, it should show up. For example if I search for "Gaur" everything with
        //Gaur should show up, even if it is in Gaurav. If i Search "Gauravi" however, nothing should
        //show up
//        names = ["Gaurav is a legend", "Gaurav's concert", "Gaurav's party", "SPODIE", "Who is Gaurav", "Hello", "Another spodie", "This app is cool"]
        
         //Lattitudes and longitudes
//        coordinates = [
//            [51.519066, -0.135200],
//            [51.513446, -0.125787],
//            [51.465314, -0.214795],
//            [51.507747, -0.139134],
//            [51.509878, -0.150952],
//            [51.501041, -0.104098],
//            [51.485411, -0.162042],
//            [51.513117, -0.142319]
//        ]
        
//        descriptions =
//            ["10$ to meet him", "only traditional indian music", "5 o'clock at rock, 5$ a cup", "foster at 6", "Gaurav is a cool kid",
//             "Goodbye", "Where it at tho", "gaurav is a baller"]
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: MKMapViewDelegate
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: self.mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // If annotation is not of type RestaurantAnnotation (MKUserLocation types for instance), return nil
        if !(annotation is RestaurantAnnotation){
            return nil
        }
        
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = true
        }else{
            annotationView?.annotation = annotation
        }
        
        let restaurantAnnotation = annotation as! RestaurantAnnotation
        //  annotationView?.detailCalloutAccessoryView = UIImageView(image: restaurantAnnotation.image)
        let rightButton = UIButton(type: .detailDisclosure)
        annotationView?.rightCalloutAccessoryView = rightButton
        
        // Left Accessory
      // let leftAccessory = UILabel(frame: CGRect(x: 0,y: 0,width: 90,height: 30))
        //leftAccessory.numberOfLines = 0
        //leftAccessory.text = restaurantAnnotation.creator!
        //leftAccessory.sizeToFit()
        //leftAccessory.font = UIFont(name: "Verdana", size: 10)
        //annotationView?.leftCalloutAccessoryView = leftAccessory
        
        //let rightAccessory = UILabel(frame: CGRect(x: 50, y: 200, width : 80, height: 0))
        //rightAccessory.numberOfLines = 0
        //rightAccessory.text = restaurantAnnotation.info
        //rightAccessory.sizeToFit()
        //rightAccessory.font = UIFont(name: "Verdana", size: 10)
        //annotationView?.rightCalloutAccessoryView = rightAccessory
        
        
        
        // Right accessory view
        /*   let image = UIImage(named: "bus.png")
         let button = UIButton(type: .custom)
         button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
         button.setImage(image, for: UIControlState())
         annotationView?.rightCalloutAccessoryView = button*/
        return annotationView
        
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //print(mapItem.title!)
        let ra = view.annotation as! RestaurantAnnotation
        let subtitle = ra.info!
        let date = ra.date!
        let creator = ra.creatorname!
        
        let alert = UIAlertController(title: ra.title!, message: subtitle + "\n Date: " + date + "\n Creator: " + creator, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        let directions = UIAlertAction(title: "Directions", style: UIAlertActionStyle.default){
            UIAlertAction in
            
            let placemark = MKPlacemark(coordinate: view.annotation!.coordinate, addressDictionary: nil)
            // The map item is the restaurant location
            let mapItem = MKMapItem(placemark: placemark)
            //
            let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeTransit]
            mapItem.openInMaps(launchOptions: launchOptions)
            
        }
        let rsvp = UIAlertAction(title: "RSVP", style: UIAlertActionStyle.default){
            UIAlertAction in
            self.ref.child(ra.title!.lowercased()).child("rsvp").child(self.uid!).setValue(self.uid!)
            let eventItemRef = self.refUser.child(self.uid!).child("rsvp").child(ra.title!)
            eventItemRef.setValue(ra.title!)
        }
        alert.addAction(directions)
        alert.addAction(rsvp)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //Search Bar Action
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //Translates search query into computer's natural language
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        //When you press the enter button
        localSearch.start { (localSearchResponse, error) -> Void in
            //Error handling
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            //Creates an annotation in order to get to the place
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
            
            //Deletes annotation immediately-all we want is to get there
            self.mapView.removeAnnotation(self.pointAnnotation)
        }
    }
    
}


