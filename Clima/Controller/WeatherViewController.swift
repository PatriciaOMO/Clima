//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
	@IBOutlet weak var searchTextField: UITextField!
	
	var weatherManager = WeatherManager()
	let locationManager = CLLocationManager()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		locationManager.requestLocation()

		weatherManager.delegate = self
		searchTextField.delegate = self
	}
	
	@IBAction func locationPressed(_ sender: UIButton) {
		locationManager.requestLocation()
	}
	
}

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
	
	@IBAction func searchPressed(_ sender: UIButton) {
		// text field should report back to viewController, the delegate gives you access to new methods and shit
		searchTextField.endEditing(true)
		print(searchTextField.text!)
	}
	
	// samesies as an @IBAction for the Return / Go key in keyboard
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		searchTextField.endEditing(true)
		print(searchTextField.text!)
		return true
	}
	
	// the "should" is the system asking you if they should take that action, hence the return Bool
	// in this case it's a fail safe for searching with an empty search field "nil"
	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		if textField.text != "" {
			return true
		} else {
			textField.placeholder = "Type something"
			return false
		}
	}
	
	// once Return has been pressed, search field empties out again
	// use searchTextField.text to get weather for that city
	func textFieldDidEndEditing(_ textField: UITextField) {
		
		// getting city name and adding it to url for API
		if let city = searchTextField.text {
			weatherManager.fetchWeather(cityName: city)
		}
		searchTextField.text = ""
	}
}

// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
	
	func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
		DispatchQueue.main.async {
			self.temperatureLabel.text = weather.tempString
			self.conditionImageView.image = UIImage(systemName: weather.conditionName)
			self.cityLabel.text = weather.cityName
		}
	}
	
	func didFailWithError(error: Error) {
		print(error)
	}
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.last {
			locationManager.stopUpdatingLocation()
			let lat = location.coordinate.latitude
			let lon = location.coordinate.longitude
			weatherManager.fetchWeather(latitude: lat, longitude: lon)
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error)
	}
}
