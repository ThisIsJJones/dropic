//
//  APIDropMediaRequest.swift
//  Dropic
//
//  Created by Jordan Jones on 11/9/19.
//  Copyright © 2019 Jordan Jones. All rights reserved.
//

import Foundation

struct APIDropMediaRequest: Codable {
    let userId: Int
    let nameOfMedia: String
    let message: String
    let mediaBytes: [UInt8]
//    let droppedDate: Any?
//    let pickupDateDeadline: Any?
    let isRandomDrop: Bool
    let mediaDropDetails: [MediaDropDetails]
    
//    init(userId: Int, nameOfMedia: String, message: String, mediaBytes: [UInt8], isRandomDrop: Bool, mediaDropDetails: [MediaDropDetails]){
//        
//        self.userId = userId;
//        self.nameOfMedia = nameOfMedia;
//        self.message = message;
//        self.mediaBytes = mediaBytes;
//        self.isRandomDrop = isRandomDrop;
//        self.mediaDropDetails = mediaDropDetails;
//    }
}

class MediaDropDetails: Codable {
    let dropLocation: Location
    let recipientsAndPickupQuantities: [RecipientsAndQuantities]
}

class RecipientsAndQuantities: Codable {
    let recipientId: Int
    let quantityToPickup: Int
}

class Location: Codable {
    let longitude: Double
    let latitude: Double
}

extension APIDropMediaRequest: APIEndpoint {
    func endpoint() -> String {
        return "/media/drop"
    }
    
    func dispatch(
        onSuccess successHandler: @escaping ((_: Bool) -> Void),
        onFailure failureHandler: @escaping ((_: APIRequest.ErrorResponse?, _: Error) -> Void)) {

        APIRequest.post(
            request: self,
            onSuccess: successHandler,
            onError: failureHandler)
    }
}
