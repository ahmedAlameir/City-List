//
//  DataManager.swift
//  city-list
//
//  Created by ahmed osama on 30/08/2022.
//

import Foundation
import UIKit
import CoreData

class DataManager{
    public static let sharedInstance = DataManager()
    private func getContext() -> NSManagedObjectContext? {
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
           return appDelegate.persistentContainer.viewContext
       }
    func saveUserData(_ cities: [Cities]) {
        guard let managedContext = getContext() else { return }
        for city in cities {
            let newcity = NSEntityDescription.insertNewObject(forEntityName: "City", into: managedContext)
            newcity.setValue(city.id, forKey: "id")
            newcity.setValue(city.name, forKey: "name")
            newcity.setValue(city.country, forKey: "country")
            newcity.setValue(city.coord.lon, forKey: "lon")
            newcity.setValue(city.coord.lat, forKey: "lat")

        }
        do {
            try managedContext.save()
            print("Success")
        } catch {
            print("Error saving: \(error)")
        }
    }
    func retrieveSavedUsers(from:Int,to:Int) -> [Cities]? {
        guard let managedContext = getContext() else { return nil }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        request.returnsObjectsAsFaults = false
        var retrievedUCities: [Cities] = []
        do {
            let results = try managedContext.fetch(request) as! [NSManagedObject]
            if !results.isEmpty {
                if results.count <= from{
                    
                }else if results.count <= to{
                    for result in results[from..<results.count] {
                        guard let id = result.value(forKey: "id") as? String else { return nil }
                        guard let name = result.value(forKey: "name") as? String else { return nil }
                        guard let country = result.value(forKey: "country") as? String else { return nil }
                        guard let lat = result.value(forKey: "lat") as? String else { return nil }
                        guard let lon = result.value(forKey: "lon") as? String else { return nil }
                        let coord = Coord(lat: lat, lon: lon)
                        let city = Cities(country: country, name: name, id: id, coord: coord)
                        retrievedUCities.append(city)
                    }
                }else{
                for result in results[from..<to] {
                    guard let id = result.value(forKey: "id") as? String else { return nil }
                    guard let name = result.value(forKey: "name") as? String else { return nil }
                    guard let country = result.value(forKey: "country") as? String else { return nil }
                    guard let lat = result.value(forKey: "lat") as? String else { return nil }
                    guard let lon = result.value(forKey: "lon") as? String else { return nil }
                    let coord = Coord(lat: lat, lon: lon)
                    let city = Cities(country: country, name: name, id: id, coord: coord)
                    retrievedUCities.append(city)
                }
                }
            }
        } catch {
            print("Error retrieving: \(error)")
        }
        return retrievedUCities
    }
    func deleatAll(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        guard let managedContext = getContext() else { return  }

        fetchRequest.includesPropertyValues = false

        do {
            let results = try managedContext.fetch(fetchRequest) as! [NSManagedObject]

            for item in results {
                managedContext.delete(item)
            }
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
