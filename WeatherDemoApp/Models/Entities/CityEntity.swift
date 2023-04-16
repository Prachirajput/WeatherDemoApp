//
//  CityEntity.swift
//  WeatherDemoApp
//
//  Created by Prachi on 16/04/23.
//

import Foundation
import CoreData

@objc(CityEntity)
public class CityEntity: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityEntity> {
        return NSFetchRequest<CityEntity>(entityName: "CityEntity")
    }

    @NSManaged public var name: String
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double

    static func save(from city: CityModel) {
        let cityEntity = CityEntity(context: DataBaseService.shared.viewContext)
        
        cityEntity.name = city.localName
        cityEntity.lat = city.lat
        cityEntity.lon = city.lon
    }
}

extension CityEntity : Identifiable {

    public var id: String {
        return "\(lat) \(lon)"
    }
}
