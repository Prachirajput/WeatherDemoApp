//
//  WeatherEndpoint.swift
//  WeatherDemoApp
//
//  Created by Prachi on 16/04/23.
//

import Foundation

enum WeatherEndpoint {
    case currentWeather(coordinates: Coordinates)
    case forecast(coordinates: Coordinates)
    case find(name: String)
}

extension WeatherEndpoint: EndpointProtocol {
    
    static let apiKey = "2b9d27d3c5ea8d79e0199dcd64c579be"
    
    var host: String {
        "api.openweathermap.org"
    }
    
    var path: String {
        switch self {
        case .currentWeather:
            return "/data/2.5/weather"
        case .forecast:
            return "/data/2.5/forecast"
        case .find:
            return "/geo/1.0/direct"
        }
    }
    
    var params: [String : String] {
        var params = ["appid": WeatherEndpoint.apiKey, "lang": Locale.current.language.languageCode?.identifier ?? "en", "units": "metric"]
        switch self {
        case let .currentWeather(coordinates),
             let .forecast(coordinates):
            params["lat"] = coordinates.lat.description
            params["lon"] = coordinates.lon.description
        case let .find(name):
            params["q"] = name
            params["limit"] = "0"
        }
        return params
    }
}
