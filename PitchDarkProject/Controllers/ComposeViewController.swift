//
//  ComposeViewController.swift
//  Instagram
//
//  Created by Sanaz Khosravi on 10/1/18.
//  Copyright © 2018 GirlsWhoCode. All rights reserved.
//

import UIKit
import MBProgressHUD
import MapKit

class ComposeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate {
    
    
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(latitude)")!
        let lon: Double = Double("\(longitude)")!
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality!
                    }
                    self.locationLabel.text = addressString
                }else{
                    self.locationLabel.text = "\(latitude) " + "\(longitude)"
                }
        })
    }
    
    
    @IBAction func shareButtonAction(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        Post.postUserImage(image: imageFrame.image, withCaption: captionText.text, capturedLocation: locationLabel.text ,withCompletion: {{ (uploadSuccess : Bool, error : Error?) in
            if uploadSuccess {
                MBProgressHUD.hide(for: self.view, animated: true)
                print("posted successfully")
                self.performSegue(withIdentifier: "postedPic", sender: nil)
                
            }else if let error = error {
                print(error.localizedDescription)
                MBProgressHUD.hide(for: self.view, animated: true)
                
            }
            }}())
    }
    
    
    @IBOutlet var imageFrame: UIImageView!
    @IBOutlet var captionText: UITextField!
    @IBOutlet var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageFrame.isUserInteractionEnabled = true
        locationLabel.text = "No location set"
    }
    
    @IBAction func handlePan(recognizer:UITapGestureRecognizer) {
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
        imageFrame.image = editedImage
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tagSegue" {
            let locationsVC = segue.destination as! LocationsViewController
            locationsVC.delegate = self
        }
    }
    
    
}

