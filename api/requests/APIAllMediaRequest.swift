//
//  APIAllMediaRequest.swift
//  Dropic
//
//  Created by Jordan Jones on 11/9/19.
//  Copyright © 2019 Jordan Jones. All rights reserved.
//

import Foundation

struct APIAllMediaRequest: Codable {
    let userId: Int
    let latitude: String
    let longitude: String
}

extension APIAllMediaRequest: APIEndpoint {
    func endpoint() -> String {
        return "/media/getNearby/\(userId)/\(latitude)/\(longitude)"
    }
    
    func dispatch(
        onSuccess successHandler: @escaping ((_: [NearbyMediaResponse]) -> Void),
        onFailure failureHandler: @escaping ((_: APIRequest.ErrorResponse?, _: Error) -> Void)) {

        APIRequest.get(
            request: self,
            nil as APIAllMediaRequest?,
            onSuccess: successHandler,
            onError: failureHandler)
    }
}
