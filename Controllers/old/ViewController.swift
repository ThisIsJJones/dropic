//
//  ViewController.swift
//  Dropic
//
//  Created by Jordan Jones on 6/5/18.
//  Copyright © 2018 Jordan Jones. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {

    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var labell:UILabel!
    
    @IBOutlet weak var distanceAway:UILabel!
    
    let host = "169.254.206.172";
    
    var userToSendTo:String = ""
    
//    var locationManager:CLLocationManager = CLLocationManager()
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.requestWhenInUseAuthorization()
        return _locationManager
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        print("getting location");
        locationManager.requestLocation();
        
        // Do any additional setup after loading the view, typically from a nib.
//        labell.text = "\(locationManager.monitoredRegions.count)"
        
//        let re:CLCircularRegion = locationManager.monitoredRegions.first as! CLCircularRegion
//        let dis = CLLocationCoordinate2D.
//        distanceAway.text = "\()"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePhoto(sender: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        performSegue(withIdentifier: "showFriends", sender: self);
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        locationManager.requestLocation();
    }
    
    func  locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("METHOD WAS CALLED")
        if locations.count > 0 {
            if let location:CLLocation = locations[0]{
                print("location")
                // Grab all nearby media
                grabNearbyMedia(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude);
                //
                
                
//            let latCoordinate = location.coordinate.latitude
//            let longCoordinate = location.coordinate.longitude
//
//                let imageData:[UInt8] = [UInt8](UIImageJPEGRepresentation(imageView.image!, 0.9)!)
//
//                var landmark:Landmark = Landmark(bytes: imageData, longitude: Double(longCoordinate), latitude: Double(latCoordinate));
//
//                uploadImage(landmark: landmark);
            }
        }else{
            print("Locations empty")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        labell.text = "WE CAPTURED THE BEEOTCH \(region.identifier)"
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        labell.text = "yo man we left"
    }
    
    
     func uploadImage(landmark:Landmark) {
        var request:URLRequest = URLRequest(url: URL(string: "http://192.168.1.2:8080/upload/\(userToSendTo)")!)
        request.httpMethod = "POST"
        
        print("ENCODING LANDMARK");
        let landmarkObject: [String: Any] = ["bytes": landmark.bytes,
                                           "longitude": landmark.longitude, "latitude":landmark.latitude]
        let json = try! JSONSerialization.data(withJSONObject: landmarkObject)

        print("ENCODED");
        
        
        request.httpBody = json
        request.setValue(" application/json; charset=utf-8", forHTTPHeaderField:"Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("We DONE FUCKED UP");
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            
            
        }
        
        task.resume()
        
    }
    
    func grabNearbyMedia(latitude: Double, longitude: Double) {
        var request:URLRequest = URLRequest(url: URL(string: "http://\(host):8080/media/getNearby/1/\(latitude)/\(longitude)")!)
        request.httpMethod = "GET"
        print(latitude)
        print(longitude)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("We DONE FUCKED UP");
                print(error?.localizedDescription ?? "No data")
                return
            }
        }
        
        task.resume()
    }


}

