//
//  ContentView.swift
//  WeatherDemoApp
//
//  Created by Prachi on 16/04/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme
    
    @ObservedObject private var viewModel = FrontPageViewModel()

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(
            keyPath: \CityEntity.name,
            ascending: true
        )],
        animation: .default
    )
    private var cityEntities: FetchedResults<CityEntity>
    
    @State private var showList: Bool = false
    @State private var tabSelection = 0
    
    var body: some View {
        NavigationView {
            VStack {
                tabView
            }
            .background(
                colorScheme == .light
                ? Color(UIColor.systemGray6)
                : .black
            )
            .navigationBarHidden(true)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button(action: {
                        showList = true
                    }) {
                        Image("list.bullet")
                    }
                    .foregroundColor(.primary)
                }
            }
            .fullScreenCover(isPresented: $showList) {
                SearchCityView(tabSelection: $tabSelection)
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

private extension ContentView {
    
    var tabView: some View {
        TabView(selection: $tabSelection) {
            CityView(city: nil, isCitySaved: true, isPresented: false)
                .tag(0)
            ForEach(Array(cityEntities.enumerated()), id: \.element) { cityEntity in
                CityView(
                    city: CityModel(from: cityEntity.element),
                    isCitySaved: true,
                    isPresented: false
                )
                .tag(cityEntity.offset + 1)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, DataBaseService.shared.viewContext)
    }
}
