//
//  NearbyMediaResponse.swift
//  Dropic
//
//  Created by Jordan Jones on 10/31/19.
//  Copyright © 2019 Jordan Jones. All rights reserved.
//

import Foundation

class NearbyMediaResponse: Codable {
    var mediaId: Int32
    var mediaLocationId: Int32
    var longitude: Double
    var latitude: Double
    var name: String
    var isNearby: Bool
}
