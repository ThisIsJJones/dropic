//
//  MapViewController.swift
//  Dropic
//
//  Created by Jordan Jones on 10/31/19.
//  Copyright © 2019 Jordan Jones. All rights reserved.
//

import Foundation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 8047 // 5 miles
    
    var lastKnownUserLocation: CLLocationCoordinate2D?
    
    var host = "169.254.178.238"
    
    var allAnnotations: [MediaMapAnnotation] = [];
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.requestWhenInUseAuthorization()
        return _locationManager
    }()
    
    
    override func viewDidLoad() {
        mapView.delegate = self

        mapView.register(MediaMarkerAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    func  locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            if let location:CLLocation = locations[0]{
                // Grab all nearby media
//
                let coord: CLLocation = CLLocation(latitude: 44.848742, longitude: -91.569357);
                
                if (lastKnownUserLocation != nil) {
                    if (lastKnownUserLocation!.latitude != coord.coordinate.latitude ||
                        lastKnownUserLocation!.longitude != coord.coordinate.longitude) {
                        centerMapOnLocation(location: coord);
                        lastKnownUserLocation = CLLocationCoordinate2D(latitude: 44.848742, longitude: -91.569357)
                    }
                } else {
                    centerMapOnLocation(location: coord);
                    lastKnownUserLocation = CLLocationCoordinate2D(latitude: 44.848742, longitude: -91.569357)
                }
//                 grabNearbyMedia(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude);
                
                grabNearbyMedia(latitude: 44.848742, longitude: -91.569357);
            }
        }else{
            print("Locations empty")
        }
    }
    
    func grabNearbyMedia(latitude: Double, longitude: Double) {

        APIAllMediaRequest(userId: 1, latitude: "\(latitude)", longitude: "\(longitude)")
        .dispatch(onSuccess: { (successResponse) in
                print("succces")
            print(successResponse)
            self.addAllMediaLocationToMap(nearbyMedia: successResponse);

            }, onFailure: { (errorResponse, error) in
            print("ERROR")

            })
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        locationManager.requestLocation()
    }
    
    func addAllMediaLocationToMap(nearbyMedia: [NearbyMediaResponse]) {
        mapView.removeAnnotations(allAnnotations);
        let decoder = JSONDecoder()
        do {
            
            var annotations: [MediaMapAnnotation] = [];
            for media in nearbyMedia {
                var mediaAnnotation = MediaMapAnnotation(title: media.name, locationName: media.name, discipline: "\(media.mediaId)", coordinate: CLLocationCoordinate2D(latitude: media.latitude, longitude: media.longitude), isNearby: media.isNearby)
                annotations.append(mediaAnnotation)
            }
            allAnnotations = annotations;
            mapView.addAnnotations(annotations);
        } catch {
            print("DECODING ALL MEDIA: FAILED")
        }
    }
    @IBAction func refreshDrops(_ sender: Any) {
        locationManager.requestLocation()
    }
}

