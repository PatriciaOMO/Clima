//
//  WeatherManager.swift
//  Clima
//
//  Created by Patricia Obregon on 5/12/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
	func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
	func didFailWithError(error: Error)
}

struct WeatherManager {
	
//	var weatherIcon: String
	let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=f877fe994ebf84c69fb4f431432569ff&units=imperial"
	// http://api.openweathermap.org/geo/1.0/reverse?lat={lat}&lon={lon}&limit={limit}&appid={API key}
	var delegate: WeatherManagerDelegate?
	
	func fetchWeather (cityName: String ) {
		let urlString = "\(weatherURL)&q=\(cityName)"
		performRequest(with: urlString)
	}
	
	func fetchWeather (latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
		let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
		performRequest(with: urlString)
	}
	
	func performRequest (with urlString: String) {
		
		//1. create a URL
		if let url = URL(string: urlString) {
			
			//2. create a URLSession
			// "it's the thing that can perform the networking"
			let session = URLSession(configuration: .default)
			
			//3. give the session a task
			// "creates a task that retrieves the contents of the url then calls a handler upon completion"
			// returns a task
			
			let task = session.dataTask(with: url) { data, response, error in
				if error != nil {
					self.delegate?.didFailWithError(error: error!)
					return
				}
				
				if let safeData = data {
					if let weather = self.parseJson(safeData) {
						delegate?.didUpdateWeather(self, weather: weather)
					}
				}
			}
			
			//4. start the task
			task.resume()
		}
	}
	
	func parseJson(_ weatherData: Data) -> WeatherModel? {
		let decoder = JSONDecoder()
		do {
			
			let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
			let id = decodedData.weather[0].id
			let temp = decodedData.main.temp
			let name = decodedData.name
			
			let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
			return weather
//			print(weather.conditionName)
//			print(weather.temperature)
//			print(weather.tempString)
			
		} catch {
			delegate?.didFailWithError(error: error)
			return nil
		}
	}
	
	
	
	
}


