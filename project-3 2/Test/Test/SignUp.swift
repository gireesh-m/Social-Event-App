//
//  SignUp.swift
//  Test
//
//  Created by Brandon Zhang on 3/17/17.
//  Copyright © 2017 Gireesh Mahajan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUp: UIViewController {
    var gradientLayer: CAGradientLayer!
    
    @IBOutlet weak var emailSignUp: UITextField!

    @IBOutlet weak var pinSignUp: UITextField!
    
    @IBOutlet var nameSignUp: UITextField!
    
    @IBOutlet var descriptionSignUp: UITextField!
    
    let ref = FIRDatabase.database().reference(withPath: "Users")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createGradientLayer()
    }
    
    func createGradientLayer(){
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.orange.cgColor, UIColor.yellow.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    @IBAction func createAccount(_ sender: Any) {
        if emailSignUp.text == ""{
            let alertController = UIAlertController(title: "Error", message: "Please enter an email", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        }
        else{
            FIRAuth.auth()?.createUser(withEmail: emailSignUp.text!, password: pinSignUp.text!){ (user, error) in
                if error == nil{
                    
                    let uid = FIRAuth.auth()?.currentUser?.uid
                    if (self.descriptionSignUp.text == "" || self.nameSignUp.text == "") {
                        let alertController = UIAlertController(title: "Error", message: "Please enter a description and/or name", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        let user = User(name: self.nameSignUp.text!, key: uid!, description: self.descriptionSignUp.text!, rating: "0", photoData: "iVBORw0KGgoAAAANSUhEUgAAAc4AAAHOCAIAAACehH7nAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2hpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDowNTgwMTE3NDA3MjA2ODExODA4MzkyM0JERUMzODk4NCIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDo3RjM0Mzc5MUE3NDkxMUUyQjNDRTg5RDNFQjJEOEE0QSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDo3RjM0Mzc5MEE3NDkxMUUyQjNDRTg5RDNFQjJEOEE0QSIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M2IChNYWNpbnRvc2gpIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6MDc4MDExNzQwNzIwNjgxMTgwODM5MjNCREVDMzg5ODQiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6MDU4MDExNzQwNzIwNjgxMTgwODM5MjNCREVDMzg5ODQiLz4gPC9yZGY6RGVzY3Jp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")
                        let eventItemRef = self.ref.child(uid!)
                        eventItemRef.setValue(user.toAnyObject())
                    
                        print("You have successfully signed up!")
                    
                        let screen = self.storyboard?.instantiateViewController(withIdentifier: "homePage")
                    
                        self.present(screen!, animated: true, completion: nil)
                    }
                    
                }else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
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
