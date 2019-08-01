//
//  WeatherDownloader.swift
//  WeatherApp
//
//  Created by Daniil KOZYR on 7/17/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import Foundation
import DarkSkyKit


class WeatherDownloader {
    private let darkSkyToken = "c70c432174c9652d6fe82ac8dfc16a11"
    private var weatherClient: DarkSkyKit?

    init() {
        self.weatherClient = DarkSkyKit(apiToken: darkSkyToken)
    }

    func makeRequest(location: City, completion: @escaping (Result<String, Error>) -> Void) {
        
        weatherClient?.current(latitude: location.latitude, longitude: location.longitude, result: { result in
            switch result {
            case .success(let forecast):
                if let current = forecast.currently {
                    let tmp = current.temperature?.converterFromFtoC()
                    completion(.success("\(tmp!)°C"))
                }
            case .failure:
                completion(.failure(DownloaderError.noConnectionWithAPI))
            }
        })
        
    }
}
