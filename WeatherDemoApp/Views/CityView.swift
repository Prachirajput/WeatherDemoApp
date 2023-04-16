//
//  CityView.swift
//  WeatherDemoApp
//
//  Created by Prachi on 16/04/23.
//

import SwiftUI
import Combine

struct CityView: View {
    let city: CityModel?
    let isCitySaved: Bool
    let isPresented: Bool
    
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var viewModel: CityViewModel
    
    init(city: CityModel?, isCitySaved: Bool, isPresented: Bool) {
        self.city = city
        self.isCitySaved = isCitySaved
        self.isPresented = isPresented
        
        viewModel = CityViewModel(coordinates: city?.coordinates)
    }
    
    var body: some View {
        VStack {
            if viewModel.isLocationEnabled == false {
                disableLocationError
            } else {
                if isPresented {
                    toolBarItems
                    Spacer()
                }
                configureWeatherList(
                    weather: viewModel.weather
                )
            }
        }
        .background(Color(UIColor.systemGray6))
        .onAppear {
            viewModel.isNeedUpdate.send()
        }
    }
}

private extension CityView {
    
    var disableLocationError: some View {
        VStack(spacing: 8) {
            Text("Allow the app to detect your current location")
                .font(.system(size: 24))
                .multilineTextAlignment(.center)
                
            Button("Open settings") {
                if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            .foregroundColor(.white)
            .font(.system(size: 20))
            .padding()
            .background(.blue)
            .cornerRadius(10)
        }
    }
    
    var toolBarItems: some View {
        HStack {
            Button("Cancel") {
                if let city = city, !isCitySaved {
                    viewModel.saveCity(city: city)
                }
                presentationMode.wrappedValue.dismiss()
            }
            .padding(.leading)
        }
        .padding(.top)
    }
    
    func configureWeatherList(
        weather: CurrentWeather?
    ) -> some View {
        List {
            CurrentWeatherView(
                weather: weather,
                name: city?.localName ?? viewModel.currentCityName ?? ""
            )
            .listRowBackground(Color.clear)
        }
    }
}

struct CityView_Previews: PreviewProvider {
    static var previews: some View {
        CityView(
            city: .init(
                name: "Dallas",
                lat: 56.839104,
                lon: 60.60825,
                localNames: nil
            ),
            isCitySaved: false,
            isPresented: false
        )
    }
}

