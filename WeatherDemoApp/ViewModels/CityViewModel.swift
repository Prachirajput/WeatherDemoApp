//
//  CityViewModel.swift
//  WeatherDemoApp
//
//  Created by Prachi on 16/04/23.
//

import Foundation
import Combine
import CoreLocation

final class CityViewModel: NSObject, ObservableObject {
    
    var isNeedUpdate = PassthroughSubject<Void, Never>()
    
    @Published private (set) var weather: CurrentWeather?
    @Published private (set) var error: Error?
    @Published private (set) var currentCityName: String?
    @Published private (set) var isLocationEnabled: Bool?
    
    private let coordinates: Coordinates?
    
    private let weatherService = WeatherService()
    private var bag = Set<AnyCancellable>()
    
    private let locationService = LocationService()
    
    init(coordinates: Coordinates?) {
        self.coordinates = coordinates
        super.init()
        configurePublishers()
    }
    
    func saveCity(city: CityModel) {
        CityEntity.save(from: city)
        DataBaseService.shared.saveContext()
    }
}

private extension CityViewModel {
    
    func configurePublishers() {
        if coordinates == nil {
            locationService.start()
        }
        
        let presetCoordinates = isNeedUpdate
            .compactMap { [weak self] _ in
                self?.coordinates
            }
        
        let geoCoordinates = Publishers.CombineLatest(isNeedUpdate, locationService.$location)
            .compactMap { _ , location -> Coordinates? in
                guard let coordinate = location?.coordinate else { return nil }
                return Coordinates(
                    lat: coordinate.latitude,
                    lon: coordinate.longitude
                )
            }
        
        Publishers.Merge(presetCoordinates, geoCoordinates)
            .flatMap { [weatherService] coordinates in
                Publishers.CombineLatest(
                    weatherService.getCurrentWeather(coordinates: coordinates),
                    weatherService.getForecast(coordinates: coordinates)
                )
            }
        .receive(on: RunLoop.main)
        .sink { [weak self] completion in
            if case let .failure(error) = completion {
                self?.error = error
            }
        } receiveValue: { [weak self] weather, forecast in
            guard let self = self else { return }
            self.weather = weather
        }
        .store(in: &bag)
        
        locationService.$currentCityName
            .assign(to: &$currentCityName)
        
        locationService.$authorizationStatus
            .removeDuplicates()
            .compactMap { [coordinates] in
                guard let status = $0, coordinates == nil, status != .notDetermined else { return nil }
                return [.authorizedAlways, .authorizedWhenInUse].contains(status)
            }
            .assign(to: &$isLocationEnabled)
    }
    
}

