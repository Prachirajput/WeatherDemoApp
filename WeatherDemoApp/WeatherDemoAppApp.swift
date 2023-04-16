//
//  WeatherDemoApp.swift
//  WeatherDemoApp
//
//  Created by Prachi on 16/04/23.
//

import SwiftUI

@main
struct WeatherDemoAppApp: App {

    var body: some Scene {
        WindowGroup {
            FrontPageView()
                .environment(\.managedObjectContext, DataBaseService.shared.viewContext)
        }
    }
}
