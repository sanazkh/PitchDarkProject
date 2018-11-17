//
//  DetailViewController.swift
//  Instagram
//
//  Created by Sanaz Khosravi on 10/3/18.
//  Copyright © 2018 GirlsWhoCode. All rights reserved.
//

import UIKit
import Parse
import MapKit

class DetailViewController: UIViewController {
    
    
    
    @IBAction func shareButton(_ sender: Any) {
        let text = detailCaptionLabel.text
        let image = UIImagePNGRepresentation(detailImageView.image!)
        let shareAll = [text , image!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    @IBOutlet var timeStampLabel: UILabel!
    @IBOutlet var detailCaptionLabel: UILabel!
    @IBOutlet var detailImageView: UIImageView!
    @IBOutlet var mainForecastLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var ForecastDescLabel: UILabel!
    
    @IBOutlet var myScrollView: UIScrollView!
    var post : Post?
    
    @IBAction func getDirectionButton(_ sender: Any) {
        let address = locationLabel.text
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address!) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    
                    return
            }
            
            if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
                UIApplication.shared.openURL(NSURL(string:
                    "comgooglemaps://?saddr=&daddr=\(location.coordinate.latitude),\(location.coordinate.longitude)&directionsmode=driving")! as URL)
                
            } else {
                NSLog("Can't use comgooglemaps://");
                let coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
                let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
                mapItem.name = self.locationLabel.text
                mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
            }
        }
        
    }
    
    
    @IBOutlet var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myScrollView.isScrollEnabled = true
        myScrollView.contentSize = CGSize(width: myScrollView.contentSize.width, height: 1000)

        self.detailImageView.image = UIImage(named: "image_placeholder.png")!
        loadPostDetail()
        getWeather()
        getWeatherData()
    }
    
    func loadPostDetail() {
        if let imageFile : PFFile = post?.media {
            imageFile.getDataInBackground { (data, error) in
                if (error != nil) {
                    self.detailImageView.image = UIImage(named: "image_placeholder.png")!
                }
                else {
                    self.detailImageView.image = UIImage(data: data!)
                }
            }
            if (post?.caption == ""){
                detailCaptionLabel.text = "No caption is set for this post."
            }else{
                detailCaptionLabel.text = post?.caption
            }
            timeStampLabel.text = formatDateString((post?.createdAt)!)
            locationLabel.text = post?.location
        }
    }
    
    func formatDateString(_ date : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        let result = formatter.string(from: date)
        return result
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getWeather() {
        
        let address = locationLabel.text
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address!) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    
                    return
            }
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            let session = URLSession.shared
            let weatherURL = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&units=imperial&APPID=b73655145bb7a29af554f932f777831e")!
            print(weatherURL)
            let dataTask = session.dataTask(with: weatherURL) {
                (data: Data?, response: URLResponse?, error: Error?) in
                if let error = error {
                    print("Error:\n\(error)")
                } else {
                    if let data = data {
                        let dataString = String(data: data, encoding: String.Encoding.utf8)
                        print("All the weather data:\n\(dataString!)")
                        if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                            if let mainDictionary = jsonObj!.value(forKey: "main") as? NSDictionary {
                                if let temperature = mainDictionary.value(forKey: "temp") {
                                    DispatchQueue.main.async {
                                        self.tempLabel.text = "\(temperature)°F"
                                    }
                                }
                                if let humidity = mainDictionary.value(forKey: "humidity") {
                                    DispatchQueue.main.async {
                                        self.humidityLabel.text = "\(humidity)% humidity"
                                    }
                                }
                            } else {
                                print("Error: unable to find temperature in dictionary")
                            }
                        } else {
                            print("Error: unable to convert json data")
                        }
                    } else {
                        print("Error: did not receive data")
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func getWeatherData(){
        let address = locationLabel.text
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address!) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    
                    return
            }
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&units=imperial&APPID=b73655145bb7a29af554f932f777831e")!
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let dataResponse = data,
                    error == nil else {
                        print(error?.localizedDescription ?? "Response Error")
                        return }
                do {
                    // data we are getting from network request
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Welcome.self, from: data!)
                    DispatchQueue.main.async {
                        self.mainForecastLabel.text = response.weather[0].main
                        self.ForecastDescLabel.text = response.weather[0].description
                    }
                } catch { print(error) }
            }
            task.resume()
        }
    }
    
}

