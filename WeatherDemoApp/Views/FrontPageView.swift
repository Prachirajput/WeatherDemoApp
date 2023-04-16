//
//  FrontPageView.swift
//  WeatherDemoApp
//
//  Created by Prachi on 16/04/23.
//

import SwiftUI


struct FrontPageView: View {
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
                    Button("Search", action: {
                        showList = true
                    }).offset(x:0, y:50).font(.system(size: 36))
                Spacer()
                tabView.offset(x:0, y:50)

            }
            .background(
                colorScheme == .light
                ? Color(UIColor.systemGray6)
                : .black
            )
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showList) {
                SearchCityView(tabSelection: $tabSelection)
            }
        }
    }
}

private extension FrontPageView {
    
    var tabView: some View {
        TabView(selection: $tabSelection) {
            ForEach(Array(cityEntities.enumerated().reversed()), id: \.element) { cityEntity in
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

struct FrontPageView_Previews: PreviewProvider {
    static var previews: some View {
        FrontPageView()
            .environment(\.managedObjectContext, DataBaseService.shared.viewContext)
    }
}
