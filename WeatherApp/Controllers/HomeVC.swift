//
//  ViewController.swift
//  WeatherApp
//
//  Created by Daniil KOZYR on 7/17/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

// TODO: Date

import UIKit

class HomeVC: UIViewController {
    
    private var locationDownloader = LocationDownloader()
    private var weatherDownloader = WeatherDownloader()
    
    @IBOutlet private weak var city: UILabel!
    @IBOutlet private weak var temperature: UILabel!
    @IBOutlet private weak var viewToPop: UIStackView!
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var activityIndicatior: UIActivityIndicatorView!
    @IBOutlet private weak var inputCity: UITextField! {
        didSet {
            inputCity.attributedPlaceholder = NSAttributedString(string: "Enter city here...",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            inputCity.delegate = self
        }
    }
    @IBOutlet weak var date: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientColor(colorOne: UIColor.Personal.darkBlue, colorTwo: UIColor.Personal.lightBlue)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        activityIndicatior.isHidden = true
        downloadWeather(in: "Kyiv")
    }
    
    private func changeImage(weather: String?) {
        if weather == "clear-day" {
            icon.image = UIImage(named: "day")
        } else if weather == "clear-night" {
            icon.image = UIImage(named: "night")
        } else if weather == "rain" {
            icon.image = UIImage(named: "rain")
        } else if weather == "snow" {
            icon.image = UIImage(named: "snow")
        } else if weather == "wind" {
            icon.image = UIImage(named: "wind")
        } else if weather == "fog" {
            icon.image = UIImage(named: "fog")
        } else if weather == "cloudy" || weather == "partly-cloudy-day" {
            icon.image = UIImage(named: "cloudy")
        } else if weather == "partly-cloudy-night" {
            icon.image = UIImage(named: "cloudy-night")
        } else {
            icon.image = UIImage(named: "default")
        }
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                UIView.animate(withDuration: 2, animations: {
                    self.icon.alpha = 0.1
                })
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
            UIView.animate(withDuration: 2, animations: {
                self.view.frame.origin.y = 0
                self.icon.alpha = 1
            })
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
    
    private func dateFormatter(from: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE | MMMM d yyyy | h:mm"
        let dateString = dateFormatter.string(from: from)
        return dateString
    }
    
    private func downloadWeather(in city: String) {
        let dateNow = Date()
        date.text = dateFormatter(from: dateNow)
        connectionInternet(isLoading: true)
        locationDownloader.requestLocation(city: city) { (result) in
            switch result {
            case .success(let city):
                self.weatherDownloader.makeRequest(location: city, completion: { (result) in
                    switch result {
                    case .success(let result):
                        self.city.text = city.city
                        self.temperature.text = "\(result.tmp)°C, \(result.summary)"
                        self.changeImage(weather: result.icon)
                    case .failure(let error):
                        print(error)
                    }
                })
            case .failure(let error):
                switch error {
                case .invalidCity:
                    self.city.text = "Invalid City"
                case .noInternetConnection:
                    self.city.text = "Check Internet connection"
                case .noConnectionWithAPI:
                    self.city.text = "Severs are busy. Try again!"
                }
            }
            self.connectionInternet(isLoading: false)
        }
    }
    
    
}



extension HomeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputCity.resignFirstResponder()
        if let city = inputCity.text, !city.isEmpty {
            downloadWeather(in: city)
        } else {
            city.text = "Enter any city!"
        }
        return true
    }
}


