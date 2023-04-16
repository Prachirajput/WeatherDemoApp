//
//  WeatherDemoAppTests.swift
//  WeatherDemoAppTests
//
//  Created by Prachi on 16/04/23.
//

import XCTest
@testable import WeatherDemoApp

final class WeatherDemoAppTests: XCTestCase, ObservableObject {
    private var searchModel = SearchCityViewModel()
    private let weatherService = WeatherService()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchCity() throws {
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
