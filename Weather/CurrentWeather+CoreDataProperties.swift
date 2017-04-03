//
//  CurrentWeather+CoreDataProperties.swift
//  
//
//  Created by Kryg Tomasz on 03.04.2017.
//
//

import Foundation
import CoreData


extension CurrentWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentWeather> {
        return NSFetchRequest<CurrentWeather>(entityName: "CurrentWeather");
    }

    @NSManaged public var date: Int32
    @NSManaged public var location: String?
    @NSManaged public var temperature: Int16
    @NSManaged public var weatherDescription: String?
    
    public func save() {
        
        do {
            try self.managedObjectContext?.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }

}
