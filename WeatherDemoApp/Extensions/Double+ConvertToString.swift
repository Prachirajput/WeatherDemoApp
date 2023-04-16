//
//  Double+ConvertToString.swift
//  WeatherDemoApp
//
//  Created by Prachi on 16/04/23.
//

import Foundation

extension Double {
    
    var toTempString: String {
        return String(format: "%.1f", self) + "°"
    }
}
