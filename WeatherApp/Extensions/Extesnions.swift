//
//  Double.swift
//  WeatherApp
//
//  Created by Daniil KOZYR on 7/17/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    func converterFromFtoC() -> Int {
        return Int((5.0 / 9.0 * (self - 32.0)).rounded())
    }
}

extension UIView {
    
    func setGradientColor(colorOne: UIColor, colorTwo: UIColor) {
        let gradient = CAGradientLayer()
        
        gradient.frame = bounds
        gradient.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        layer.insertSublayer(gradient, at: 0)
    }
    
}


extension UIColor {
    struct Personal {
        static let darkBlue = UIColor(red: 63/255, green: 43/255, blue: 150/255, alpha: 1)
        static let lightBlue = UIColor(red: 0/255, green: 90/255, blue: 167/255, alpha: 1)
    }
}
