//
//  LocationDownloader.swift
//  WeatherApp
//
//  Created by Daniil KOZYR on 7/17/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import Foundation
import RecastAI

enum DownloaderError: Error {
    case invalidCity
    case noInternetConnection
    case noConnectionWithAPI
}

class LocationDownloader {
    private let recastAIToken = "356368f0ae5b0481a0229d25c83d9bf3"
    private var recastClient: RecastAIClient?
    
    init() {
        self.recastClient = RecastAIClient(token: recastAIToken, language: "en")
    }
    
    func requestLocation(city: String, completion: @escaping (Result<City, DownloaderError>) -> Void) {
        self.recastClient?.textRequest(city, successHandler: { response in
            let location = self.getLocation(response: response)
            if location == nil {
                completion(.failure(DownloaderError.invalidCity))
                return
            }
            completion(.success(location!))
        }, failureHandle: { error in
            completion(.failure(DownloaderError.noInternetConnection))
        })
    }
    
    private func getLocation(response: Response) -> City? {
        var city: City
        
        guard let arr = response.entities!["location"] as? [NSDictionary] else {
            return nil
        }
        
        guard var cityName = arr[0].value(forKey: "raw") as? String else { return nil }
        if let countryState = arr[0].value(forKey: "country") as? String {
            cityName += ", \(countryState.uppercased())"
        }
        guard let latitude = arr[0].value(forKey: "lat") as? NSNumber else { return nil }
        guard let longitude = arr[0].value(forKey: "lng") as? NSNumber else { return nil }

        city = City(city: cityName, longitude: longitude.doubleValue, latitude: latitude.doubleValue)
                
        return city
    }
}

