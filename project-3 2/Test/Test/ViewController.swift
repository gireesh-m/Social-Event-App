//
//  ViewController.swift
//  Test
//
//  Created by Gireesh Mahajan on 2/10/17.
//  Copyright © 2017 Gireesh Mahajan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase



class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let ref = FIRDatabase.database().reference(withPath: "Users")
    let uid = FIRAuth.auth()?.currentUser?.uid
    
    var gradientLayer: CAGradientLayer!
    
    @IBOutlet weak var userIDLabel: UILabel!
    
    @IBAction func loadImageButtonTapped(_ sender: UIButton) {
        
        /*imagePicker.allowsEditing = false
         imagePicker.sourceType = .photoLibrary
         
         present(imagePicker, animated: true, completion: nil)*/
        
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBOutlet var userImage: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        ref.child(uid!).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if (snapshot.exists()) {
                let value = snapshot.value as? String
                self.userIDLabel.text = value
            } else {
                print("nologIn")
                print(self.uid!)
                self.userIDLabel.text = "you aren't logged in!"
            }
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        ref.child(uid!).child("photo").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if (snapshot.exists()) {
                let photoData = snapshot.value as! String
                print(photoData)
                let dataDecoded : Data = Data(base64Encoded: photoData, options: .ignoreUnknownCharacters)!
                let decodedimage = UIImage(data: dataDecoded)
                self.userImage.image = decodedimage
            } else {
                print("snapshot no exist1234")
            }
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        // Do any additional setup after loading the view, typically from a nib.
        // sup scrub
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func returnToHome(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Storyboard2", bundle: nil)
        let logScreen = storyboard.instantiateViewController(withIdentifier: "mapView")
        self.present(logScreen, animated: true, completion: nil)
    }
    
    @IBAction func showFriendsPage(_ sender: Any) {
        let storyboard = UIStoryboard(name: "friends", bundle: nil)
        let friendsPage = storyboard.instantiateViewController(withIdentifier: "friendMainPage")
        //let navigationController = UINavigationController(rootViewController: vc)
        present(friendsPage, animated: true, completion: nil)
        
    }
    
    /*private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
     /* if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
     userImage.image = pickedImage
     }*/
     
     
     // dismiss(animated: true, completion: nil)
     
     if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
     userImage.image = image
     } else{
     print("Something went wrong")
     }
     
     dismiss(animated: true, completion: nil)
     }*/
    
    
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        userImage.contentMode = .scaleAspectFit //3
        userImage.image = chosenImage //4
        dismiss(animated:true, completion: nil) //5
        let imageData:NSData = UIImagePNGRepresentation(userImage.image!)! as NSData
        let strBase64 = imageData.base64EncodedString()
        //self.ref.child(uid!).setValue(["photo": strBase64]) we can't actually upload the image to firebase because it is too large
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
    
}

