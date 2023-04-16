//
//  DataBaseService.swift
//  WeatherDemoApp
//
//  Created by Prachi on 16/04/23.
//

import Foundation
import CoreData

final class DataBaseService {
    static let shared = DataBaseService()
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherDemoApp")
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
