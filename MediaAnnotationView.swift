//
//  MediaAnnotationView.swift
//  Dropic
//
//  Created by Jordan Jones on 11/4/19.
//  Copyright © 2019 Jordan Jones. All rights reserved.
//

import Foundation
import MapKit

class MediaMarkerAnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            // 1
            guard let artwork = newValue as? MediaMapAnnotation else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            // 2
            markerTintColor = artwork.markerTintColor
            glyphText = String(artwork.discipline.first!)
        }
    }
}
