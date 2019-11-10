//
//  HttpWrapper.swift
//  Dropic
//
//  Created by Jordan Jones on 11/8/19.
//  Copyright © 2019 Jordan Jones. All rights reserved.
//

import Foundation

protocol APIEndpoint {
    func endpoint() -> String
}

class APIRequest {
    
    public static let serverAddress = "http://localhost:8080"
    
    struct ErrorResponse: Codable {
        let status: String
        let code: Int
        let message: String
    }

    enum APIError: Error {
        case invalidEndpoint
        case errorResponseDetected
        case noData
    }
    
    public static func post<R: Codable & APIEndpoint, T: Codable, E: Codable>(
        request: R,
        onSuccess: @escaping ((_: T) -> Void),
        onError: @escaping ((_: E?, _: Error) -> Void)) {

        guard var endpointRequest = self.urlRequest(from: request) else {
            onError(nil, APIError.invalidEndpoint)
            return
        }
        endpointRequest.httpMethod = "POST"
        endpointRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            endpointRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            onError(nil, error)
            return
        }

        URLSession.shared.dataTask(
            with: endpointRequest,
            completionHandler: { (data, urlResponse, error) in
                DispatchQueue.main.async {
                    self.processResponse(data, urlResponse, error, onSuccess: onSuccess, onError: onError)
                }
        }).resume()
    }
    
    public static func get<R: Codable & APIEndpoint, B: Codable, T: Codable, E: Codable>(
        request: R,
        _ body: B? = nil,
        onSuccess: @escaping ((_: T) -> Void),
        onError: @escaping ((_: E?, _: Error) -> Void)) {

        guard var endpointRequest = self.urlRequest(from: request) else {
            onError(nil, APIError.invalidEndpoint)
            return
        }
        endpointRequest.httpMethod = "GET"
        endpointRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if body != nil {
            do {
                endpointRequest.httpBody = try JSONEncoder().encode(body!)
            } catch {
                onError(nil, error)
                return
            }
        }

        URLSession.shared.dataTask(
            with: endpointRequest,
            completionHandler: { (data, urlResponse, error) in
                DispatchQueue.main.async {
                    self.processResponse(data, urlResponse, error, onSuccess: onSuccess, onError: onError)
                }
        }).resume()
    }
    
    private static func processResponse<T: Codable, E: Codable>(
        _ dataOrNil: Data?,
        _ urlResponseOrNil: URLResponse?,
        _ errorOrNil: Error?,
        onSuccess: ((_: T) -> Void),
        onError: ((_: E?, _: Error) -> Void)) {

        if let data = dataOrNil {
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                onSuccess(decodedResponse)
            } catch {
                let originalError = error

                do {
                    let errorResponse = try JSONDecoder().decode(E.self, from: data)
                    onError(errorResponse, APIError.errorResponseDetected)
                } catch {
                    onError(nil, originalError)
                }
            }
        } else {
            onError(nil, errorOrNil ?? APIError.noData)
        }
    }
    
    private static func urlRequest(from request: APIEndpoint) -> URLRequest? {
           let endpoint = request.endpoint()
           guard let endpointUrl = URL(string: "\(serverAddress)\(endpoint)") else {
               return nil
           }
        
        print("endpoint -> \(endpointUrl)" )


           var endpointRequest = URLRequest(url: endpointUrl)
           endpointRequest.addValue("application/json", forHTTPHeaderField: "Accept")
           return endpointRequest
       }
}
