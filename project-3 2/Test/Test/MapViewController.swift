//
//  MapViewController.swift
//  Test
//
//  Created by Gireesh Mahajan on 3/1/17.
//  Copyright © 2017 Gireesh Mahajan. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseAuth

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class MapViewController: UIViewController {
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    var resultSearchController:UISearchController? = nil
    
    var selectedPin:MKPlacemark? = nil
    
    let ref = FIRDatabase.database().reference(withPath: "Events")
    let ref1 = FIRDatabase.database().reference()
    let ref3 = FIRDatabase.database().reference(withPath: "Users")
    let uid = FIRAuth.auth()?.currentUser?.uid
    
    var cords = CLLocationCoordinate2D()
    
    var realname = String()
    
    var date = String()
    var name = String()
    var descrp = String()
    
    
    @IBAction func finishEvent(_ sender: Any) {
        
        
        print("date:", date)
        print("name:", name)
        print("description:", descrp)
        
        
        let searchBar = resultSearchController!.searchBar
        
        let lat : NSNumber = NSNumber(value: cords.latitude)
        let lng : NSNumber = NSNumber(value: cords.longitude)
        let lat1 = String(format:"%f", lat.doubleValue)
        let lng1 = String(format:"%f", lng.doubleValue)
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        var currNum = 0
        ref1.child("CurrentNumber").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if (snapshot.exists()) {
                currNum = (snapshot.value as? Int)!
                print("crr num", currNum)
                var curNum = currNum + 1
                print("new curr num", curNum)
                self.ref1.child("Users").child(uid!).child("eventshosted").child(String(curNum)).setValue(String(curNum))
                let evenTItem = eventItem(name: self.name, date: self.date, description: self.descrp, location: searchBar.text!, cord1: lat1, cord2:lng1, creator:uid!, creatorName:self.realname)
                let eventItemRef = self.ref.child(String(curNum))
                eventItemRef.setValue(evenTItem.toAnyObject())
                self.ref1.child("CurrentNumber").setValue(curNum)
                self.performSegue(withIdentifier: "returnHome3",sender: self)
            } else {
                print("snapshot no exist")
            }
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref3.child(uid!).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if (snapshot.exists()) {
                self.realname = snapshot.value as! String
                
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        // Do any additional setup after loading the view.
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
    
    func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }

}

extension MapViewController : CLLocationManagerDelegate {
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
}

extension MapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        cords = annotation.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "(city) (state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}
extension MapViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
        button.addTarget(self, action: #selector(MapViewController.getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}
