//
//  EventViewController.swift
//  Test
//
//  Created by Gireesh Mahajan on 3/1/17.
//  Copyright © 2017 Gireesh Mahajan. All rights reserved.
//

import UIKit
import FirebaseDatabase



class EventViewController: UIViewController {

    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
   var date = String()
    
    let ref = FIRDatabase.database().reference(withPath: "Events")
    
    
    @IBAction func dateChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        date = dateFormatter.string(from: datePicker.date)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if (segue.identifier == "goToNav") {
            let navController = segue.destination as! UINavigationController
            let mapViewController = navController.topViewController as! MapViewController
            let name = nameTextField.text!
            let descrp = descriptionTextField.text!
            mapViewController.name = name
            mapViewController.date = date
            mapViewController.descrp = descrp
        }
        
    }
    
    
    
    
    
    
    
    /*@IBAction func eventFormNext(_ sender: Any) {
        let name = nameTextField.text!;
        let descrp = descriptionTextField.text!;
    
        let evenTItem = eventItem(name: name, date: date, description: descrp)
        let eventItemRef = self.ref.child(name.lowercased())
        eventItemRef.setValue(evenTItem.toAnyObject())
        
    }*/
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.observe(.value, with: { snapshot in
            print(snapshot.value)
            var items: [eventItem] = []
            
            for item in snapshot.children {
                // 4
                let groceryItem = eventItem(snapshot: item as! FIRDataSnapshot)
                print("EVENTS:", groceryItem)
            }
            
        
            
        })
        /*let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { _ in
                                        
                                        // 2
                                        let groceryItem = nil
                                        //Users/gauravsharma/Desktop/Pictures for CS/project-3/Test/Test/EventViewController.swift/ 3
                                        let groceryItemRef = self.ref.child(text.lowercased())
                                        
                                        // 4
                                        groceryItemRef.setValue(groceryItem.toAnyObject())
        }*/


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

}
