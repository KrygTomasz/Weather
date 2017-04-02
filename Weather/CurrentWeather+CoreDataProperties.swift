//
//  CurrentWeather+CoreDataProperties.swift
//  
//
//  Created by Kryg Tomasz on 31.03.2017.
//
//

import Foundation
import CoreData


extension CurrentWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentWeather> {
        return NSFetchRequest<CurrentWeather>(entityName: "CurrentWeather");
    }

    @NSManaged public var weatherDescription: String?
    @NSManaged public var location: String?
    @NSManaged public var temperature: Int16
    @NSManaged public var date: NSDate?

}
