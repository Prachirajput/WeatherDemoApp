//
//  SearchCityViewModel.swift
//  WeatherDemoApp
//
//  Created by Prachi on 16/04/23.
//

import Foundation
import Combine

final class SearchCityViewModel: ObservableObject {
    
    @Published var cityName = ""
    @Published private (set) var cityList = [CityModel]()
    
    private let weatherService = WeatherService()
    private var bag = Set<AnyCancellable>()
    
    init() {
        $cityName
            .dropFirst()
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { [weatherService] city in
                weatherService.findCity(name: city)
                    .replaceError(with: [])
            }
            .assign(to: \.cityList, on: self)
            .store(in: &bag)
    }
}
