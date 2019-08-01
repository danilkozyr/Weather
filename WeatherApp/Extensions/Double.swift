//
//  Double.swift
//  WeatherApp
//
//  Created by Daniil KOZYR on 7/17/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import Foundation

extension Double {
    func converterFromFtoC() -> Int {
        return Int((5.0 / 9.0 * (self - 32.0)).rounded())
    }
}
