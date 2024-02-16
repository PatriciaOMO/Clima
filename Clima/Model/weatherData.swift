//
//  weatherData.swift
//  Clima
//
//  Created by Patricia Obregon on 1/15/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
	
	let name: String
	
	let main: Main
	
	let weather: [Weather]
	
	let wind: Wind
}

struct Main: Codable {
	let temp: Double
	
}

struct Weather: Codable {
	
	let id: Int
}

struct Wind: Codable {
	let speed: Double
}


