//
//  MediaMapAnnotation.swift
//  Dropic
//
//  Created by Jordan Jones on 10/31/19.
//  Copyright © 2019 Jordan Jones. All rights reserved.
//

import Foundation
import MapKit

class MediaMapAnnotation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String?
    let discipline: String
    let isNearby: Bool
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D, isNearby: Bool) {
        self.title = title;
        self.locationName = locationName;
        self.discipline = discipline;
        self.coordinate = coordinate;
        self.isNearby = isNearby;
        super.init();
    }
    
    // markerTintColor for disciplines: Sculpture, Plaque, Mural, Monument, other
    var markerTintColor: UIColor  {
        return isNearby ? .red : .gray
    }
    
    var subtitle: String? {
        return locationName;
    }
}
