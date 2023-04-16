//
//  CityModel.swift
//  WeatherDemoApp
//
//  Created by Prachi on 16/04/23.
//

import Foundation
struct CityModel: Decodable, Hashable {
    let name: String
    let lat: Double
    let lon: Double
    let localNames: [String: String]?
    
    var localName: String {
        localNames?[Locale.current.language.languageCode?.identifier ?? "en"] ?? name
    }
    
    var coordinates: Coordinates {
        Coordinates(lat: lat, lon: lon)
    }
}

extension CityModel {
    
    init(from entity: CityEntity) {
        name = entity.name
        lat = entity.lat
        lon = entity.lon
        localNames = nil
    }
}

extension CityModel: Identifiable {
    
    var id: String {
        return "\(lat) \(lon)"
    }
}

