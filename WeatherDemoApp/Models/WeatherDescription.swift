//
//  WeatherDescription.swift
//  WeatherDemoApp
//
//  Created by Prachi on 16/04/23.
//

import Foundation

struct WeatherDescription: Decodable, Hashable {
    let main: WeatherStatus
    let description: String
}
