//
//  SearchCityView.swift
//  WeatherDemoApp
//
//  Created by Prachi on 16/04/23.
//

import SwiftUI


struct SearchCityView: View {
    @Binding var tabSelection: Int
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

        var btnBack : some View { Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                Image("back") // set image here
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    Text("Go back")
                }
            }
        }
        
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var viewModel = SearchCityViewModel()
    
    @State private var cityToShow: CityModel?
    @State private var isCitySaved: Bool = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(
            keyPath: \CityEntity.name,
            ascending: true
        )],
        animation: .default
    )
    private var cityEntities: FetchedResults<CityEntity>
    
    var body: some View {
        NavigationView {
            getCityList()
                .foregroundColor(.primary)
                .searchable(text: $viewModel.cityName, prompt: "Search city")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: btnBack)
                .sheet(item: $cityToShow) { [isCitySaved] city in
                    CityView(
                        city: city,
                        isCitySaved: isCitySaved,
                        isPresented: true
                    )
                }
        }
    }
}

private extension SearchCityView {
    
    @ViewBuilder
    func getCityList() -> some View {
        if viewModel.cityName.isEmpty {
            List {
                ForEach(Array(cityEntities.enumerated().reversed()), id: \.element) { cityEntity in
                    Button(cityEntity.element.name ) {
                        tabSelection = cityEntity.offset + 1
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
                }
                .onDelete(perform: deleteCity)
            }
        } else {
            List(viewModel.cityList) { city in
                Button(city.localName) {
                    cityToShow = city
                    isCitySaved = cityEntities.contains(where: { $0.id == city.id })
                }
                .padding()
            }
        }
    }
}

private extension SearchCityView {
    
    func deleteCity(offsets: IndexSet) {
        withAnimation {
            offsets.map { cityEntities[$0] }.forEach(viewContext.delete)
            DataBaseService.shared.saveContext()
        }
    }
}

struct SearchCityView_Previews: PreviewProvider {
    static var previews: some View {
        SearchCityView(tabSelection: .constant(1))
            .environment(\.managedObjectContext, DataBaseService.shared.viewContext)
    }
}
