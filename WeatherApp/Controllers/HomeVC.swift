//
//  ViewController.swift
//  WeatherApp
//
//  Created by Daniil KOZYR on 7/17/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    private var locationDownloader: LocationDownloader?
    private var weatherDownloader: WeatherDownloader?
    
    @IBOutlet private weak var activityIndicatior: UIActivityIndicatorView!
    @IBOutlet private weak var inputCity: UITextField!
    
    @IBAction private func sendRequest(_ sender: Any) {
        if let city = inputCity.text, !city.isEmpty {
            connectionInternet(isLoading: true)
            locationDownloader?.requestLocation(city: inputCity.text!) { (result) in
                switch result {
                case .success(let city):
                    self.weatherDownloader?.makeRequest(location: city, completion: { (result) in
                        switch result {
                        case .success(let result):
                            self.answerLabel.text = "In \(city.city) is \(result)"
                        case .failure(let error):
                            print(error)
                        }
                    })
                case .failure(let error):
                    switch error {
                    case .invalidCity:
                        self.answerLabel.text = "Invalid City"
                    case .noInternetConnection:
                        self.answerLabel.text = "Check Internet connection"
                    case .noConnectionWithAPI:
                        self.answerLabel.text = "Severs are busy. Try again!"
                    }
                }
                self.connectionInternet(isLoading: false)
            }
        } else {
            answerLabel.text = "Enter any city!"
        }
    }
    
    @IBOutlet weak var answerLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatior.isHidden = true
        locationDownloader = LocationDownloader()
        weatherDownloader = WeatherDownloader()
    }
    
    private func connectionInternet(isLoading: Bool) {
        if isLoading {
            activityIndicatior.isHidden = false
            activityIndicatior.startAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        } else {
            activityIndicatior.isHidden = true
            activityIndicatior.stopAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}



