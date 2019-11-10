//
//  MediaLocationViewController.swift
//  Dropic
//
//  Created by Jordan Jones on 11/5/19.
//  Copyright © 2019 Jordan Jones. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MediaLocationViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapViewVar: MKMapView!
    
    var mediaName: String = "";
    var message: String = "";
    var isRandomDrop: Bool = false;
    let regionRadius: CLLocationDistance = 8047 // 5 miles
    let host = "169.254.178.238";
    var image: UIImage!;

    var potentialAnnotation: MKPointAnnotation?;
    
    var collectionOfAnnotations: [MKPointAnnotation] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapViewVar.delegate = self
         self.setMapview()
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
       
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapViewVar.setRegion(coordinateRegion, animated: true)
        
        potentialAnnotation = MKPointAnnotation()
        potentialAnnotation!.title = mediaName
        potentialAnnotation!.coordinate = CLLocationCoordinate2D(latitude: 44.848742, longitude: -91.569357)
        mapViewVar.addAnnotation(potentialAnnotation!)
        collectionOfAnnotations.append(potentialAnnotation!)
    }
    
    func setMapview(){
        
        let circleAroundUser = MKCircle(center: CLLocationCoordinate2D(latitude: 44.848742, longitude: -91.569357), radius: 5047);
        self.mapViewVar.add(circleAroundUser)
        
        self.centerMapOnLocation(location: CLLocation(latitude: 44.848742, longitude: -91.569357))
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
//        lpgr.minimumPressDuration = 0.5
//        lpgr.delaysTouchesBegan = true
//        lpgr.delegate = self as! UIGestureRecognizerDelegate
        self.mapViewVar.addGestureRecognizer(lpgr)
    }
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        let touchLocation = gestureReconizer.location(in: mapViewVar)
        let locationCoordinate = mapViewVar.convert(touchLocation,toCoordinateFrom: mapViewVar)
//        print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
        if gestureReconizer.state == UIGestureRecognizerState.changed {
            mapViewVar.removeAnnotation(potentialAnnotation!)
            let tappedLocation = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
            
            let userLocation = CLLocation(latitude: 44.848742, longitude: -91.569357)
            
            if ( tappedLocation.distance(from: userLocation) < 5047) {
                potentialAnnotation!.coordinate = locationCoordinate
            } else {
                let bearing = getBearingBetweenTwoPoints(point1: userLocation, point2: tappedLocation)
                potentialAnnotation!.coordinate = getNearestCoordinateInsideCircle(bearing: bearing, distanceMeters: 5047, origin: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude));
            }
            mapViewVar.addAnnotation(potentialAnnotation!)

            return
        }
        
        if gestureReconizer.state == UIGestureRecognizerState.ended {
            collectionOfAnnotations.append(potentialAnnotation!)
            return
        }
        
        if gestureReconizer.state == UIGestureRecognizerState.began {
            potentialAnnotation = MKPointAnnotation()
            potentialAnnotation!.title = "Created Drop"
            
            let tappedLocation = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
            
            let userLocation = CLLocation(latitude: 44.848742, longitude: -91.569357)
            
            if ( tappedLocation.distance(from: userLocation) < 5047) {
                potentialAnnotation!.coordinate = locationCoordinate
            } else {
                let bearing = getBearingBetweenTwoPoints(point1: userLocation, point2: tappedLocation)
                potentialAnnotation!.coordinate = getNearestCoordinateInsideCircle(bearing: bearing, distanceMeters: 5047, origin: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude));
            }
            mapViewVar.addAnnotation(potentialAnnotation!)

            return
        }
    }
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
    func getBearingBetweenTwoPoints(point1 : CLLocation, point2 : CLLocation) -> Double {
        
        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)
        
        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return radiansBearing
    }
    
    func getNearestCoordinateInsideCircle(bearing: Double, distanceMeters: Double, origin: CLLocationCoordinate2D) -> CLLocationCoordinate2D{
        let distRadians = distanceMeters / (6372797.6) // earth radius in meters
        
        let lat1 = origin.latitude * M_PI / 180
        let lon1 = origin.longitude * M_PI / 180
        
        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(bearing))
        let lon2 = lon1 + atan2(sin(bearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
        
        return CLLocationCoordinate2D(latitude: lat2 * 180 / M_PI, longitude: lon2 * 180 / M_PI)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapViewVar.dequeueReusableAnnotationView(withIdentifier: "createdDrop")
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "createdDrop")
            pinView!.canShowCallout = true;
        } else {
            pinView!.annotation = annotation;
        }
        
        pinView!.isDraggable = true;
        pinView!.tintColor = UIColor.red;
        
       
        return pinView;
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        switch newState {
        case .starting:
                view.dragState = .dragging
        case .ending, .canceling:
            
            // if annotation is outside of region, put it back in
            let annotationLocation = CLLocation(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!)
            
            let userLocation = CLLocation(latitude: 44.848742, longitude: -91.569357)
            
            if ( annotationLocation.distance(from: userLocation) > 5047) {
                let bearing = getBearingBetweenTwoPoints(point1: userLocation, point2: annotationLocation)
                let anno = view.annotation as! MKPointAnnotation
                anno.coordinate = getNearestCoordinateInsideCircle(bearing: bearing, distanceMeters: 5047, origin: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude));
            }
            view.dragState = .none
        default: break
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            var circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.black
            circle.fillColor = UIColor.gray
            circle.alpha = 0.2
            return circle
        }
        return MKOverlayRenderer()
    }
    
    @IBAction func backToDropDetails(_ sender: Any) {
        dismiss(animated: true);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing")
        
    }
    
    
    
    
     @IBAction func dropMediaAtLocation() {
        
        var mediaDropDetails: [[String: Any]] = []
        var locations: [String: Any] = [:]
        var recipientsAndPickupQuantities: [[String: Any]] = []
        let collectionOfRecipientsQuantities: [(id: Any, qty: Any)] = [(id: 1, qty: 1)]
        
        for location in collectionOfAnnotations {
            locations["longitude"] = location.coordinate.longitude
            locations["latitude"] = location.coordinate.latitude
            recipientsAndPickupQuantities = []
            for recipQuant in collectionOfRecipientsQuantities {
                recipientsAndPickupQuantities.append(["recipientId": recipQuant.id, "quantityToPickup": recipQuant.qty])
            }
            
            mediaDropDetails.append(["dropLocation" : locations, "recipientsAndPickupQuantities": recipientsAndPickupQuantities]);
        }
        
//        var imageData = UIImagePNGRepresentation(image)
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        
        let mediaDropRequest: [String: Any?] = [
            "userId": 1,
            "nameOfMedia": mediaName,
            "message": "",
            "mediaBytes": [UInt8](imageData!),
            "droppedDate": nil,
            "pickupDateDeadline": nil,
            "isRandomDrop": isRandomDrop,
            "mediaDropDetails": mediaDropDetails
        ]
    
        let decoder = JSONDecoder()

        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: mediaDropDetails, options: .fragmentsAllowed)
            let jsonMediaDropDetails = try decoder.decode([MediaDropDetails].self, from: jsonData)
            print(jsonData)
            
            APIDropMediaRequest(userId: 1, nameOfMedia: mediaName, message: "", mediaBytes: [UInt8](imageData!), isRandomDrop: isRandomDrop, mediaDropDetails: jsonMediaDropDetails)
                         .dispatch(onSuccess: { (response) in
                                 print("succces drop")
                             print(response)

                             }, onFailure: { (errorResponse, error) in
                             print("ERROR dropping")

                             })

            collectionOfAnnotations = [];
            navigationController?.popToRootViewController(animated: false)
//            tabBarController?.selectedIndex = 0
//            tabBarController?.selectedViewController = tabBarController?.viewControllers?[0]
        } catch {
            print("error decoding")
            print(error.localizedDescription)
        }
//        task.resume()
        
    }
    
}
