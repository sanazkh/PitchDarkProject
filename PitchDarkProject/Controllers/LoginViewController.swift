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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        //  var titleText = title
        //  var messageText = message
        let alert = UIAlertController(title: titleT, message:
            messageT, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}



