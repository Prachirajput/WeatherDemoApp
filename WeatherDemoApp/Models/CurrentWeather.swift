//
//  CurrentWeather.swift
//  WeatherDemoApp
//
//  Created by Prachi on 16/04/23.
//

import Foundation

struct CurrentWeather: Decodable {
    let name: String
    let coord: Coordinates
    let main: TempData
    let weather: [WeatherDescription]
}



