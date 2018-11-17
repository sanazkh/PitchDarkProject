//
//  ViewController.swift
//  Instagram
//
//  Created by Sanaz Khosravi on 10/1/18.
//  Copyright © 2018 GirlsWhoCode. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class LoginViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var passWord: UITextField!
    @IBOutlet var userName: UITextField!
    @IBOutlet var profilePicImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func imageViewClick(_ sender: UITapGestureRecognizer) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        //   let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        profilePicImageView.image = editedImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        let newUser = PFUser()
        newUser.username = userName.text
        newUser.password = passWord.text
        
        
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.createAlert("Login Failed!", error.localizedDescription)
            } else {
                Post.postProfileImage(image: self.profilePicImageView.image, author: newUser, caption: "profilePicture" , withCompletion: {{ (uploadSuccess : Bool, error : Error?) in
                    if uploadSuccess {
                        print("posted successfully")
                        
                    }else if let error = error {
                        print(error.localizedDescription)
                    }
                    }}())
                MBProgressHUD.hide(for: self.view, animated: true)
                self.createAlert("Success!", "User Registered successfully")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        if !(self.userName.text?.isEmpty)! && !(self.passWord.text?.isEmpty)!{
            MBProgressHUD.showAdded(to: self.view, animated: true)
            loginUser(self.userName.text!, self.passWord.text!)
        }else{
            createAlert("Required Fields!", "Please fill in the blanks.")
        }
    }
    
    func loginUser(_ username : String, _ password : String) {
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.createAlert("Login Failed!", error.localizedDescription)
            } else {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    
    func createAlert(_ titleT : String, _ messageT : String){
        let alert = UIAlertController(title: titleT, message:
            messageT, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}



