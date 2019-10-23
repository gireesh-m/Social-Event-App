//
//  HomeScreen.swift
//  Test
//
//  Created by Brandon Zhang on 3/17/17.
//  Copyright © 2017 Gireesh Mahajan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeScreen: UIViewController {
    
    var gradientLayer: CAGradientLayer!

    @IBOutlet weak var emailLogin: UITextField!
    
    @IBOutlet weak var pinLogin: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRAuth.auth()!.addStateDidChangeListener(){auth, user in
            if user != nil{
                let storyboard = UIStoryboard(name: "Storyboard2", bundle: nil)
                let logScreen = storyboard.instantiateViewController(withIdentifier: "mapView")
                self.present(logScreen, animated: true, completion: nil)
            }
        }
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
    
    @IBAction func loginClick(_ sender: Any) {
        if self.emailLogin.text == "" || self.pinLogin.text == ""{
            let alertController = UIAlertController(title: "Error", message: "Please fill in an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else{
            
            FIRAuth.auth()?.signIn(withEmail: self.emailLogin.text!, password: self.pinLogin.text!){ (user, error) in
                if(error == nil){
                    print("you have logged in beautifully")
                    
                    let storyboard = UIStoryboard(name: "Storyboard2", bundle: nil)
                    let logScreen = storyboard.instantiateViewController(withIdentifier: "mapView")
                    self.present(logScreen, animated: true, completion: nil)
                    
                }
                else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }

    

}
