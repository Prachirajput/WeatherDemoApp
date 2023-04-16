//
//  TempData.swift
//  WeatherDemoApp
//
//  Created by Prachi on 16/04/23.
//

import Foundation

struct TempData: Decodable, Hashable {
    let temp: Double
    let tempMax: Double
    let tempMin: Double
}
