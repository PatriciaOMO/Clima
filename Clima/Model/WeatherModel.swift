//
//  WeatherModel.swift
//  Clima
//
//  Created by Patricia Obregon on 1/16/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
	let conditionId: Int
	let cityName: String
	let temperature: Double
	
	var tempString: String {
		return String(format: "%.0f", temperature)
	}
	
	var conditionName: String {
		switch conditionId {
		case 200...232 :
			return "cloud.bolt"
		case 300...321 :
				return "cloud.drizzel"
		case 500...531 :
				return "cloud.rain"
		case 600...622 :
				return "cloud.snow"
		case 701...781 :
				return "cloud.fog"
		case 800       :
				return "sun.max"
		case 801...804 :
				return "cloud"
		default :
				return "nothing"
		}
	}
	

}
