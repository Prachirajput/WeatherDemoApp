//
//  ForecastResponse.swift
//  WeatherDemoApp
//
//  Created by Prachi on 16/04/23.
//


import Foundation

struct ForecastResponse: Decodable {
    let list: [Forecast]
}

struct Forecast: Decodable, Hashable {
    let dt: Date
    let main: TempData
    let weather: [WeatherDescription]
}
